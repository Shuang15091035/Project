//
//  JWCollectionView.m
//  jw_app
//
//  Created by ddeyes on 15/12/17.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCollectionView.h"
#import "JWExceptions.h"
#import "NSMutableArray+JWArrayList.h"
#import "UIView+JWUiLayout.h"
#import <jw/JCMath.h>
#import <jw/JWLayout.h>

@interface JWConllectionViewCell : UICollectionViewCell {
    UIView* mCellView;
}

@property (nonatomic, readwrite) UIView* cellView;

@end

@implementation JWConllectionViewCell

- (UIView *)cellView {
    return mCellView;
}

- (void)setCellView:(UIView *)cellView {
    if (cellView == nil) {
        return;
    }
    if (cellView.superview != self.contentView) {
        [cellView removeFromSuperview];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellView];
    }
    mCellView = cellView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [JWLayout handleWidthHeightForView:mCellView];
    [JWLayout handleAlignmentForView:mCellView];
}

@end

@interface JWCollectionView () {
    NSUInteger mNumColumns;
    BOOL mScrollByUser;
    NSUInteger mSelectedPosition;
}

@end

@implementation JWCollectionView

+ (id)collectionView {
    // NOTE avoid "UICollectionView must be initialized with a non-nil layout parameter"
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:[self createFlowLayout]];
}

+ (id)collectionViewWithFlowLayout:(UICollectionViewFlowLayout *)flowLayout {
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self onInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self != nil) {
        [self onInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self onInit];
    }
    return self;
}

- (void) onInit {
    // 默认显示方式设置
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    mAdapterScrollView = [JWAdapterScrollView viewWithAdapterScrollView:self];
    if (self.collectionViewLayout == nil) {
        self.collectionViewLayout = [JWCollectionView createFlowLayout];
    }
    self.dataSource = self;
    self.delegate = self;
    mNumColumns = JWCollectionViewNumColumnsAuto; // TODO 默认为自动排列，处理JWCollectionViewNumColumnsAuto以外的情况
    mSelectedPosition = NSUIntegerMax;
}

+ (UICollectionViewFlowLayout*) createFlowLayout {
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return layout;
}

