//
//  AppDelegate.h
//  MiPushDemo
//
//  Created by HellowWorld on 2018/7/3.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiPushSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/** 记录小米推送的regid,方便上传服务端,也可记录在全局类中 */
@property (nonatomic,copy)NSString *regid;

@end

