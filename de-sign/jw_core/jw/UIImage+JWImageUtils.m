//
//  UIImage+JWImageUtils.m
//  June Winter
//
//  Created by GavinLo on 15/1/5.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "UIImage+JWImageUtils.h"
#import "JCUtils.h"
#import "JCMath.h"
#import "JWResourceBundle.h"
#import "NSString+JWCoreCategory.h"
#import "../3rd/NinePatch/UIImage-TUNinePatch.h"

@implementation UIImage (JWImageUtils)

- (CGSize)sizeInPixels
{
    return CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
}

+ (UIImage*) imageByResourceDrawable:(NSString*)drawableName;
{
    return [self imageByResourceDrawable:drawableName withOptions:nil];
}

+ (UIImage *)imageByResourceDrawable:(NSString *)drawableName withOptions:(JWImageOptions *)options
{
    UIImage* image = [UIImage imageNamed:[JWResourceBundle nameForDrawable:drawableName]];
    if(image == nil)
        return nil;
    if([drawableName contains:@".9."])
        image = [image ninePatchWithOptions:options];
    else
        image = [image imageByOptions:options];
    return image;
}

- (UIImage *)imageByScale:(CGFloat)scale
{
    scale = 1.0f / scale; // 这个scale在下面的方法中不是传统意义上的缩放,所以要这样处理
    return [UIImage imageWithCGImage:self.CGImage scale:scale orientation:self.imageOrientation];
}

- (UIImage *)imageByScaleAspectFitWidth:(CGFloat)width
{
    CGSize originSize = self.size;
    if(originSize.width == 0.0f)
        return nil;
    CGFloat scale = width / originSize.width;
    return [self imageByScale:scale];
}

- (UIImage *)imageByScaleAspectFitHeight:(CGFloat)height
{
    CGSize originSize = self.size;
    if(originSize.height == 0.0f)
        return nil;
    CGFloat scale = height / originSize.height;
    return [self imageByScale:scale];
}

- (UIImage *)imageByOptions:(JWImageOptions *)options
{
    if(options == nil)
        return self;
    
    CGSize originSize = self.size;
    
    // backup fixedSize
    CGFloat fixedWidth = options.fixedWidth;
    CGFloat fixedHeight = options.fixedHeight;
    
    // 处理keepRatioPolicy
    [self handleKeepRatio:options];
    
    // 处理scalePowerOf2
    if(options.scalePowerOf2)
    {
        if(options.hasFixedSize)
        {
            options.fixedWidth = JCNextPowerOf2f(options.fixedWidth);
            options.fixedHeight = JCNextPowerOf2f(options.fixedHeight);
        }
        else
        {
            options.fixedWidth = JCNextPowerOf2f(originSize.width);
            options.fixedHeight = JCNextPowerOf2f(originSize.height);
        }
    }
    
    UIImage* resultImage = self;
    // 处理目标大小调整
    if(options.hasFixedSize)
    {
        if(options.fixedWidth > 0.0f && options.fixedHeight > 0.0f)
        {
            if(options.fixedWidth != originSize.width || options.fixedHeight != originSize.height)
            {
                CGRect rect = CGRectMake(0.0f, 0.0f, options.fixedWidth, options.fixedHeight);
                UIGraphicsBeginImageContext(rect.size);
                [self drawInRect:rect];
                resultImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                // 对inset进行缩放
                if(!UIEdgeInsetsEqualToEdgeInsets(options.insets, UIEdgeInsetsZero))
                {
                    CGFloat sw = options.fixedWidth / originSize.width;
                    CGFloat sh = options.fixedHeight / originSize.height;
                    options.insets = UIEdgeInsetsMake(options.insets.top * sh, options.insets.left * sw, options.insets.bottom * sh, options.insets.right * sw);
                }
            }
        }
    }
    
    // 处理inset,即生成resizable image(类android的9-patch)
    if(!UIEdgeInsetsEqualToEdgeInsets(options.insets, UIEdgeInsetsZero))
    {
        resultImage = [resultImage resizableImageWithCapInsets:options.insets resizingMode:UIImageResizingModeStretch];
    }
    
    options.fixedWidth = fixedWidth;
    options.fixedHeight = fixedHeight;
    return resultImage;
}

