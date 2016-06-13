//
//  JWCommand.h
//  jw_app
//
//  Created by ddeyes on 15/10/12.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

/**
 * 命令接口
 */
@protocol JICommand <JIObject>

- (void) todo;
- (void) redo;
- (void) undo;

@end

@interface JWCommand : JWObject <JICommand>

@end