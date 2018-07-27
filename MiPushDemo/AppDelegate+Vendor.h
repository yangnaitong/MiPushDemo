//
//  AppDelegate+Vendor.h
//  MiPushDemo
//
//  Created by HellowWorld on 2018/7/3.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "AppDelegate.h"

static NSString * const LocalMiPushMessage = @"LocalMiPushMessage";

@interface AppDelegate (Vendor)

/** 初始化window */
- (void)initWindow;

/** 初始化小米推送 */
- (void)initMiPush;

/** 保存小米推送消息 */
- (void)saveMiPushMessage:(NSDictionary *)userInfo;

/** 处理小米推送消息 */
- (void)dealMiPushMessage;

@end