- (void) handleKeepRatio:(JWImageOptions*)options
{
    if(options.keepRatioPolicy == JWKeepRatioPolicyUnknown || !options.hasFixedSize)
        return;
    
    CGSize originSize = self.size;
    CGFloat ratio = originSize.width / originSize.height;
    switch(options.keepRatioPolicy)
    {
        case JWKeepRatioPolicyWidthPriority:
            options.fixedHeight = options.fixedWidth / ratio;
            break;
        case JWKeepRatioPolicyHeightPriority:
            options.fixedWidth = options.fixedHeight * ratio;
            break;
        case JWKeepRatioPolicyShortPriority:
            if(originSize.width < originSize.height)
                options.fixedHeight = options.fixedWidth / ratio;
            else if(originSize.width > originSize.height)
                options.fixedWidth  = options.fixedHeight * ratio;
            else
            {
                if(options.fixedWidth < options.fixedHeight)
                    options.fixedHeight = options.fixedWidth / ratio;
                else if(options.fixedWidth > options.fixedHeight)
                    options.fixedWidth = options.fixedHeight * ratio;
            }
            break;
        case JWKeepRatioPolicyLongPriority:
            if(originSize.width > originSize.height)
                options.fixedHeight = options.fixedWidth / ratio;
            else if(originSize.width < originSize.height)
                options.fixedWidth  = options.fixedHeight * ratio;
            else
            {
                if(options.fixedWidth > options.fixedHeight)
                    options.fixedHeight = options.fixedWidth / ratio;
                else if(options.fixedWidth < options.fixedHeight)
                    options.fixedWidth = options.fixedHeight * ratio;
            }
            break;
        default:
            break;
    }
}

- (UIImage *)ninePatch
{
    return [self ninePatchWithOptions:nil];
}

- (UIImage *)ninePatchWithOptions:(JWImageOptions *)options
{
    UIImage* ninePatchImage = self.imageAsNinePatchImage;
    //CGSize size = ninePatchImage.size;
    UIEdgeInsets insets = self.insets;
    
    if(options == nil)
        options = [JWImageOptions options];
    options.insets = insets;
    ninePatchImage = [ninePatchImage imageByOptions:options];
    return ninePatchImage;
}

- (UIEdgeInsets)insets
{
    CGSize size = self.size;
    size.width -= 2.0f / self.scale;
    size.height -= 2.0f / self.scale;
    
    NSRange topRange = self.blackPixelRangeInUpperStrip;
    NSRange leftRange = self.blackPixelRangeInLeftStrip;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    insets.left = topRange.location;
    insets.right = size.width - (topRange.location + topRange.length);
    insets.top = leftRange.location;
    insets.bottom = size.height - (leftRange.location + leftRange.length);
    
    return insets;
}

- (JCBitmap)bitmapScalePowerOf2:(BOOL)scalePowerOf2
{
    CGImageRef image = self.CGImage;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    if(scalePowerOf2)
    {
        width = JCNextPowerOf2(width);
        height = JCNextPowerOf2(height);
    }
    
    JCBitmap bitmap = JCBitmapMake(0, 0);
    JCPixelFormat pixelFormat = JCPixelFormat_Unknown;
    CGContextRef context = [UIImage createMatchContextForImage:self.CGImage scalePowerOf2:scalePowerOf2 pixelFormat:&pixelFormat];
    if(context == NULL)
        return bitmap;
    
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, rect, image);
    JCByte* bitmapData = (JCByte*)CGBitmapContextGetData(context);
    
    // TODO 复制bitmap数据,以免被释放,后续可以做优化
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    JCByte* newBitmap = JCMemoryClone(bitmapData, 0, bufferLength, JCByteBytes);
    
    CGContextRelease(context);
    
    bitmap.width = (int)width;
    bitmap.height = (int)height;
    bitmap.pixelFormat = pixelFormat;
    bitmap.data = JCBufferWrap(newBitmap, bufferLength, true);
    return bitmap;
}

