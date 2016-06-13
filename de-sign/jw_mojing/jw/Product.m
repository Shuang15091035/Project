//
//  Product.m
//  MojingSDKForiOS
//
//  Created by Xu ge on 16/1/6.
//  Copyright © 2016年 MojingSDKDev. All rights reserved.
//

#import "Product.h"
//眼镜列表
@implementation MojingProduct
@synthesize mKEY,mDisplay,mURL,mGlassList;
-(id)init
{
    self=[super init];
    self.mGlassList=[[NSMutableArray alloc] init];
    return self;
}
@end
