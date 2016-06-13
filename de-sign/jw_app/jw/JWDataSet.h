//
//  JWDataSet.h
//  June Winter
//
//  Created by GavinLo on 14-3-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWAppPredef.h>

@protocol JIDataSet <NSObject>

- (void) registerDataSetObserver:(id<JIDataSetObserver>)observer;
- (void) unregisterDataSetObserver:(id<JIDataSetObserver>)observer;
- (void) notifyDataSetChanged;

@end

@protocol JIDataSetObserver <NSObject>

- (void) onDataSetChanged:(id<JIDataSet>)dataSet;

@end

@interface JWDataSet : NSObject <JIDataSet>

- (id) initWithDataSet:(id<JIDataSet>)dataSet;
+ (id) dataSetWithDataSet:(id<JIDataSet>)dataSet;

@end

