//
//  ConditionShowSegue.m
//  RongCloud
//
//  Created by haosu on 15/10/27.
//  Copyright © 2015年 haosu. All rights reserved.
//

#import "ConditionShowSegue.h"
#import <RongIMKit/RongIMKit.h>

@implementation ConditionShowSegue

- (void)perform {
  UIViewController *srcVC = self.sourceViewController;
  UIViewController *destVC = self.destinationViewController;

  if ([destVC isKindOfClass:[RCConversationViewController class]]) {
    NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
    RCConversationViewController *conversationVC = destVC;
    conversationVC.conversationType =
        ConversationType_PRIVATE;  //会话类型，这里设置为 PRIVATE
                                   //即发起单聊会话。

    conversationVC.targetId = [userDefauls
        objectForKey:@"targetId"];  // 接收者的 targetId，这里为举例。
    conversationVC.userName = [userDefauls
        objectForKey:@"userName"];  // 接受者的 username，这里为举例。
    NSString *title =
        [NSString stringWithFormat:@"与%@的聊天", conversationVC.userName];
    conversationVC.title = title;  // 会话的 title。
    srcVC.title = title;

    [srcVC addChildViewController:conversationVC];
    [srcVC.view addSubview:conversationVC.view];
    conversationVC.view.frame =
        CGRectMake(0, 0, CGRectGetWidth(srcVC.view.frame),
                   CGRectGetHeight(srcVC.view.frame));
    [conversationVC didMoveToParentViewController:srcVC];
  } else {
    [srcVC addChildViewController:destVC];
    [srcVC.view addSubview:destVC.view];
    destVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(srcVC.view.frame),
                                   CGRectGetHeight(srcVC.view.frame));
    [destVC didMoveToParentViewController:srcVC];
  }
}

@end
