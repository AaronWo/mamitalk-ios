//
//  AppDelegate.h
//  RongCloud
//
//  Created by haosu on 15/10/21.
//  Copyright © 2015年 haosu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *naviController;
@end

