//
//  Manufacturer.h
//  MojingSDKForiOS
//
//  Created by Xu ge on 16/1/6.
//  Copyright © 2016年 MojingSDKDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MojingManufacturer : NSObject
@property(strong,nonatomic)NSString *mURL;
@property(strong,nonatomic)NSString *mDisplay;
@property(strong,nonatomic)NSString *mKEY;
@property(strong,nonatomic)NSMutableArray *mProductList;
-(NSMutableArray*)getAllDisplay;
@end
