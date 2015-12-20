//
//  ConditionViewController.m
//  RongCloud
//
//  Created by haosu on 15/10/27.
//  Copyright © 2015年 haosu. All rights reserved.
//

#import "ConditionViewController.h"
#import <RongIMKit/RongIMKit.h>

@implementation ConditionViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults objectForKey:@"token"];
  if (token != nil) {
    [self performSegueWithIdentifier:@"ShowLogined" sender:self];
  } else {
    NSLog(@"need to login");
    [self performSegueWithIdentifier:@"ShowNeedLogin" sender:self];
  }
}
@end
