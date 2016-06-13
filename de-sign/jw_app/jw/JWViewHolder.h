//
//  JWViewHolder.h
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <jw/JWAppPredef.h>
#import <jw/JWObject.h>

@protocol JIViewHolder <JIObject>

@property (nonatomic, readwrite) NSUInteger position;

//- (CGSize) getViewSize:(NSUInteger)viewType; NOTE 废除，请实现JIAdapter.getViewSizeAt:
- (UIView*) onCreateView:(NSBundle*)bundle viewType:(NSUInteger)viewType parent:(UIView*)parent;
- (void) setRecord:(id)record;

- (void) onReuseView:(UIView*)view;
- (void) onDestroyView:(UIView*)view;

@end


@interface JWViewHolder : JWObject <JIViewHolder>

- (void) sendEvent:(int)what withRecord:(id)record;
@property (nonatomic, readwrite) id<JIAdapter> adapter;

- (void) onHighlighted:(BOOL)highlighted;
- (void) onSelected:(BOOL)selected;
- (void) willCompleteShow;

@end
