//
//  JWAsyncTask.h
//  June Winter
//
//  Created by GavinLo on 14-2-28.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWCancellable.h>

/**
 * 类android的AsyncTask
 */
@interface JWAsyncTask : JWCancellable

- (void) execute:(NSArray*)params;

- (void) onPreExecute;
- (id) doInBackground:(NSArray*)params;
- (void) onPostExecute:(id)result;

@end