+ (CGContextRef) createMatchContextForImage:(CGImageRef)image scalePowerOf2:(BOOL)scalePowerOf2 pixelFormat:(JCPixelFormat*)pixelFormat
{
    JCPixelFormat pf = [self getImagePixelFormat:image];
    if (pf == JCPixelFormat_Unknown) {
        return NULL;
    }
    CGContextRef context = [self getImageContext:image scalePowerOf2:scalePowerOf2 format:pf];
    *pixelFormat = pf;
    return context;
}

+ (JCPixelFormat) getImagePixelFormat:(CGImageRef)image {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image);
    bool hasAlpha = (alpha != kCGImageAlphaNone && alpha != kCGImageAlphaNoneSkipLast && alpha != kCGImageAlphaNoneSkipFirst);
    bool hasPremultipliedAlpha = (alpha == kCGImageAlphaPremultipliedFirst) || (alpha == kCGImageAlphaPremultipliedLast);
    CGColorSpaceRef color = CGImageGetColorSpace(image);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(color);
    size_t bpp	= CGImageGetBitsPerPixel(image);
    
    if (color != NULL) {
        if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
            if (hasAlpha) {
                return JCPixelFormat_LA;
            } else {
                return JCPixelFormat_A8;
            }
        }
        if (bpp == 16) {
            if (hasAlpha) {
                return JCPixelFormat_RGBA5551;
            } else {
                return JCPixelFormat_RGB565;
            }
        }
        if (hasAlpha) {
            if (hasPremultipliedAlpha) {
                return JCPixelFormat_RGBpA8888;
            }
            if (bpp == 32) {
                return JCPixelFormat_RGBA8888;
            } else if (bpp == 64) {
                return JCPixelFormat_RGBA16;
            }
        } else {
            if (bpp == 24) {
                return JCPixelFormat_RGB888;
            } else if (bpp == 32 && alpha == kCGImageAlphaNoneSkipLast) {
                return JCPixelFormat_RGBX8888;
            }
        }
    }
    
    return JCPixelFormat_Unknown;
}

+ (CGContextRef) getImageContext:(CGImageRef)image scalePowerOf2:(BOOL)scalePowerOf2 format:(JCPixelFormat)format
{
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    if(scalePowerOf2)
    {
        width = JCNextPowerOf2(width);
        height = JCNextPowerOf2(height);
    }
    return [self getImageContextWithWidth:width height:height format:format];
}

+ (CGContextRef) getImageContextWithWidth:(size_t)width height:(size_t)height format:(JCPixelFormat)format
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace	 = NULL;
    void* data = NULL; // iOS4.0之后可以不自己开辟缓存空间
    int numChannels = 0;
    size_t bitsPerComponent = 0;
    size_t bytesPerRow = 0;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    switch (format) {
        case JCPixelFormat_RGBpA8888: {
            colorSpace = CGColorSpaceCreateDeviceRGB();
            numChannels = 4;
            bitsPerComponent = 8;
            bytesPerRow = numChannels * width;
            bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
            context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
            CGColorSpaceRelease(colorSpace);
            break;
        }
        case JCPixelFormat_RGBA8888: {
            colorSpace = CGColorSpaceCreateDeviceRGB();
            numChannels = 4;
            bitsPerComponent = 8;
            bytesPerRow = numChannels * width;
            bitmapInfo = kCGImageAlphaLast | kCGBitmapByteOrder32Big;
            context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
            CGColorSpaceRelease(colorSpace);
            break;
        }
        case JCPixelFormat_RGBX8888: {
            colorSpace = CGColorSpaceCreateDeviceRGB();
            numChannels = 4;
            bitsPerComponent = 8;
            bytesPerRow = numChannels * width;
            bitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big;
            context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
            CGColorSpaceRelease(colorSpace);
            break;
        }
//        case JCPixelFormat_RGBA16: {
//            colorSpace = CGColorSpaceCreateDeviceRGB();
//            numChannels = 4;
//            bitsPerComponent = 16;
//            bytesPerRow = numChannels * width;
//            bitmapInfo = kCGImageAlphaLast | kCGBitmapByteOrder32Big;
//            context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
//            CGColorSpaceRelease(colorSpace);
//            break;
//        }
        case JCPixelFormat_RGB888: {
            colorSpace = CGColorSpaceCreateDeviceRGB();
            numChannels = 4;
            bitsPerComponent = 8;
            bytesPerRow = numChannels * width;
            bitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big;
            context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
            CGColorSpaceRelease(colorSpace);
            break;
        }
        case JCPixelFormat_A8: {
            colorSpace	 = NULL;
            numChannels = 1;
            bitsPerComponent = 8;
            bytesPerRow = numChannels * width;
            bitmapInfo = kCGImageAlphaOnly | kCGBitmapByteOrderDefault;
            context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
            break;
        }
        case JCPixelFormat_LA: {
            colorSpace = CGColorSpaceCreateDeviceRGB();
            numChannels = 4;
            bitsPerComponent = 8;
            bytesPerRow = numChannels * width;
            bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
            context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
            CGColorSpaceRelease(colorSpace);
            break;
        }
        default:
            break;
    }
    return context;
}

