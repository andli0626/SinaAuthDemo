#import <Foundation/Foundation.h>


//帐号工具类：保存帐号，读取帐号


@class AccountModel;

@interface AccountTool : NSObject

/**
 *  存储帐号
 */
+ (void)save:(AccountModel *)account;

/**
 *  读取帐号
 */
+ (AccountModel *)account;

@end