// TODO 这里处理子view有问题，故不处理子view，由系统处理
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    if (!self.superview.hasLayoutParams) { // 如果父层不是layout框架中的控件，则首先处理自己
//        [JWLayout handleWidthHeightForView:self];
//    }
////    CGSize contentSize = CGSizeZero;
//    for (UIView* child in self.subviews) {
//        if ([child isKindOfClass:[UICollectionViewCell class]]) {
//            continue;
//        }
//        [JWLayout handleWidthHeightForView:child];
//        [JWLayout handleAlignmentForView:child];
////        CGRect frame = child.frame;
////        if (frame.size.width > contentSize.width) {
////            contentSize.width = frame.size.width;
////        }
////        if (frame.size.height > contentSize.height) {
////            contentSize.height = frame.size.height;
////        }
//    }
////    self.contentSize = contentSize;
//}

- (NSUInteger)numColumns {
    return mNumColumns;
}

- (void)setNumColumns:(NSUInteger)numColumns {
    if (numColumns == mNumColumns) {
        return;
    }
    mNumColumns = numColumns;
    //[self layoutIfNeeded];
    if (mAdapterScrollView.adapter != nil) {
        [mAdapterScrollView.adapter notifyDataSetChanged];
    }
}

#pragma mark visibleItemInfo 重要方法
- (JWAdapterScrollViewVisibleItemInfo)visibleItemInfo {
    NSArray* visibleCells = self.visibleCells;
    NSUInteger firstVisibleItem = NSUIntegerMax;
    NSUInteger visibleItemCount = visibleCells.count;
    CGFloat maxItemArea = -1.0f;
    NSUInteger maxAreaCell = NSUIntegerMax;
    
    if (visibleCells != nil) {
        for (UICollectionViewCell* cell in visibleCells) {
            NSIndexPath* indexPath = [self indexPathForCell:cell];
            NSUInteger position = indexPath.row;
            if (indexPath.row < firstVisibleItem) {
                firstVisibleItem = position;
            }
            // 计算cell在view中的面积
            CGRect bounds = self.bounds;
            CGRect cellFrame = cell.frame;
            CGFloat cellWidth = 0.0f;
            if (cellFrame.origin.x < bounds.origin.x) {
                cellWidth = cellFrame.origin.x + cellFrame.size.width - bounds.origin.x;
            } else {
                cellWidth = bounds.origin.x + bounds.size.width - cellFrame.origin.x;
            }
            CGFloat cellHeight = cellFrame.size.height;
            if (cell.frame.origin.y < bounds.origin.y) {
                cellHeight = cellFrame.origin.y + cellFrame.size.height - bounds.origin.y;
            } else {
                cellHeight = bounds.origin.y + bounds.size.height - cellFrame.origin.y;
            }
            CGFloat cellArea = cellWidth * cellHeight;
            if (cellArea > maxItemArea) {
                maxItemArea = cellArea;
                maxAreaCell = position;
            }
        }
    }
    JWAdapterScrollViewVisibleItemInfo visibleItemInfo;
    visibleItemInfo.firstVisibleItem = firstVisibleItem;
    visibleItemInfo.visibleItemCount = visibleItemCount;
    visibleItemInfo.maxAreaItem = maxAreaCell;
    return visibleItemInfo;
}

- (id<JIAdapter>)adapter {
    return mAdapterScrollView.adapter;
}

- (void)setAdapter:(id<JIAdapter>)adapter {
    [self unregisterAdapter:mAdapterScrollView.adapter];
    mAdapterScrollView.adapter = adapter;
    [self registerAdapter:mAdapterScrollView.adapter];
}

- (NSUInteger)currentItem {
    return mAdapterScrollView.currentItem;
}

//- (void)setCurrentItem:(NSUInteger)currentItem {
//    mAdapterScrollView.currentItem = currentItem;
//}

- (JWAdapterScrollViewOnCurrentItemChangedBlock)onCurrentItemChanged {
    return mAdapterScrollView.onCurrentItemChanged;
}

- (void)setOnCurrentItemChanged:(JWAdapterScrollViewOnCurrentItemChangedBlock)onCurrentItemChanged {
    mAdapterScrollView.onCurrentItemChanged = onCurrentItemChanged;
}

- (void) currentItemChangeTo:(NSUInteger)newItem {
    NSUInteger oldItem = self.currentItem;
    if (newItem == oldItem) {
        return;
    }
    if (mAdapterScrollView.onCurrentItemChanged != NULL) {
        mAdapterScrollView.onCurrentItemChanged(self, newItem, oldItem);
    }
    [mAdapterScrollView setCurrentItem:newItem];
}

- (JWListAdapterViewOnItemClickBlock)onItemClick {
    return mAdapterScrollView.onItemClick;
}

- (void)setOnItemClick:(JWListAdapterViewOnItemClickBlock)onItemClick {
    mAdapterScrollView.onItemClick = onItemClick;
}

- (JWListAdapterViewOnItemHighlightedBlock)onItemHighlighted {
    return mAdapterScrollView.onItemHighlighted;
}

- (void)setOnItemHighlighted:(JWListAdapterViewOnItemHighlightedBlock)onItemHighlighted {
    mAdapterScrollView.onItemHighlighted = onItemHighlighted;
}

- (JWListAdapterViewOnItemSelectedBlock)onItemSelected {
    return mAdapterScrollView.onItemSelected;
}

- (void)setOnItemSelected:(JWListAdapterViewOnItemSelectedBlock)onItemSelected {
    mAdapterScrollView.onItemSelected = onItemSelected;
}

- (JWListAdapterViewOnItemEventBlock)onItemEvent {
    return mAdapterScrollView.onItemEvent;
}

- (JWListAdapterViewOnItemWillCompleteShowBlock)onItemWillCompleteShow {
    return mAdapterScrollView.onItemWillCompleteShow;
}

- (void)setOnItemWillCompleteShow:(JWListAdapterViewOnItemWillCompleteShowBlock)onItemWillCompleteShow {
    mAdapterScrollView.onItemWillCompleteShow = onItemWillCompleteShow;
}

- (void)setOnItemEvent:(JWListAdapterViewOnItemEventBlock)onItemEvent {
    mAdapterScrollView.onItemEvent = onItemEvent;
}

@synthesize scrollByUser = mScrollByUser;

- (JWAdapterScrollViewOnScrollBlock)onScroll {
    return mAdapterScrollView.onScroll;
}

- (void)setOnScroll:(JWAdapterScrollViewOnScrollBlock)onScroll {
    mAdapterScrollView.onScroll = onScroll;
}

- (JWAdapterScrollViewOnScrolledBlock)onScrolled {
    return mAdapterScrollView.onScrolled;
}

- (void)setOnScrolled:(JWAdapterScrollViewOnScrolledBlock)onScrolled {
    mAdapterScrollView.onScrolled = onScrolled;
}

- (void)selectItemAtPosition:(NSUInteger)position animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:position inSection:0];
    JWAdapter* adapter = (JWAdapter*)mAdapterScrollView.adapter;
    if (position >= [adapter getCount]) { // 安全性检查
        return;
    }
    [self selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    mAdapterScrollView.currentItem = position;
    mScrollByUser = NO;
    
    if (mSelectedPosition != NSUIntegerMax) {
        if (adapter != nil) {
            [adapter onItem:mSelectedPosition selected:NO];
        }
    }
    mSelectedPosition = position;
    if (adapter != nil) {
        [adapter onItem:mSelectedPosition selected:YES];
    }
}

