//
//  JWAnimationResource.m
//  June Winter
//
//  Created by GavinLo on 14/12/23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWAnimationResource.h"

@interface JWAnimationResource () {
    JWAnimationTrack* mMainTrack;
    NSMutableArray<JWAnimationTrack*>* mTracks;
}

@end

@implementation JWAnimationResource

//- (id)initWithFile:(id<JIFile>)file context:(id<JIGameContext>)context manager:(id<JIResourceManager>)manager
//{
//    self = [super initWithFile:file context:context manager:manager];
//    if(self != nil)
//    {
//        mTrack = JCAnimationTrackMake();
//        JCAnimationTrackInit(&mTrack, JCAnimationTypeUnknown, 0);
//    }
//    return self;
//}

- (JWAnimationTrack *)mainTrack {
    return mMainTrack;
}

- (void)setMainTrack:(JWAnimationTrack *)mainTrack {
    mMainTrack = mainTrack;
}

- (void)addTrack:(JWAnimationTrack *)track {
    if (mMainTrack == nil) {
        mMainTrack = track;
        return;
    }
    if (mTracks == nil) {
        mTracks = [NSMutableArray array];
    }
    [mTracks addObject:track];
}

- (JWAnimationTrack *)addTrackByTarget:(id)target type:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop {
    if (type == JCAnimationTypeUnknown) {
        return nil;
    }
    // 同一个target的同一种类型的track只能允许有一个，以保证动画正常运行
    JWAnimationTrack* track = [self getTrackByTarget:target type:type];
    if (track != nil) {
        track.duration = duration;
        track.loop = loop;
        return track;
    }
    track = [JWAnimationTrack trackWithTarget:target type:type duration:duration loop:loop];
    [self addTrack:track];
    return track;
}

- (JWAnimationTrack *)getTrackByTarget:(id)target type:(JCAnimationType)type {
    if (mMainTrack != nil) {
        if ([mMainTrack hasTheSameTypeWithTarget:target type:type]) {
            return mMainTrack;
        }
    }
    if (mTracks == nil) {
        return nil;
    }
    for (JWAnimationTrack* track in mTracks) {
        if ([track hasTheSameTypeWithTarget:target type:type]) {
            return track;
        }
    }
    return nil;
}

- (void)enumTrackUsing:(void (^)(JWAnimationTrack *, NSUInteger, BOOL *))block {
    if (mMainTrack == nil) {
        return;
    }
    BOOL stop = NO;
    block(mMainTrack, 0, &stop);
    if (stop) {
        return;
    }
    if (mTracks == nil) {
        return;
    }
    [mTracks enumerateObjectsUsingBlock:^(JWAnimationTrack * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block(obj, idx + 1, stop);
    }];
}

@end
