//
//  JWAdapterView.h
//  June Winter
//
//  Created by GavinLo on 14-3-1.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWAdapter.h>

@protocol JIAdapterView <JIDataSetObserver>

@property (nonatomic, readwrite) id<JIAdapter> adapter;

@end

@interface JWAdapterView : NSObject <JIAdapterView> {
    id<JIAdapter> mAdapter;
    id<JIAdapterView> mAdapterView;
}

- (id) initWithAdapterView:(id<JIAdapterView>)adapterView;
+ (id) viewWithAdapterView:(id<JIAdapterView>)adapterView;

@end

typedef void (^JWListAdapterViewOnItemClickBlock)(NSUInteger position, id item); // TODO 废除
//typedef void (^JWListAdapterViewOnItemSelectedBlock)(NSUInteger position, id item);
//typedef void (^JWListAdapterViewOnItemTouchDownBlock)(NSUInteger position, id item, NSSet* touches, UIEvent* event);
typedef void (^JWListAdapterViewOnItemHighlightedBlock)(NSUInteger position, id item, UIView* itemView, BOOL highlighted);
typedef void (^JWListAdapterViewOnItemSelectedBlock)(NSUInteger position, id item, BOOL selected);
typedef void (^JWListAdapterViewOnItemWillCompleteShowBlock)(NSUInteger position, id item);
typedef void (^JWListAdapterViewOnItemEventBlock)(int what, NSUInteger position, id item);

#pragma mark JWListAdapterView
@protocol JIListAdapterView <JIAdapterView>

@property (nonatomic, readwrite) JWListAdapterViewOnItemClickBlock onItemClick;
//@property (nonatomic, readwrite) JWListAdapterViewOnItemSelectedBlock onItemSelected;
//@property (nonatomic, readwrite) JWListAdapterViewOnItemTouchDownBlock onItemTouchDown;
@property (nonatomic, readwrite) JWListAdapterViewOnItemHighlightedBlock onItemHighlighted;
@property (nonatomic, readwrite) JWListAdapterViewOnItemSelectedBlock onItemSelected;
@property (nonatomic, readwrite) JWListAdapterViewOnItemWillCompleteShowBlock onItemWillCompleteShow;
@property (nonatomic, readwrite) JWListAdapterViewOnItemEventBlock onItemEvent;

- (void) selectItemAtPosition:(NSUInteger)position animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;

@end

@interface JWListAdapterView : JWAdapterView <JIListAdapterView> {
    JWListAdapterViewOnItemClickBlock mOnItemClick;
//    JWListAdapterViewOnItemSelectedBlock mOnItemSelected;
//    JWListAdapterViewOnItemTouchDownBlock mOnItemTouchDown;
    JWListAdapterViewOnItemHighlightedBlock mOnItemHighlighted;
    JWListAdapterViewOnItemSelectedBlock mOnItemSelected;
    JWListAdapterViewOnItemWillCompleteShowBlock mOnItemWillCompleteShow;
    JWListAdapterViewOnItemEventBlock mOnItemEvent;
}

@end

typedef struct {
    
    NSUInteger firstVisibleItem;
    NSUInteger visibleItemCount;
    NSUInteger maxAreaItem;
    
}JWAdapterScrollViewVisibleItemInfo;

typedef void (^JWAdapterScrollViewOnCurrentItemChangedBlock)(id<JIAdapterView> view, NSUInteger currentItem, NSUInteger previousItem);
typedef void (^JWAdapterScrollViewOnScrollBlock)(id<JIAdapterView> view);
typedef void (^JWAdapterScrollViewOnScrolledBlock)(id<JIAdapterView> view, NSUInteger firstVisibleItem, NSUInteger visibleItemCount, NSUInteger totalItemCount);

@protocol JIAdapterScrollView <JIListAdapterView>

/**
 * 表示当前能看到的占比面积最大的项
 */
//@property (nonatomic, readwrite) NSUInteger currentItem;
@property (nonatomic, readonly) NSUInteger currentItem;
@property (nonatomic, readwrite) JWAdapterScrollViewOnCurrentItemChangedBlock onCurrentItemChanged;

@property (nonatomic, readonly) BOOL scrollByUser;
@property (nonatomic, readwrite) JWAdapterScrollViewOnScrollBlock onScroll;
@property (nonatomic, readwrite) JWAdapterScrollViewOnScrolledBlock onScrolled;

@end

@interface JWAdapterScrollView : JWListAdapterView <JIAdapterScrollView> {
    NSUInteger mCurrentItem;
    JWAdapterScrollViewOnCurrentItemChangedBlock mOnCurrentItemChanged;
    BOOL mScrollByUser;
    JWAdapterScrollViewOnScrollBlock mOnScroll;
    JWAdapterScrollViewOnScrolledBlock mOnScrolled;
}

- (id) initWithAdapterScrollView:(id<JIAdapterScrollView>)adapterScrollView;
+ (id) viewWithAdapterScrollView:(id<JIAdapterScrollView>)adapterScrollView;
- (void) setCurrentItem:(NSUInteger)currentItem; // for internal use

@end