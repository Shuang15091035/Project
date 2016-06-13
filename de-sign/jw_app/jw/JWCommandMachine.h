//
//  JWCommandMachine.h
//  jw_app
//
//  Created by ddeyes on 15/10/12.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWCommand.h>

/**
 * 命令机制（用以实现撤销/重做机制）
 */
@protocol JICommandMachine <JIObject>

/**
 * 最大命令数（命令堆栈的容量）
 */
@property (nonatomic, readwrite) NSUInteger maxCommands;

/**
 * 执行一个命令
 * @param command 命令
 * @param canUndo 是否可以撤销（是否把该命令放入命令堆栈）
 */
- (BOOL) todoCommand:(id<JICommand>)command canUndo:(BOOL)canUndo;
- (BOOL) todoCommand:(id<JICommand>)command;

/**
 * 不执行命令，直接将命令压栈
 * @param command 命令
 */
- (BOOL) doneCommand:(id<JICommand>)command;

/**
 * 重做命令
 */
- (BOOL) undo;

/**
 * 撤销命令
 */
- (BOOL) redo;

/**
 * 是否可撤销
 */
@property (nonatomic, readonly) BOOL canUndo;

/**
 * 是否可重做
 */
@property (nonatomic, readonly) BOOL canRedo;

/**
 * 清空并删除所有命令
 */
- (void) clear;

@end

@interface JWCommandMachine : JWObject <JICommandMachine>

+ (id) machine;
+ (NSUInteger) MaxCommandsDefault;

@end
