//
//  JWViewHolder.m
//  June Winter
//
//  Created by GavinLo on 14-3-4.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWViewHolder.h"
#import "JWAdapter.h"
#import "JWAdapterView.h"

@interface JWViewHolder () {
    id<JIAdapter> mAdapter;
}

@end

@implementation JWViewHolder

@synthesize position;

- (CGSize)getViewSize:(NSUInteger)viewType
{
    return CGSizeZero;
}

- (UIView *)onCreateView:(NSBundle *)bundle viewType:(NSUInteger)viewType parent:(UIView *)parent
{
    return nil;
}

- (void)setRecord:(id)record
{
    
}

- (void)onReuseView:(UIView *)view
{
    
}

- (void)onDestroyView:(UIView *)view
{
    
}

- (void)sendEvent:(int)what withRecord:(id)record {
    if (mAdapter == nil) {
        return;
    }
    JWAdapter* at = (JWAdapter*)mAdapter;
    id<JIAdapterView> av = at.adapterView;
    if (![av conformsToProtocol:@protocol(JIListAdapterView)]) {
        return;
    }
    id<JIListAdapterView> lav = (id<JIListAdapterView>)av;
    if (lav.onItemEvent == nil) {
        return;
    }
    lav.onItemEvent(what, self.position, record);
}

@synthesize adapter = mAdapter;

- (void)onHighlighted:(BOOL)highlighted {
    
}

- (void)onSelected:(BOOL)selected {
    
}

- (void)willCompleteShow {
    
}

@end
