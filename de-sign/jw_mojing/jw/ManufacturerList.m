//
//  ManufacturerList.m
//  MojingSDKForiOS
//
//  Created by ge Xu on 6/1/16.
//  Copyright © 2016年 MojingSDKDev. All rights reserved.
//

#import "ManufacturerList.h"
#import "Manufacturer.h"
#import <MojingSDK/MojingIOSAPI.h>
#import "Product.h"
#import "Glass.h"
//厂家列表
@implementation MojingManufacturerList
static MojingManufacturerList* m_Instance;
@synthesize mClassName,mManufacturerList,mReleaseDate;
+(id)getInstance
{
    if(!m_Instance)
    {
        m_Instance = [[MojingManufacturerList alloc]init];
        [MojingManufacturerList PraseJsonManufactureList];
    }
    return m_Instance;
}
-(id)init
{
    self = [super init];
    self.mManufacturerList = [[NSMutableArray alloc] init];
    return  self;
}
-(NSMutableArray*)getAllDisplay
{
    NSMutableArray*displays = [[NSMutableArray alloc] init];
    for (MojingManufacturer* m in mManufacturerList)
    {
        [displays addObject:m.mDisplay];
    }
    return displays;
}
//
+(void)PraseJsonManufactureList
{
    // 获取厂商列表
    NSString* MenuFacture = MojingSDK_API_GetManufacturerList(@"zh");
    NSData* resData = [[NSData alloc] initWithData:[MenuFacture dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    
    if(error == nil)
    {
        NSArray* manufacturerArray = [resultDic objectForKey:@"ManufacturerList"];
        m_Instance = [[MojingManufacturerList alloc] init];
        m_Instance.mClassName = [resultDic valueForKey:@"ClassName"];
        m_Instance.mReleaseDate = [resultDic valueForKey:@"ReleaseDate"];
        // 以下代码用于遍历已经得到的厂商列表
        for(int i = 0 ;i < [manufacturerArray count] ;i ++)
        {
            NSDictionary* manufacturerDictionary = [manufacturerArray objectAtIndex:i];
            //获取厂家信息
            MojingManufacturer* manufacture = [[MojingManufacturer alloc] init];
            manufacture.mDisplay = [manufacturerDictionary objectForKey:@"Display"];
            manufacture.mKEY = [manufacturerDictionary objectForKey:@"KEY"];
            NSString* productJson = MojingSDK_API_GetProductList(manufacture.mKEY, @"zh");
            NSData* productData = [productJson dataUsingEncoding:NSUTF8StringEncoding];
            NSError* productError = nil;
            NSDictionary* productDict = [NSJSONSerialization JSONObjectWithData:productData options:0 error:&productError];
            NSArray* m_productArray = [productDict objectForKey:@"ProductList"];
            //以下代码用于遍历已经得到的厂商的产品列表
            for (int j = 0; j < [m_productArray count]; j ++)
            {
                NSDictionary* productListDictionary = [m_productArray objectAtIndex:j];
                MojingProduct* product = [[MojingProduct alloc] init];
                product.mDisplay = [productListDictionary objectForKey:@"Display"];
                product.mKEY = [productListDictionary objectForKey:@"KEY"];
                //获取产品信息
                NSString* classJson = MojingSDK_API_GetGlassList(product.mKEY, @"zh");
                NSData* classData = [classJson dataUsingEncoding:NSUTF8StringEncoding];
                NSError* classError = nil;
                NSDictionary* classListDict = [NSJSONSerialization JSONObjectWithData:classData options:0 error:&classError];
                NSArray* m_glassArray = [classListDict  objectForKey:@"GlassList"];
                // 以下代码用于遍历已经得到的产品的镜片列表
                for (int z = 0; z<[m_glassArray count]; z++) {
                    //获取镜片信息
                    NSDictionary* glassDictionary = [m_glassArray objectAtIndex:z];
                    MojingGlass* glass = [[MojingGlass alloc] init];
                    glass.mDisplay = [glassDictionary objectForKey:@"Display"];
                    glass.mKey = [glassDictionary objectForKey:@"KEY"];
                    [product.mGlassList addObject:glass];
                    
                }//end of for (int z = 0; z<[m_glassArray count]; z++)
                [manufacture.mProductList addObject:product];
                
            }//end of for (int j = 0; j < [m_productArray count]; j ++)
            [m_Instance.mManufacturerList addObject:manufacture];
        }//end of for(int i = 0 ;i < [manufacturerArray count] ;i ++)
    }
    
}


@end
