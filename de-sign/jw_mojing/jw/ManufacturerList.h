//
//  ManufacturerList.h
//  MojingSDKForiOS
//
//  Created by ge Xu on 6/1/16.
//  Copyright © 2016年 MojingSDKDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MojingManufacturerList : NSObject
@property(strong,nonatomic)NSString* mClassName;
@property(strong,nonatomic)NSString* mReleaseDate;
@property(strong,nonatomic)NSMutableArray* mManufacturerList;
-(NSMutableArray*)getAllDisplay;
+(id)getInstance;
@end

