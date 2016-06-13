//
//  JWLifeCycle.h
//  June Winter
//
//  Created by GavinLo on 14/10/24.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>

@protocol JILifeCycle <JIObject>

- (void) onResume;
- (void) onPause;

@end

@interface JWLifeCycle : JWObject <JILifeCycle>

@end
