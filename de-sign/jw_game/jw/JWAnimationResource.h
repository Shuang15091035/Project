//
//  JWAnimationResource.h
//  June Winter
//
//  Created by GavinLo on 14/12/23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWResource.h>
//#import <jw/JCAnimation.h>
#import <jw/JWAnimationTrack.h>

@protocol JIAnimationResource <JIResource>

@property (nonatomic, readwrite) JWAnimationTrack* mainTrack;
//@property (nonatomic, readwrite) NSUInteger duration;

//- (void) addTrack:(JWAnimationTrack*)track;
- (JWAnimationTrack*) addTrackByTarget:(id)target type:(JCAnimationType)type duration:(NSUInteger)duration loop:(BOOL)loop;
- (JWAnimationTrack*) getTrackByTarget:(id)target type:(JCAnimationType)type;
- (void) enumTrackUsing:(void (^)(JWAnimationTrack* track, NSUInteger idx, BOOL* stop))block;

@end

@interface JWAnimationResource : JWResource <JIAnimationResource>
//{
//    JCAnimationTrack mTrack;
//}

@end
