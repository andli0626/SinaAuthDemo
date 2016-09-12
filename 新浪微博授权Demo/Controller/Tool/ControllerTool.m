#import "ControllerTool.h"

#import "Main_ViewController.h"

@implementation ControllerTool
+ (void)chooseRootViewController
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Main_ViewController *view = [storyboard instantiateInitialViewController];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = view;
}
@end
