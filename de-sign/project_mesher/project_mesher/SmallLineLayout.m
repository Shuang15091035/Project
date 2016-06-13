//
//  SmallLineLayout.m
//  project_mesher
//
//  Created by mac zdszkj on 15/11/19.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "SmallLineLayout.h"
#import "MesherModel.h"

@implementation SmallLineLayout

#define ACTIVE_DISTANCE 0
#define ZOOM_FACTOR 0.3

-(id)init{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake([MesherModel uiWidthBy:110.0f], [MesherModel uiHeightBy:100.0f]);
//        self.headerReferenceSize = CGSizeMake([MesherModel uiWidthBy:400.0f], [MesherModel uiHeightBy:1000.0f]);
//        self.footerReferenceSize = CGSizeMake([MesherModel uiWidthBy:400.0f], [MesherModel uiHeightBy:1000.0f]);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat num = 0.0f;
        if ([UIDevice currentDevice].type == UIDeviceTypeIPad){
            num = 0;
        }else if([UIDevice currentDevice].type == UIDeviceTypeIPhone){
            num = 0;
        }
        self.sectionInset = UIEdgeInsetsMake(num, 0.0, num, 0.0);
        self.minimumLineSpacing = 0.0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