+ (UIImage *)fromBitmap:(JCBitmapRef)bitmap {
    if (bitmap == NULL || bitmap->data.data == NULL) {
        return nil;
    }
    
    CGImageRef imageRef = NULL;
    JCBitmap tempBitmap;
    JCBitmapAssign(&tempBitmap, bitmap); // 释放bitmap对其data的控制权，由CGDataProviderRef接管
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmap->data.data, bitmap->data.size, NULL);
    
    CGColorSpaceRef colorSpace	 = NULL;
    int numChannels = 0;
    size_t bitsPerComponent = 0;
    size_t bitsPerPixel = 0;
    size_t bytesPerRow = 0;
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    switch (bitmap->pixelFormat) {
        case JCPixelFormat_RGBA8888:
        case JCPixelFormat_RGBpA8888: {
            colorSpace = CGColorSpaceCreateDeviceRGB();
            numChannels = 4;
            bitsPerComponent = 8;
            bitsPerPixel = 32;
            bytesPerRow = numChannels * bitmap->width;
            //bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big; // NOTE 不屏蔽这里会出现图片全白，原因未明
            imageRef = CGImageCreate(bitmap->width, bitmap->height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, provider, NULL, NO, renderingIntent);
            CGColorSpaceRelease(colorSpace);
            break;
        }
        default:
            // TODO 其他格式
            break;
    }
    
    if (imageRef == NULL) {
        return nil;
    }
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}

+ (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height {
    
    
    size_t bufferLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    if(colorSpaceRef == NULL) {
        NSLog(@"Error allocating color space");
        CGDataProviderRelease(provider);
        return nil;
    }
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef iref = CGImageCreate(width,
                                    height,
                                    bitsPerComponent,
                                    bitsPerPixel,
                                    bytesPerRow,
                                    colorSpaceRef,
                                    bitmapInfo,
                                    provider,	// data provider
                                    NULL,		// decode
                                    YES,			// should interpolate
                                    renderingIntent);
    
    uint32_t* pixels = (uint32_t*)malloc(bufferLength);
    
    if(pixels == NULL) {
        NSLog(@"Error: Memory not allocated for bitmap");
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(iref);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpaceRef,
                                                 bitmapInfo);
    
    if(context == NULL) {
        NSLog(@"Error context not created");
        free(pixels);
    }
    
    UIImage *image = nil;
    if(context) {
        
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), iref);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // Support both iPad 3.2 and iPhone 4 Retina displays with the correct scale
        if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
            float scale = [[UIScreen mainScreen] scale];
            image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
        } else {
            image = [UIImage imageWithCGImage:imageRef];
        }
        
        CGImageRelease(imageRef);	
        CGContextRelease(context);	
    }
    
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(iref);
    CGDataProviderRelease(provider);
    
    if(pixels) {
        free(pixels);
    }	
    return image;
}

@end
