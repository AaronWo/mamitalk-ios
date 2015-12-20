//
//  ViewController.m
//  RongCloud
//
//  Created by haosu on 15/10/21.
//  Copyright © 2015年 haosu. All rights reserved.
//

#import "ViewController.h"
#import <JSONKit.h>
#import <RongIMKit/RongIMKit.h>
#import <AFNetworking.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES

@interface ViewController ()
@property(weak, nonatomic) IBOutlet UIButton *chatBtn;
@property(weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation ViewController

bool login = false;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.title = @"Login";
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputField resignFirstResponder];
}

- (IBAction)chatPress:(id)sender {
  NSLog(@"id: %@", self.inputField.text);
  // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
  RCConversationViewController *conversationVC =
      [[RCConversationViewController alloc] init];
  conversationVC.conversationType =
      ConversationType_PRIVATE;  //会话类型，这里设置为 PRIVATE 即发起单聊会话。
  NSString *idStr = self.inputField.text;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (idStr != nil) {
    // monitor network state
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [AFHTTPRequestOperationManager manager].securityPolicy = securityPolicy;
    [[AFNetworkReachabilityManager sharedManager]
        setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
          NSLog(@"%ld", status);
        }];

    AFHTTPRequestOperationManager *manager =
        [AFHTTPRequestOperationManager manager];
    NSString *url = [@"https://mamitalk.sinaapp.com/token?username="
        stringByAppendingString:idStr];
    [manager GET:url
        parameters:nil
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"responseObjectData = %@", responseObject);
          } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"token=%@", [responseObject objectForKey:@"token"]);
            [defaults setObject:[responseObject objectForKey:@"token"]
                         forKey:@"token"];
            [defaults setObject:[responseObject objectForKey:@"targetId"]
                         forKey:@"targetId"];
            [defaults setObject:[responseObject objectForKey:@"userName"]
                         forKey:@"userName"];

            [defaults synchronize];
            conversationVC.targetId = [responseObject
                objectForKey:@"targetId"];  // 接收者的 targetId，这里为举例。
            conversationVC.userName = [responseObject
                objectForKey:@"userName"];  // 接受者的 username，这里为举例。
            NSString *title = [NSString
                stringWithFormat:@"与%@的聊天", conversationVC.userName];
            conversationVC.title = title;  // 会话的 title。

            [[RCIM sharedRCIM]
                connectWithToken:[responseObject objectForKey:@"token"]
                success:^(NSString *userId) {
                  // Connect 成功
                  NSLog(@"login success: %@", userId);
                  NSUserDefaults *defaults =
                      [NSUserDefaults standardUserDefaults];
                  [defaults setObject:userId forKey:@"userId"];
                  [defaults synchronize];
                  login = true;
                }
                error:^(RCConnectErrorCode status) {
                  // Connect 失败
                  NSLog(@"login failed");
                }
                tokenIncorrect:^() {
                  // Token 失效的状态处理
                  NSLog(@"token is not work");
                }];
          }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@", error);
        }];
  }

  // 把单聊视图控制器添加到导航栈。
  [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
