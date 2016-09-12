
//授权页面

#import "OAuth_ViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"

#import "AccountModel.h"
#import "AccountTool.h"

#import "Main_ViewController.h"
#import "ControllerTool.h"

#ifdef DEBUG // 调试状态, 打开LOG功能
#define HMLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define HMLog(...)
#endif

// 颜色
#define HMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define HMRandomColor HMColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 是否为4inch
#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)

// 导航栏标题的字体
#define HMNavigationTitleFont [UIFont boldSystemFontOfSize:20]

// 应用信息
#define HMAppKey @"822914094"
#define HMAppSecret @"b6a257bbbc032f6fbbce6ce56487ca41"
#define HMRedirectURI @"http://www.huangpuqu.sh.cn/shhp/download/SHHPMobileOA.apk"

@interface OAuth_ViewController () <UIWebViewDelegate>

@end

@implementation OAuth_ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.创建UIWebView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    // 2.加载登录页面
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", HMAppKey, HMRedirectURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    // 3.设置代理
    webView.delegate = self;
}

#pragma mark - UIWebViewDelegate
/**
 *  UIWebView开始加载资源的时候调用(开始发送请求)
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中..."];
}

/**
 *  UIWebView加载完毕的时候调用(请求完毕)
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

/**
 *  UIWebView加载失败的时候调用(请求失败)
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

/**
 *  UIWebView每当发送一个请求之前，都会先调用这个代理方法（询问代理允不允许加载这个请求）
 *
 *  @param request        即将发送的请求
 
 *  @return YES : 允许加载， NO : 禁止加载
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获得请求地址
    NSString *url = request.URL.absoluteString;
    
    // 2.判断url是否为回调地址
    NSString *str = [NSString stringWithFormat:@"%@?code=", HMRedirectURI];
    NSRange range = [url rangeOfString:str];
    if (range.location != NSNotFound) { // 是回调地址
        // 截取授权成功后的请求标记
        int from = range.location + range.length;
        NSString *code = [url substringFromIndex:from];
        
        // 根据code获得一个accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载回调页面
        return NO;
    }
    
    return YES;
}

/**
 *  根据code获得一个accessToken(发送一个POST请求)
 *
 *  @param code 授权成功后的请求标记
 */
- (void)accessTokenWithCode:(NSString *)code
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = HMAppKey;
    params[@"client_secret"] = HMAppSecret;
    params[@"redirect_uri"] = HMRedirectURI;
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    
    // 3.发送POST请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *accountDict) {
        // 隐藏HUD
        [MBProgressHUD hideHUD];
        
        //返回数据字典
        //        {
        //            "access_token" = "2.00BOJ7kB0yXrgtcc4a938aee0klp6c";
        //            "expires_in" = 644027;
        //            "remind_in" = 644027;
        //            uid = 1602076281;
        //        }
        
        HMLog(@"请求成功--%@", accountDict);
        
        // 字典转成模型
        AccountModel *account = [AccountModel accountWithDict:accountDict];
        
        // 存储帐号模型
        [AccountTool save:account];
        
        // 切换控制器：显示主界面
        [ControllerTool chooseRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 隐藏HUD
        [MBProgressHUD hideHUD];
        
        HMLog(@"请求失败--%@", error);
    }];
}

/**
 Request failed: unacceptable content-type: text/plain
 */

@end
