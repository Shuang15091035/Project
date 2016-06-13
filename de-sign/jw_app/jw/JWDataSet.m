//
//  JWDataSet.m
//  June Winter
//
//  Created by GavinLo on 14-3-2.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWDataSet.h"
#import "NSMutableArray+JWArrayList.h"

@interface JWDataSet ()
{
    NSMutableArray* mObservers;
    id<JIDataSet> mDataSet;
}

@property (nonatomic, readonly) NSMutableArray* observers;

@end

@implementation JWDataSet

- (id)init
{
    return [self initWithDataSet:nil];
}

- (id)initWithDataSet:(id<JIDataSet>)dataSet
{
    self = [super init];
    if(self != nil)
    {
        if(dataSet == nil)
            mDataSet = self;
        else
            mDataSet = dataSet;
    }
    return self;
}

+ (id)dataSetWithDataSet:(id<JIDataSet>)dataSet
{
    return [[JWDataSet alloc] initWithDataSet:dataSet];
}

- (NSMutableArray *)observers
{
    if(mObservers == nil)
        mObservers = [NSMutableArray array];
    return mObservers;
}

- (void)registerDataSetObserver:(id<JIDataSetObserver>)observer
{
    [self.observers add:observer];
}

- (void)unregisterDataSetObserver:(id<JIDataSetObserver>)observer
{
    [self.observers remove:observer];
}

- (void)notifyDataSetChanged
{
    for(id<JIDataSetObserver> observer in self.observers)
    {
        if((NSNull*)observer != [NSNull null])
            [observer onDataSetChanged: mDataSet];
    }
}

@end
