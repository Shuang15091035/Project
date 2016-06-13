//
//  Data.m
//  project_mesher
//
//  Created by ddeyes on 15/10/23.
//  Copyright © 2015年 Zhongdong Digital Technology Co., Ltd. All rights reserved.
//

#import "Data.h"

@implementation Data

+ (Area)parseArea:(NSString *)str {
    if (str == nil) {
        return AreaUnknown;
    }
    if ([str isEqualToString:@"户型"]) {
        return AreaArchitecture;
    } else if ([str isEqualToString:@"客厅"]) {
        return AreaLivingRoom;
    }else if ([str isEqualToString:@"卧室"]) {
        return AreaBedroom;
    }else if ([str isEqualToString:@"厨房"]) {
        return AreaKitchen;
    }else if ([str isEqualToString:@"卫生间"]) {
        return AreaToilet;
    }
    
    return AreaUnknown;
}

+ (NSString *)areaToString:(Area)area {
    switch (area) {
        case AreaArchitecture: {
            return @"户型";
        }
        case AreaLivingRoom: {
            return @"客厅";
        }
        case AreaBedroom: {
            return @"卧室";
        }
        case AreaKitchen: {
            return @"厨房";
        }
        case AreaToilet: {
            return @"卫生间";
        }
        default: {
            return @"未知区域";
        }
    }
}

+ (PlanType)parsePlanType:(NSString *)str {
    if (str == nil) {
        return PlanType_UnKnown;
    }
    if ([str isEqualToString:@"套装"]) {
        return PlanType_Suit;
    } else if ([str isEqualToString:@"基础"]) {
        return PlanType_Basic;
    }
    return PlanType_UnKnown;
}

+ (NSString *)planTypeToString:(PlanType)type {
    switch (type) {
        case PlanType_Suit: {
            return @"套装";
            break;
        }
        case PlanType_Basic: {
            return @"基础";
            break;
        }
        default:
            return @"未知属性";
            break;
    }
}

+ (Position)parsePosition:(NSString *)str {
    if (str == nil) {
        return PositionUnknown;
    }
    if ([str isEqualToString:@"地面"]) {
        return PositionGround;
    } else if ([str isEqualToString:@"天花"]) {
        return PositionTop;
    } else if ([str isEqualToString:@"物件上"]) {
        return PositionOnItem;
    } else if ([str isEqualToString:@"墙内"]) {
        return PositionInWall;
    } else if ([str isEqualToString:@"墙上"]) {
        return PositionOnWall;
    }
    return PositionUnknown;
}

+ (NSString *)positionToString:(Position)position {
    switch (position) {
        case PositionGround: {
            return @"地面";
        }
        case PositionTop: {
            return @"天花";
        }
        case PositionOnItem: {
            return @"物件上";
        }
        case PositionInWall: {
            return @"墙内";
        }
        case PositionOnWall: {
            return @"墙上";
        }
        default: {
            return @"未知方位";
        }
    }
}

+ (SourceType)parseSourceType:(NSString *)str {
    if (str == nil) {
        return SourceTypeUnknown;
    }
    if ([str isEqualToString:@"模型"]) {
        return SourceTypeModel;
    }
    if ([str isEqualToString:@"贴图"]) {
        return SourceTypeTexture;
    }
    return SourceTypeUnknown;
}

+ (Item *)getItemFromInstance:(id<JIGameObject>)instance {
    ObjectExtra *extra = instance.extra;
//    id extra = instance.extra;
    if (![extra.item isKindOfClass:[Item class]]) {
        return nil;
    }
    Item* item = extra.item;
    return item;
}

+ (BOOL)bindInstance:(id<JIGameObject>)instance toItem:(Item *)item {
    if (instance == nil || item == nil) {
        return NO;
    }
    ObjectExtra *extra = instance.extra;
    if (extra == nil) {
        extra = [ObjectExtra new];
    }
    extra.item = item;
    instance.extra = extra;
    return YES;
}

+ (ItemInfo *)getItemInfoFromInstance:(id<JIGameObject>)instance {
    ObjectExtra *extra = instance.extra;
    if (![extra.itemInfo isKindOfClass:[ItemInfo class]]) {
        return nil;
    }
    ItemInfo* itemInfo = extra.itemInfo;
    return itemInfo;
}

+ (BOOL)bindInstance:(id<JIGameObject>)instance toItemInfo:(ItemInfo *)itemInfo {
    if (instance == nil || itemInfo == nil) {
        return NO;
    }
    ObjectExtra *extra = instance.extra;
    if (extra == nil) {
        extra = [ObjectExtra new];
    }
    extra.itemInfo = itemInfo;
    instance.extra = extra;
    return YES;
}

@end
