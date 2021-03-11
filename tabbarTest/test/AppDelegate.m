//
//  AppDelegate.m
//  test
//
//  Created by apple on 2021/3/11.
//

#import "AppDelegate.h"
#import "HomeTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    HomeTabBarController * vc = [HomeTabBarController new];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}





@end
