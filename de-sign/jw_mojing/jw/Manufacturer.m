//
//  Manufacturer.m
//  MojingSDKForiOS
//
//  Created by Xu ge on 16/1/6.
//  Copyright © 2016年 MojingSDKDev. All rights reserved.
//

#import "Manufacturer.h"
#import "Product.h"
#import "Glass.h"
//产品列表
@implementation MojingManufacturer
@synthesize mKEY,mDisplay,mURL,mProductList;
-(id)init
{
    self=[super init];
    self.mProductList = [[NSMutableArray alloc] init];
    return  self;
}
-(NSMutableArray*)getAllDisplay
{   //产品Dispaly
    NSMutableArray* displays = [[NSMutableArray alloc] init];
    //镜片Display
    NSMutableArray* glassDisplay = [[NSMutableArray alloc]init];
    NSMutableArray* DisplayArray = [[NSMutableArray alloc]init];
    for (MojingProduct* p in self.mProductList)
    {
        for (MojingGlass* g in p.mGlassList)
        {
            if(g.mDisplay.length == 0){
                [glassDisplay addObject:@" "];
            }
            else{
                [glassDisplay addObject: g.mDisplay];
            }
            [displays addObject: p.mDisplay];
        }
    }
    for (int i = 0; i<[displays count]; i++)
    {
        NSString* pDisplay = [displays objectAtIndex:i];
        NSString* gDisplay = [glassDisplay objectAtIndex:i];
        NSString* Display = [[pDisplay stringByAppendingString:@" "]stringByAppendingString:gDisplay];
        [DisplayArray addObject:Display];
        
    }
    
    return DisplayArray;
}
@end
