//
//  JWAdapter.m
//  June Winter
//
//  Created by GavinLo on 14-3-1.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAdapter.h"
#import <jw/JCMath.h>
#import <jw/JWViewHolder.h>
#import "UIControl+JWUiCategory.h"
#import "UIView+JWAdapterItemView.h"
#import <jw/NSArray+JWCoreCategory.h>

// NOTE 实现record与viewHolder的绑定，解决adapter数据更新时，selected等ui状态的预设置
@interface JWAdapterDataItem : NSObject {
    id mRecord;
    id<JIViewHolder> mHolder;
    BOOL mHighlighted;
    BOOL mSelected;
}

- (id) initWithRecord:(id)record;

@property (nonatomic, readwrite) id record;
@property (nonatomic, readwrite) id<JIViewHolder> holder;
@property (nonatomic, readwrite) BOOL highlighted;
@property (nonatomic, readwrite) BOOL selected;

@end

@implementation JWAdapterDataItem

- (id)initWithRecord:(id)record {
    self = [super init];
    if (self != nil) {
        mRecord = record;
        mHighlighted = NO;
        mSelected = NO;
    }
    return self;
}

@synthesize record = mRecord;
@synthesize holder = mHolder;
@synthesize highlighted = mHighlighted;
@synthesize selected = mSelected;

@end

@interface JWAdapter () {
    id<JIAdapterView> mAdapterView;
}

@end

@implementation JWAdapter

+ (id)adapter {
    return [[self alloc] init];
}

- (NSUInteger)getCount {
    return 0;
}

- (id)getItemAt:(NSUInteger)position {
    return nil;
}

- (NSUInteger)getViewTypeAt:(NSUInteger)position {
    return 0;
}

- (NSUInteger)getViewTypeCount {
    return 1;
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    return CGSizeZero;
}

- (UIView *)getViewAt:(NSUInteger)position convertView:(UIView *)convertView parent:(UIView *)parent {
    return nil;
}

- (void)removeViewAt:(NSUInteger)position view:(UIView *)view parent:(UIView *)parent {
    
}

- (id<JIAdapterView>)adapterView {
    return mAdapterView;
}

- (void)setAdapterView:(id<JIAdapterView>)adapterView {
    mAdapterView = adapterView;
}

- (void)onItem:(NSUInteger)position highlighted:(BOOL)highlighted {
    
}

- (void)onItem:(NSUInteger)position selected:(BOOL)selected {
    
}

- (void)onItemWillCompleteShow:(NSUInteger)position {
    
}

@end

#pragma mark JWListAdapter无限item
#define JWListAdapterInfiniteItems 10000 // NOTE 设置一个很大的值，但不能设置为NSUIntegerMax

@interface JWListAdapter () {
    NSArray* mData;
    BOOL mLoop;
    NSMutableArray* mDataItems;
    NSMutableArray* mHolders;
}

@end

@implementation JWListAdapter

- (NSArray *)data {
    return mData;
}

- (void)setData:(NSArray *)data {
    mData = data;
    if (mDataItems == nil) {
        mDataItems = [NSMutableArray array];
    }
    [mDataItems clear];
    if (data != nil) {
        for (id record in data) {
            JWAdapterDataItem* item = [[JWAdapterDataItem alloc] initWithRecord:record]; // TODO 优化创建过程
            [mDataItems add:item];
        }
    }
}

- (BOOL)isLoop {
    return mLoop;
}

- (void)setLoop:(BOOL)loop {
    mLoop = loop;
}

- (NSUInteger)getCount {
    if (mData == nil) {
        return 0;
    }
    if (mLoop) {
        return JWListAdapterInfiniteItems;
    }
    return mData.count;
}

- (NSUInteger)getIndexAt:(NSUInteger)position {
    if (mDataItems == nil) {
        return 0;
    }
    if (mLoop) {
        position = JCLoopi(position, 0, mDataItems.count);
    }
    return position;
}

- (id)getItemAt:(NSUInteger)position {
    if (mData == nil) {
        return nil;
    }
    if (mLoop) {
        position = JCLoopi(position, 0, mData.count);
    }
    return [mData at:position];
}

- (CGSize)getViewSizeAt:(NSUInteger)position {
    @throw [NSException exceptionWithName:@"NotImplementException" reason:@"[JWListAdapter.getViewSizeAt] must be implemented." userInfo:nil];
}

- (UIView *)getViewAt:(NSUInteger)position convertView:(UIView *)convertView parent:(UIView *)parent {
    UIView* view = convertView;
    id<JIViewHolder> holder = nil;
    if (view == nil) {
        holder = [self createViewHolder];
        view = [holder onCreateView:[NSBundle mainBundle] viewType:[self getViewTypeAt:position] parent:parent];
        view.extra.holder = holder;
    } else {
        holder = view.extra.holder;
        [holder onReuseView:view];
    }
    
    JWAdapterDataItem* dataItem = [self getDataItemAt:position];
    if (dataItem != nil) {
        [holder setRecord:dataItem.record];
        JWViewHolder* h = (JWViewHolder*)holder;
        [h onHighlighted:dataItem.highlighted];
        [h onSelected:dataItem.selected];
        dataItem.holder = holder;
    }
    return view;
}

- (void)removeViewAt:(NSUInteger)position view:(UIView *)view parent:(UIView *)parent {
//    if (mHolders == nil)
//        return;
//    id<JIViewHolder> holder = [mHolders at:position];
//    if(holder != nil)
//        [holder onDestroyView:view];
//    [mHolders set:position object:nil];
    // TODO 暂不实现
}

- (id<JIViewHolder>) createViewHolder {
    if (mHolders == nil) {
        mHolders = [NSMutableArray array];
    }
    id<JIViewHolder> holder = [self onCreateViewHolder];
    JWViewHolder* h = holder;
    h.adapter = self;
    [mHolders add:holder];
    return holder;
}

- (id)getDataItemAt:(NSUInteger)position {
    if (mDataItems == nil) {
        return nil;
    }
    if (mLoop) {
        position = JCLoopi(position, 0, mDataItems.count);
    }
    return [mDataItems at:position];
}

- (id<JIViewHolder>)onCreateViewHolder {
    @throw [NSException exceptionWithName:@"NotImplementException" reason:@"[JWListAdapter.onCreateViewHolder] must be implemented." userInfo:nil];
}

- (void)onItem:(NSUInteger)position highlighted:(BOOL)highlighted {
    JWAdapterDataItem* dataItem = [self getDataItemAt:position];
    if (dataItem != nil) {
        dataItem.highlighted = highlighted;
        JWViewHolder* h = (JWViewHolder*)dataItem.holder;
        if (h != nil) {
            [h onHighlighted:dataItem.highlighted];
        }
    }
}

- (void)onItem:(NSUInteger)position selected:(BOOL)selected {
    JWAdapterDataItem* dataItem = [self getDataItemAt:position];
    if (dataItem != nil) {
        dataItem.selected = selected;
        JWViewHolder* h = (JWViewHolder*)dataItem.holder;
        if (h != nil) {
            [h onSelected:dataItem.selected];
        }
    }
}

- (void)onItemWillCompleteShow:(NSUInteger)position {
    JWAdapterDataItem* dataItem = [self getDataItemAt:position];
    if (dataItem != nil) {
        JWViewHolder* h = (JWViewHolder*)dataItem.holder;
        if (h != nil) {
            [h willCompleteShow];
        }
    }
}

@end
