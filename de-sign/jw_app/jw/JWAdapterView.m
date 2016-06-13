//
//  JWAdapterView.m
//  June Winter
//
//  Created by GavinLo on 14-3-11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAdapterView.h"
#import "JWExceptions.h"

@implementation JWAdapterView

- (id)init {
    return [self initWithAdapterView:self];
}

- (id)initWithAdapterView:(id<JIAdapterView>)adapterView {
    self = [super init];
    if (self != nil) {
        if(adapterView == nil) {
            mAdapterView = self;
        } else {
            mAdapterView = adapterView;
        }
    }
    return self;
}

+ (id)viewWithAdapterView:(id<JIAdapterView>)adapterView {
    return [[JWAdapterView alloc] initWithAdapterView:adapterView];
}

- (id<JIAdapter>)adapter {
    return mAdapter;
}

- (void)setAdapter:(id<JIAdapter>)adapter {
    [mAdapter unregisterDataSetObserver:mAdapterView];
    mAdapter = adapter;
    [mAdapter registerDataSetObserver:mAdapterView];
}

- (void)onDataSetChanged:(id<JIDataSet>)dataSet {
    
}

@end

@implementation JWListAdapterView

- (void)setAdapter:(id<JIAdapter>)adapter {
    if (![adapter isKindOfClass:[JWListAdapter class]]) {
        @throw [JWException exceptionWithName:@"Invalid Parameter" reason:@"must set a list adapter to JWListAdapterView" userInfo:nil];
    }
    [super setAdapter:adapter];
}

- (JWListAdapterViewOnItemClickBlock)onItemClick {
    return mOnItemClick;
}

- (void)setOnItemClick:(JWListAdapterViewOnItemClickBlock)onItemClick {
    mOnItemClick = onItemClick;
}

//- (JWListAdapterViewOnItemSelectedBlock)onItemSelected {
//    return mOnItemSelected;
//}
//
//- (void)setOnItemSelected:(JWListAdapterViewOnItemSelectedBlock)onItemSelected {
//    mOnItemSelected = onItemSelected;
//}
//
//- (JWListAdapterViewOnItemTouchDownBlock)onItemTouchDown {
//    return mOnItemTouchDown;
//}
//
//- (void)setOnItemTouchDown:(JWListAdapterViewOnItemTouchDownBlock)onItemTouchDown {
//    mOnItemTouchDown = onItemTouchDown;
//}

- (JWListAdapterViewOnItemHighlightedBlock)onItemHighlighted {
    return mOnItemHighlighted;
}

- (void)setOnItemHighlighted:(JWListAdapterViewOnItemHighlightedBlock)onItemHighlighted {
    mOnItemHighlighted = onItemHighlighted;
}

- (JWListAdapterViewOnItemSelectedBlock)onItemSelected {
    return mOnItemSelected;
}

- (void)setOnItemSelected:(JWListAdapterViewOnItemSelectedBlock)onItemSelected {
    mOnItemSelected = onItemSelected;
}

- (JWListAdapterViewOnItemWillCompleteShowBlock)onItemWillCompleteShow {
    return mOnItemWillCompleteShow;
}

- (void)setOnItemWillCompleteShow:(JWListAdapterViewOnItemWillCompleteShowBlock)onItemWillCompleteShow {
    mOnItemWillCompleteShow = onItemWillCompleteShow;
}

- (JWListAdapterViewOnItemEventBlock)onItemEvent {
    return mOnItemEvent;
}

- (void)setOnItemEvent:(JWListAdapterViewOnItemEventBlock)onItemEvent {
    mOnItemEvent = onItemEvent;
}

- (void)selectItemAtPosition:(NSUInteger)position animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    // subclass override
}

- (CGRect)rectForItemPosition:(NSUInteger)position {
    return CGRectZero;
}

@end

@implementation JWAdapterScrollView

- (id)initWithAdapterScrollView:(id<JIAdapterScrollView>)adapterScrollView {
    self = [super initWithAdapterView:adapterScrollView];
    if (self != nil) {
        // TODO nothing
    }
    return self;
}

+ (id)viewWithAdapterScrollView:(id<JIAdapterScrollView>)adapterScrollView {
    return [[JWAdapterScrollView alloc] initWithAdapterScrollView:adapterScrollView];
}

- (NSUInteger)currentItem {
    return mCurrentItem;
}

- (void)setCurrentItem:(NSUInteger)currentItem {
    mCurrentItem = currentItem;
}

- (JWAdapterScrollViewOnCurrentItemChangedBlock)onCurrentItemChanged {
    return mOnCurrentItemChanged;
}

- (void)setOnCurrentItemChanged:(JWAdapterScrollViewOnCurrentItemChangedBlock)onCurrentItemChanged {
    mOnCurrentItemChanged = onCurrentItemChanged;
}

@synthesize scrollByUser = mScrollByUser;

- (JWAdapterScrollViewOnScrollBlock)onScroll {
    return mOnScroll;
}

- (void)setOnScroll:(JWAdapterScrollViewOnScrollBlock)onScroll {
    mOnScroll = onScroll;
}

- (JWAdapterScrollViewOnScrolledBlock)onScrolled {
    return mOnScrolled;
}

- (void)setOnScrolled:(JWAdapterScrollViewOnScrolledBlock)onScrolled {
    mOnScrolled = onScrolled;
}

@end
