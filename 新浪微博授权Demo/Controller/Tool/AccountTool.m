
//帐号保存的路径
#define AccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "AccountTool.h"
#import "AccountModel.h"

@implementation AccountTool

+ (void)save:(AccountModel *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:AccountFilepath];
}

+ (AccountModel *)account
{
    // 读取帐号
    AccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilepath];
    
    // 判断帐号是否已经过期
    NSDate *now = [NSDate date];

    if ([now compare:account.expires_time] != NSOrderedAscending) { // 过期
        account = nil;
    }
    return account;
}

/**
 NSOrderedAscending = -1L,  升序，越往右边越大
 NSOrderedSame, 相等，一样
 NSOrderedDescending 降序，越往右边越小
 */
@end
