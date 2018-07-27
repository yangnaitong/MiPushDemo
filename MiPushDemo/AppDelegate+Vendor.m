//
//  AppDelegate+Vendor.m
//  MiPushDemo
//
//  Created by HellowWorld on 2018/7/3.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "AppDelegate+Vendor.h"
#import "MiPushSDK.h"
#import "YNTPushViewController.h"

@implementation AppDelegate (Vendor)

/** 初始化window */
- (void)initWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    YNTPushViewController *pushVC = [[YNTPushViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pushVC];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
}


/** 初始化小米推送 */
- (void)initMiPush
{
    [MiPushSDK registerMiPush:self type:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert connect:YES];
}

/** 保存小米推送消息 */
- (void)saveMiPushMessage:(NSDictionary *)userInfo
{
    if(userInfo){//推送信息
        NSString *messageId = [userInfo objectForKey:@"_id_"];
        if (messageId != nil) {
            [MiPushSDK openAppNotify:messageId];
            /** 可以使用key-value定义一些响应参数(如action为推送消息响应动作),app接收到通知后,解析action,响应action */
            NSString *actionStr = [userInfo objectForKey:@"action"];
            if (actionStr.length > 0) {
                NSString *actionStr = [userInfo objectForKey:@"action"];
                [[NSUserDefaults standardUserDefaults] setObject:actionStr forKey:LocalMiPushMessage];
            }
        }
    }
}

/** 处理小米推送消息 */
- (void)dealMiPushMessage
{
    NSString * action = [[NSUserDefaults standardUserDefaults] objectForKey:LocalMiPushMessage];
    /** 解析action,做出后续处理 */
}
@end
