//
//  AppDelegate.m
//  RongCloud
//
//  Created by haosu on 15/10/21.
//  Copyright © 2015年 haosu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.

  [[RCIM sharedRCIM] initWithAppKey:@"cpj2xarljdmnn"];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults objectForKey:@"token"];
  if (token != nil) {
    [[RCIM sharedRCIM] connectWithToken:token
        success:^(NSString *userId) {
          // Connect 成功
          NSLog(@"login success: %@", userId);
        }
        error:^(RCConnectErrorCode status) {
          // Connect 失败
          NSLog(@"login failed");
        }
        tokenIncorrect:^() {
          // Token 失效的状态处理
          NSLog(@"token is not work");
        }];
  } /**
 * 推送处理1
 */
  if ([application
          respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
        settingsForTypes:(UIUserNotificationTypeBadge |
                          UIUserNotificationTypeSound |
                          UIUserNotificationTypeAlert)
              categories:nil];
    [application registerUserNotificationSettings:settings];
  } else {
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
                                       UIRemoteNotificationTypeAlert |
                                       UIRemoteNotificationTypeSound;
    [application registerForRemoteNotificationTypes:myTypes];
  }

  return YES;
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {
  // register to receive notifications
  [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSString *token =
      [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                             withString:@""]
          stringByReplacingOccurrencesOfString:@">"
                                    withString:@""]
          stringByReplacingOccurrencesOfString:@" "
                                    withString:@""];

  NSLog(@"device token: %@", deviceToken);
  [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

// 获取用户信息的方法。
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {
  // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。

  if ([@"1" isEqual:userId]) {
    RCUserInfo *user = [[RCUserInfo alloc] init];
    user.userId = @"1";
    user.name = @"韩梅梅";
    user.portraitUri =
        @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
    NSLog(@"return lilei");
    return completion(user);
  }

  if ([@"2" isEqual:userId]) {
    RCUserInfo *user = [[RCUserInfo alloc] init];
    user.userId = @"2";
    user.name = @"李雷";
    user.portraitUri =
        @"http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png";
    NSLog(@"return hanmeimei");
    return completion(user);
  }

  return completion(nil);
}

@end