- (void) registerAdapter:(id<JIAdapter>)adapter {
    if (adapter == nil) {
        return;
    }
    for (NSUInteger i = 0; i < [mAdapterScrollView.adapter getViewTypeCount]; i++) {
        [self registerClass:[JWConllectionViewCell class] forCellWithReuseIdentifier:[self getIdentifierFromViewType:i adapter:adapter]];
    }
    JWAdapter* at = (JWAdapter*)adapter;
    at.adapterView = self;
}

- (void) unregisterAdapter:(id<JIAdapter>)adapter {
    if (adapter == nil) {
        return;
    }
    for (NSUInteger i = 0; i < [mAdapterScrollView.adapter getViewTypeCount]; i++) {
        [self registerClass:nil forCellWithReuseIdentifier:[self getIdentifierFromViewType:i adapter:adapter]];
    }
    JWAdapter* at = (JWAdapter*)adapter;
    at.adapterView = nil;
}

- (NSString*) getIdentifierFromViewType:(NSInteger)viewType adapter:(id<JIAdapter>)adapter {
    //return [NSString stringWithFormat:@"%@", [NSNumber numberWithLong:viewType]];
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([adapter class]), [NSNumber numberWithLong:viewType]];
}

- (void)onDataSetChanged:(id<JIDataSet>)dataSet {
    [self reloadData];
}

#pragma mark -
#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<JIAdapter> adapter = mAdapterScrollView.adapter;
    if (adapter == nil) {
        return 0;
    }
    return [adapter getCount];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // 使用1个section来实现一个整体的表格控件
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<JIAdapter> adapter = mAdapterScrollView.adapter;
    if (adapter == nil) {
        return nil;
    }
    NSUInteger position = [self getDataPositionFromIndexPath:indexPath];
    NSInteger viewType = [mAdapterScrollView.adapter getViewTypeAt:position];
    JWConllectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self getIdentifierFromViewType:viewType adapter:mAdapterScrollView.adapter] forIndexPath:indexPath];
    UIView* convertView = cell.cellView;
    UIView* view = [mAdapterScrollView.adapter getViewAt:position convertView:convertView parent:self];
    cell.cellView = view;
    return cell;
}

- (NSInteger) getDataPositionFromIndexPath:(NSIndexPath*)indexPath {
    // 只有1个section，直接返回row
    return indexPath.row;
}

