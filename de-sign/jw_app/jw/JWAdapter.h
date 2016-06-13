//
//  JWAdapter.h
//  June Winter
//
//  Created by GavinLo on 14-3-1.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <jw/JWAppPredef.h>
#import <jw/JWDataSet.h>
#import <jw/NSMutableArray+JWArrayList.h>

@protocol JIAdapter <JIDataSet>

- (NSUInteger) getCount;
- (NSUInteger) getIndexAt:(NSUInteger)position;
- (id) getItemAt:(NSUInteger)position;
- (NSUInteger) getViewTypeAt:(NSUInteger)position;
- (NSUInteger) getViewTypeCount;

/**
 * NOTE 子类必须实现这个方法，因为使用Adapter的View在没有获取到每个项的大小时，不调用getViewAt方法创建对应的view
 *
 * 若只有一种类型的项，可以实现如下：
 // return size;
 *
 * 如果有多种类型的项，但是相同类型的项大小一样，可以实现如下：
 //    NSInteger viewType = [self getViewTypeAt:position];
 //    switch (viewType) {
 //        case 0: {
 //            return size0;
 //        }
 //        case 1: {
 //            return size1;
 //        }
 //        ...
 //    }
 //    return CGSizeZero;
 */
- (CGSize) getViewSizeAt:(NSUInteger)position;
- (UIView*) getViewAt:(NSUInteger)position convertView:(UIView*)convertView parent:(UIView*)parent;
- (void) removeViewAt:(NSUInteger)position view:(UIView*)view parent:(UIView*)parent;

@end

@interface JWAdapter : JWDataSet <JIAdapter>

+ (id) adapter;
@property (nonatomic, readwrite) id<JIAdapterView> adapterView;

- (void) onItem:(NSUInteger)position highlighted:(BOOL)highlighted;
- (void) onItem:(NSUInteger)position selected:(BOOL)selected;
- (void) onItemWillCompleteShow:(NSUInteger)position;

@end

@interface JWListAdapter : JWAdapter

@property (nonatomic, readwrite) NSArray* data;
@property (nonatomic, readwrite, getter=isLoop) BOOL loop;

- (id<JIViewHolder>) onCreateViewHolder;

@end
