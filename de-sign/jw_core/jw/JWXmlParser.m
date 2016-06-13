//
//  JWXmlParser.m
//  June Winter
//
//  Created by GavinLo on 14/11/6.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWXmlParser.h"
#import "JWFile.h"
#import "NSDictionary+JWCoreCategory.h"
#import <Foundation/Foundation.h>

@interface JWXmlParser () <NSXMLParserDelegate>
{
    NSXMLParser* mParser;
    NSDictionary* mCurrentAttributeDict;
    NSString* mCurrentElementText;
}

@end

@implementation JWXmlParser

- (void)onDestroy
{
    mParser = nil;
    mCurrentAttributeDict = nil;
    [super onDestroy];
}

- (NSError*)readFile:(id<JIFile>)file encoding:(JWEncoding)encoding {
    if (encoding == JWEncodingUnknown) {
        encoding = JWEncodingUTF8;
    }
    mParser = [[NSXMLParser alloc] initWithData:file.data];
    mParser.delegate = self;
    if ([mParser parse]) {
        return nil;
    }
    return mParser.parserError;
}

- (NSString *)getAttributeValueByName:(NSString *)name
{
    if(mCurrentAttributeDict == nil)
        return nil;
    return [mCurrentAttributeDict get:name];
}

- (int) getIntAttributeValueByName:(NSString *)name defaultValue:(int)defaultValue
{
    if(mCurrentAttributeDict == nil)
        return defaultValue;
    id value = [mCurrentAttributeDict get:name];
    if(value == nil)
        return defaultValue;
    return [value intValue];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    if(![self onStartDocument])
        [parser abortParsing];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    mCurrentAttributeDict = attributeDict;
    if(![self onStartTag:elementName])
        [parser abortParsing];
    mCurrentElementText = @"";
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    if(![self onText:string])
//        [parser abortParsing];
    // NOTE 这个方法表示只要有文本被读取到就会调用，其实并不是元素标签之间的文本，所以不能直接处理
    // 需要以下处理，在读取到元素开始标签时记录文本，然后只要读取到文本，就连接上去，知道读取到元素标签结尾才是正确的元素文本
    // TMD这样设计好玩吗？？？ @Steve Jobs
    if (mCurrentElementText == nil) {
        return;
    } else {
        mCurrentElementText = [mCurrentElementText stringByAppendingString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (mCurrentElementText != nil) {
        if (![self onText:mCurrentElementText]) {
            [parser abortParsing];
        }
        mCurrentElementText = nil;
    }
    mCurrentAttributeDict = nil;
    if(![self onEndTag:elementName])
        [parser abortParsing];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(![self onEndDocument])
        [parser abortParsing];
}

- (BOOL)onStartDocument
{
    return NO;
}

- (BOOL)onStartTag:(NSString *)tag
{
    return NO;
}

- (BOOL)onText:(NSString *)text
{
    return NO;
}

- (BOOL)onEndTag:(NSString *)tag
{
    return NO;
}

- (BOOL)onEndDocument
{
    return NO;
}

@end
