#import <Foundation/Foundation.h>

//帐号模型

@interface AccountModel : NSObject  <NSCoding>
/** string 	用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString *access_token;

/** string 	access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSString *expires_in;

/** 过期时间 */
@property (nonatomic, strong) NSDate *expires_time;

/** string 	当前授权用户的UID。*/
@property (nonatomic, copy) NSString *uid;

/** 工厂方法:字典转模型 **/
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
