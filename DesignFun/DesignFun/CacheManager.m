//
//  ZolCachManager.m
//  Zol
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 Lly. All rights reserved.
//

#import "CacheManager.h"


@implementation CacheManager

//得到本地缓存的目录
+ (NSString*)cacheDirectory
{
    //得到沙盒目录下的cache文件夹
    NSString *cachDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cachDir = [cachDir stringByAppendingPathComponent:@"LimitCache"];
    //创建LimitCache文件夹，目的是把所有的缓存数据放到该文件夹下面
    //attribute:nil只文件夹跟父文件夹一样的读写属性
    NSError *error;
    BOOL bret = [[NSFileManager defaultManager] createDirectoryAtPath:cachDir withIntermediateDirectories:YES attributes:nil error:&error];
    if (!bret) {
        NSLog(@"%@",error);
        return nil;
    }
    
    return cachDir;
}


+ (NSString*)cacheFileFullPath:(NSString*)url
{
    //得到保存的文件的全路径,使用url的MD5加密得到的字符串作为文件名
    //这样url和文件名就对应起来了
    //[url MD5Hash] 是把url进行MD5加密得到的字符串
    //MD5 加密算法是不可逆的
    NSString *fileName = MD5Hash(url);
    NSString *cacheDir = [self cacheDirectory];
    return [cacheDir stringByAppendingPathComponent:fileName];
}

//保存url 对应的数据
//输入的数据，要么是字典，要么数组
+ (void)saveData:(id)object atUrl:(NSString*)url{
    //首先得到保存的文件路径
    NSString *fileFullPath = [self cacheFileFullPath:url];
//    NSLog(@"%@",fileFullPath);
    //写入数据,使用NSKeyedArchiver进行数据转换
    NSData *data = [NSKeyedArchiver  archivedDataWithRootObject:object];
    [data writeToFile:fileFullPath atomically:YES];
}

//读取url对应的数据
+ (id)readDataAtUrl:(NSString*)url
{
    NSString *fileFullPath = [self cacheFileFullPath:url];
    NSData *data = [NSData dataWithContentsOfFile:fileFullPath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

//判断缓存数据是否有效
+ (BOOL)isCacheDataInvalid:(NSString*)url
{
    //isDirectory 的参数是返回给我们是否是一个目录
    NSString *fileFullPath = [self cacheFileFullPath:url];
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath isDirectory:nil];
    //获取文件的属性
    NSDictionary *attributeDic = [[NSFileManager defaultManager] attributesOfItemAtPath:fileFullPath error:nil];
    NSDate *lastModify = attributeDic.fileModificationDate;
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastModify];
    BOOL isExpire = (timeInterval > 60*60);
    if (isFileExist && !isExpire) {
        return YES;
    }
    return NO;
}



//计算缓存的大小,遍历缓存目录，把文件内容大小累加
+ (double)cacheSize
{
    float totalSize = 0.0;
    NSString *cacheDir = [self cacheDirectory];
    //得到目录的枚举器，使用它来枚举目录下的所有文件
    NSDirectoryEnumerator *enmuerator = [[NSFileManager defaultManager]enumeratorAtPath:cacheDir];
    for (NSString *fileName in enmuerator) {
        NSString *fileFullPath = [cacheDir stringByAppendingPathComponent:fileName];
        NSDictionary *attributeDic = [[NSFileManager defaultManager] attributesOfItemAtPath:fileFullPath error:nil];
        totalSize += attributeDic.fileSize;
    }
    
    //清除缓存
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    //image 缓存
    NSUInteger fileSize = [imageCache getSize];
    // NSLog(@"sd缓存:%.3f",fileSize/1024.0/1024.0);
    fileSize += totalSize;
    
    double size = fileSize/1024.0/1024.0;
    //    //NSLog(@"缓存 大小:%.3f M",size);
    //    return size;
    return size;
}
//+(double) getCacheSize {
//    //清除缓存
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    //image 缓存
//    NSUInteger fileSize = [imageCache getSize];
//    // NSLog(@"sd缓存:%.3f",fileSize/1024.0/1024.0);
//    
//    //本地下载缓存
//    NSString *myCache = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/MyCaches"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    
//    NSDictionary *dict = [fm attributesOfItemAtPath:myCache error:nil];
//    
//    // NSLog(@"本地缓存:%lld字节",dict.fileSize);
//    //sdwebimage缓存+ 本地下载缓存
//    fileSize += dict.fileSize;
//    
//    //转换为M 兆
//    
//    double size = fileSize/1024.0/1024.0;
//    //NSLog(@"缓存 大小:%.3f M",size);
//    return size;
//}

//清除缓存
+ (void)clearDisk
{
    //清理sd 的内存 可有可无
    [[SDImageCache sharedImageCache] clearMemory];
    //清理sd 缓存
    [[SDImageCache sharedImageCache] clearDisk];
    //清除 本地其他缓存
    
    NSString *cacheDir = [self cacheDirectory];
    [[NSFileManager defaultManager] removeItemAtPath:cacheDir error:nil];
}


@end
