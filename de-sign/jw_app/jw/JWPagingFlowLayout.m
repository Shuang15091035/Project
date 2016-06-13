//
//  JWPagingFlowLayout.m
//  jw_app
//
//  Created by ddeyes on 16/4/20.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWPagingFlowLayout.h"

@implementation JWPagingFlowLayout

-(id)init{
    self = [super init];
    if (self != nil) {
        // TODO 暂写死为横向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGRect cvBounds = self.collectionView.bounds;
    CGFloat halfWidth = cvBounds.size.width * 0.5f;
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
    
    NSArray* attributesArray = [self layoutAttributesForElementsInRect:cvBounds];
    
    UICollectionViewLayoutAttributes* candidateAttributes = nil;
    for (UICollectionViewLayoutAttributes* attributes in attributesArray) {
        
        // == Skip comparison with non-cell items (headers and footers) == //
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        
        // == First time in the loop == //
        if(candidateAttributes == nil) {
            candidateAttributes = attributes;
            continue;
        }
        
        if (fabsf(attributes.center.x - proposedContentOffsetCenterX) < fabsf(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
            candidateAttributes = attributes;
        }
    }
    
    return CGPointMake(candidateAttributes.center.x - halfWidth, proposedContentOffset.y);
    
}

@end
