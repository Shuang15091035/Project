//
//  UIFont+JWUiCategory.m
//  jw_app
//
//  Created by ddeyes on 16/4/17.
//  Copyright © 2016年 luojunwen123@gmail.com. All rights reserved.
//

#import "UIFont+JWUiCategory.h"

@implementation UIFont (JWUiCategory)

+ (NSString *)fontTree {
    NSMutableString* tree = [NSMutableString string];
    [tree appendString:@"--- all support fonts ---"];
    NSArray<NSString*>* familyNames = [self familyNames];
    for (NSString* familyName in familyNames) {
        [tree appendFormat:@"\n%@", familyName];
        NSArray<NSString*>* fontNames = [UIFont fontNamesForFamilyName:familyName];
        for (NSString* fontName in fontNames) {
            [tree appendFormat:@"\n      |-- %@", fontName];
        }
    }
    return tree;
}

@end
