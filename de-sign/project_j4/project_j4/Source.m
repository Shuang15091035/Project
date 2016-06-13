//
//  Source.m
//  project_mesher
//
//  Created by MacMini on 15/10/13.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Source.h"

@interface Source () {
    NSInteger mId;
    NSString* mName;
    SourceType mType;
    id<ICVFile> mFile;
    id<ICVFile> mPreview;
}

@end

@implementation Source

@synthesize Id = mId;
@synthesize name = mName;
@synthesize type = mType;
@synthesize file = mFile;
@synthesize preview = mPreview;



@end
