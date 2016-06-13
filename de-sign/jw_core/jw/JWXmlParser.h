//
//  JWXmlParser.h
//  June Winter
//
//  Created by GavinLo on 14/11/6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWObject.h>
#import <jw/JWEncoding.h>

@interface JWXmlParser : JWObject

- (NSError*) readFile:(id<JIFile>)file encoding:(JWEncoding)encoding;

- (NSString*) getAttributeValueByName:(NSString*)name;
- (int) getIntAttributeValueByName:(NSString *)name defaultValue:(int)defaultValue;

- (BOOL) onStartDocument;
- (BOOL) onStartTag:(NSString*)tag;
- (BOOL) onText:(NSString*)text;
- (BOOL) onEndTag:(NSString*)tag;
- (BOOL) onEndDocument;

@end
