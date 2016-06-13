//
//  JWCommandMachine.m
//  jw_app
//
//  Created by ddeyes on 15/10/12.
//  Copyright © 2015年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCommandMachine.h"
#import <jw/NSMutableArray+JWArrayList.h>
#import <jw/JWCoreUtils.h>

@interface JWCommandMachine () {
    NSMutableArray* mCommandStack;
    NSInteger mCurrentCommand;
    NSInteger mNumCommands;
}

@end

@implementation JWCommandMachine

+ (id)machine {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mCurrentCommand = -1;
    }
    return self;
}

+ (NSUInteger)MaxCommandsDefault {
    return 100000;
}

- (NSUInteger)maxCommands {
    if (mCommandStack == nil) {
        return 0;
    }
    return mCommandStack.count;
}

- (void)setMaxCommands:(NSUInteger)maxCommands {
    if (mCommandStack == nil) {
        mCommandStack = [NSMutableArray array];
        for (NSUInteger i = 0; i < maxCommands; i++) {
            [mCommandStack add:nil];
        }
    } else {
        NSMutableArray* newCommandStack = [NSMutableArray array];
        NSUInteger commandsToCopy = maxCommands < mCommandStack.count ? maxCommands : mCommandStack.count;
        for (NSUInteger i = 0; i < commandsToCopy; i++) {
            [newCommandStack add:[mCommandStack at:i]];
        }
        [mCommandStack clear];
        mCommandStack = newCommandStack;
    }
}

- (BOOL)todoCommand:(id<JICommand>)command canUndo:(BOOL)canUndo {
    if (command == nil) {
        return NO;
    }
    if (self.maxCommands == 0) {
        self.maxCommands = [JWCommandMachine MaxCommandsDefault];
    }
    if (mCurrentCommand == mCommandStack.count - 1) {
        return NO;
    }
    
    NSLog(@"todo command %@[%@]", @(mCurrentCommand), NSStringFromClass([command class]));
    [command todo];
    
    if (canUndo) {
        mCurrentCommand++;
        mCommandStack[mCurrentCommand] = command;
        mNumCommands = mCurrentCommand + 1;
    }
    for (NSUInteger i = mCurrentCommand + 1; i < mCommandStack.count; i++) {
        [JWCoreUtils destroyObject:[mCommandStack at:i]];
        [mCommandStack set:i object:nil];
    }
    return YES;
}

- (BOOL)todoCommand:(id<JICommand>)command {
    return [self todoCommand:command canUndo:YES];
}

- (BOOL)doneCommand:(id<JICommand>)command {
    if (command == nil) {
        return NO;
    }
    if (self.maxCommands == 0) {
        self.maxCommands = [JWCommandMachine MaxCommandsDefault];
    }
    if (mCurrentCommand == mCommandStack.count - 1) {
        return NO;
    }
    
    NSLog(@"done command %@[%@]", @(mCurrentCommand), NSStringFromClass([command class]));
    mCurrentCommand++;
    mCommandStack[mCurrentCommand] = command;
    mNumCommands = mCurrentCommand + 1;
    for (NSUInteger i = mCurrentCommand + 1; i < mCommandStack.count; i++) {
        [JWCoreUtils destroyObject:[mCommandStack at:i]];
        [mCommandStack set:i object:nil];
    }
    return YES;
}

- (BOOL)undo {
    if (self.maxCommands == 0) {
        self.maxCommands = [JWCommandMachine MaxCommandsDefault];
    }
    if (!self.canUndo) {
        return NO;
    }
    
    id<JICommand> command = [mCommandStack at:mCurrentCommand];
    NSLog(@"undo command[%@]", NSStringFromClass([command class]));
    [command undo];
    mCurrentCommand--;
    return YES;
}

- (BOOL)redo {
    if (self.maxCommands == 0) {
        self.maxCommands = [JWCommandMachine MaxCommandsDefault];
    }
    if (!self.canRedo) {
        return NO;
    }
    
    mCurrentCommand++;
    id<JICommand> command = [mCommandStack at:mCurrentCommand];
    NSLog(@"redo command[%@]", NSStringFromClass([command class]));
    [command redo];
    return YES;
}

- (BOOL)canUndo {
    return mCurrentCommand >= 0;
}

- (BOOL)canRedo {
    return mCurrentCommand < mNumCommands - 1;
}

- (void)clear {
    if (mCommandStack != nil) {
        for (NSUInteger i = 0; i < mCommandStack.count; i++) {
            [JWCoreUtils destroyObject:[mCommandStack at:i]];
            [mCommandStack set:i object:nil];
        }
    }
    mCurrentCommand = -1;
    mNumCommands = 0;
}

@end