#pragma mark -
#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger position = [self getDataPositionFromIndexPath:indexPath];
    JWConllectionViewCell* cell = (JWConllectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    UIView* itemView = cell.cellView;
    JWAdapter* adapter = (JWAdapter*)mAdapterScrollView.adapter;
    if (adapter != nil) {
        [adapter onItem:position highlighted:YES];
    }
    if (mAdapterScrollView.onItemHighlighted != nil) {
        mAdapterScrollView.onItemHighlighted(position, [mAdapterScrollView.adapter getItemAt:position], itemView, YES);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger position = [self getDataPositionFromIndexPath:indexPath];
    JWConllectionViewCell* cell = (JWConllectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    UIView* itemView = cell.cellView;
    JWAdapter* adapter = (JWAdapter*)mAdapterScrollView.adapter;
    if (adapter != nil) {
        [adapter onItem:position highlighted:NO];
    }
    if (mAdapterScrollView.onItemHighlighted != nil) {
        mAdapterScrollView.onItemHighlighted(position, [mAdapterScrollView.adapter getItemAt:position], itemView, NO);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger position = [self getDataPositionFromIndexPath:indexPath];
    JWAdapter* adapter = (JWAdapter*)mAdapterScrollView.adapter;
    if (adapter != nil) {
        [adapter onItem:position selected:YES];
    }
    if (mAdapterScrollView.onItemSelected != nil) {
        mAdapterScrollView.onItemSelected(position, [mAdapterScrollView.adapter getItemAt:position], YES);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger position = [self getDataPositionFromIndexPath:indexPath];
    JWAdapter* adapter = (JWAdapter*)mAdapterScrollView.adapter;
    if (adapter != nil) {
        [adapter onItem:position selected:NO];
    }
    if (mAdapterScrollView.onItemSelected != nil) {
        mAdapterScrollView.onItemSelected(position, [mAdapterScrollView.adapter getItemAt:position], NO);
    }
}

#pragma mark -
#pragma UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<JIAdapter> adapter = mAdapterScrollView.adapter;
    if (adapter == nil) {
        return CGSizeZero;
    }
    NSUInteger position = [self getDataPositionFromIndexPath:indexPath];
    CGSize size = [adapter getViewSizeAt:position];
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 设置cell的margin为全0，由item自己决定
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    // section与row之间同样不留空隙
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    // cell与cell之间不留空隙
    return 0.0f;
}

#pragma mark -
#pragma UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    mScrollByUser = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    mScrollByUser = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    mScrollByUser = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (mAdapterScrollView.onScroll != nil) {
        mAdapterScrollView.onScroll(self);
    }
    JWAdapterScrollViewVisibleItemInfo visibleItemInfo = self.visibleItemInfo;
    if (visibleItemInfo.maxAreaItem != NSUIntegerMax) {
//        [mAdapterScrollView setCurrentItem:visibleItemInfo.maxAreaItem];
        [self currentItemChangeTo:visibleItemInfo.maxAreaItem];
    }
}

// TODO 暂时只做滚动停止处理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    JWAdapterScrollViewVisibleItemInfo visibleItemInfo = self.visibleItemInfo;
    NSUInteger firstVisibleItem = visibleItemInfo.firstVisibleItem;
    if (firstVisibleItem == NSUIntegerMax) {
        return;
    }
    NSUInteger visibleItemCount = visibleItemInfo.visibleItemCount;
    if (visibleItemInfo.maxAreaItem != NSUIntegerMax) {
        //[mAdapterScrollView setCurrentItem:visibleItemInfo.maxAreaItem];
        [self currentItemChangeTo:visibleItemInfo.maxAreaItem];
    }
    NSUInteger totalItemCount = mAdapterScrollView.adapter == nil ? visibleItemCount : [mAdapterScrollView.adapter getCount];
    if (mAdapterScrollView.onScrolled != nil) {
        mAdapterScrollView.onScrolled(self, firstVisibleItem, visibleItemCount, totalItemCount);
    }
    
    JWAdapter* adapter = (JWAdapter*)mAdapterScrollView.adapter;
    if (adapter != nil) {
        [adapter onItemWillCompleteShow:visibleItemInfo.maxAreaItem];
    }
    if (mAdapterScrollView.onItemWillCompleteShow != nil) {
        mAdapterScrollView.onItemWillCompleteShow(visibleItemInfo.maxAreaItem, [mAdapterScrollView.adapter getItemAt:visibleItemInfo.maxAreaItem]);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // TODO 有可能为其他方法驱动，并非都是mSelectedPosition
    JWAdapter* adapter = (JWAdapter*)mAdapterScrollView.adapter;
    if (adapter != nil) {
        [adapter onItemWillCompleteShow:mSelectedPosition];
    }
    if (mAdapterScrollView.onItemWillCompleteShow != nil) {
        mAdapterScrollView.onItemWillCompleteShow(mSelectedPosition, [mAdapterScrollView.adapter getItemAt:mSelectedPosition]);
    }
}

@end
