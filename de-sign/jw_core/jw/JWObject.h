//
//  JWObject.h
//  June Winter
//
//  Created by GavinLo on 14-2-12.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWCorePredef.h>

/**
 * 基础对象接口
 */
@protocol JIObject <NSObject>

/**
 * 初始化时调用,一般由外部管理器调用,也有对象在自己的init方法里面调用
 */
- (void) onCreate;

/**
 * 对象销毁时调用,一般由外部管理器调用,也有对象在自己的dealloc方法里面调用
 */
- (void) onDestroy;

/**
 * 系统方法,由于使用JIObject,如果使用以下方法可能会遇到无法编译的情况,这里重新声明一下.
 * 它的使用遵循以下规则:
 * 首先按get,is的顺序查找getter方法,找到直接调用.如果是bool,int等内建值类型,会做NSNumber的转换.
 * 上面的getter没有找到,查找countOf,objectInAtIndex:,AtIndexes格式的方法.
 * 如果countOf和另外两个方法中的一个找到,那么就会返回一个可以响应NSArray所有方法的代理集合(collection proxy object).发送给这个代理集合(collection proxy object)的NSArray消息方法,就会以countOf,objectInAtIndex:,AtIndexes这几个方法组合的形式调用.还有一个可选的get:range:方法.
 * 还没查到,那么查找countOf,enumeratorOf,memberOf:格式的方法.
 * 如果这三个方法都找到,那么就返回一个可以响应NSSet所有方法的代理集合(collection proxy object).发送给这个代理集合(collection proxy object)的NSSet消息方法,就会以countOf,enumeratorOf,memberOf:组合的形式调用.
 * 还是没查到,那么如果类方法accessInstanceVariablesDirectly返回YES,那么按_,_is,is的顺序直接搜索成员名.
 * 再没查到,调用valueForUndefinedKey:(默认抛出异常).
 */
- (id) valueForKey:(NSString*)key;

/**
 * 系统方法,由于使用JIObject,如果使用以下方法可能会遇到无法编译的情况,这里重新声明一下.
 * 它的使用遵循以下规则:
 * 首先搜索setXXX方法
 * 如果成员用@property,@synthsize处理,因为@synthsize告诉编译器自动生成setXXX格式的setter方法,所以这种情况下会直接搜索到.
 * 注意XXX这里的是指成员名,而且首字母大写,下同.
 * 上面的setter方法没有找到,如果类方法accessInstanceVariablesDirectly返回YES(注:这是NSKeyValueCodingCatogery中实现的类方法,默认实现为返回YES).
 * 那么按_,_is,is的顺序搜索成员名.
 * 如果找到则设置成员的值,否则调用setValue:forUndefinedKey:(默认抛出异常).
 */
- (void) setValue:(id)value forKey:(NSString *)key;

@end

/**
 * 基础对象
 */
@interface JWObject : NSObject <JIObject>

/**
 * 因为数字0和nil可以判断为相等,故不能用nil来判断key是否找到
 */
//+ (id) UndefinedValue;

/**
 * 这个方法能避免由于对象为nil的情况底下,跳过比较过程而导致结果不赋值的问题.
 * 如在"BOOL r = [a isEqual:b]"中,由于a==nil而导致r没有赋值
 */
+ (BOOL) is:(id)a equalsTo:(id)b;

@end

/**
 * 可序列化对象接口
 */
@protocol JISerializeObject <JIObject>

/**
 * 指定该如何序列化对象
 * key=>value格式为:序列化时的属性名字=>JWSerializeObject
 */
- (NSDictionary*) serializeMembers;

/**
 * 指定哪个方法为序列化对象时返回序列化列表
 * 原为使用SEL来实现的,不过使用SEL需要在@protocol中定义了相关的方法,不然会出现警告"PerformSelector may cause a leak because its selector is unknown".
 * 原因为selector参数和返回值可以跟指定的不匹配,调用时也不崩溃,相当危险.
 * 故改为使用方法id进行指定方法的解决方案,使用时子类需实现这个方法.
 */
- (NSDictionary*) serializeMethod:(NSInteger)methodId;
//- (NSDictionary*) serializeMembersWith:(SEL)serializeSelector;

/**
 * 方便的使用字符串设置对象属性值的方法
 */
- (void) setStringValue:(NSString*)value withClass:(Class)valueClass forKey:(NSString*)key;

@end

/**
 * 可序列化对象
 */
@interface JWSerializeObject : JWObject <JISerializeObject>

- (NSDictionary*) mergeSerializeInfos:(NSArray*)infos;

@end

/**
 * 序列化信息
 */
@interface JWSerializeInfo : NSObject

/**
 * 属性名字(必须和属性定义时的名字一致,若为nil,则取序列化时的key作为名字)
 */
@property (nonatomic, readwrite) NSString* name;

/**
 * 对象类型,如果是数组,则是数组元素类型
 */
@property (nonatomic, readwrite) Class objClass;

/**
 * 数组类型
 */
@property (nonatomic, readwrite) Class arrayClass;

- (id) initWithClass:(Class)objClass;
- (id) initWithName:(NSString*)name objClass:(Class)objClass;
- (id) initWithArrayClass:(Class)arrayClass itemClass:(Class)itemClass;
- (id) initWithArrayName:(NSString*)name arrayClass:(Class)arrayClass itemClass:(Class)itemClass;

+ (id) objectWithClass:(Class)objClass;
+ (id) objectWithName:(NSString*)name objClass:(Class)objClass;
+ (id) arrayWithClass:(Class)arrayClass itemClass:(Class)itemClass;
+ (id) arrayWithName:(NSString*)name arrayClass:(Class)arrayClass itemClass:(Class)itemClass;

@end
