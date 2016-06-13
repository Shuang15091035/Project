//
//  JWCollectionView.h
//  jw_app
//
//  Created by ddeyes on 15/12/17.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWAdapterView.h>

typedef NS_ENUM(NSUInteger, JWCollectionViewNumColumns) {
    JWCollectionViewNumColumnsAuto = 0,
};

/**
 * 万能控件
 */
@interface JWCollectionView : UICollectionView <JIAdapterScrollView, JIDataSetObserver, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    JWAdapterScrollView* mAdapterScrollView;
}

+ (id) collectionView;
+ (id) collectionViewWithFlowLayout:(UICollectionViewFlowLayout*)flowLayout;
@property (nonatomic, readwrite) NSUInteger numColumns;
@property (nonatomic, readonly) JWAdapterScrollViewVisibleItemInfo visibleItemInfo;

@end
