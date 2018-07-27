//
//  AppDelegate.m
//  MiPushDemo
//
//  Created by HellowWorld on 2018/7/3.
//  Copyright © 2018年 YNTCode. All rights reserved.
//

#import "AppDelegate.h"
#import "MiPushSDK.h"
#import "AppDelegate+Vendor.h"

@interface AppDelegate ()<MiPushSDKDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /** 初始化window */
    [self initWindow];
    
    /** 注册小米推送 */
    [self initMiPush];
    
    /** app冷启动,保存小米推送消息 */
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [self saveMiPushMessage:userInfo];
    /** 冷启动响应推送消息,可以放到主页面控制器的viewdidload中 */
    [self dealMiPushMessage];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- 注册推送成功失败回调
/**
 推送注册成功
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /** 注册成功绑定设备号 */
    NSLog(@"小米推送注册成功");
    [MiPushSDK bindDeviceToken:deviceToken];
}
/**
 推送注册失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"小米推送注册失败");
}

#pragma mark -- 小米sdk异步回调
/**
  小米成功回调
  */
 - (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
 {
      NSLog(@"小米成功回调");
     if ([selector isEqualToString:@"bindDeviceToken:"]) {
         NSLog(@"regid = %@", data[@"regid"]);
         self.regid = data[@"regid"];
     }
 }

 - (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
 {
      NSLog(@"小米回调失败:%d",error);
 }

#pragma mark -- 收到推送消息回调
/**
 iOS 9.0 应用处于前台,收到通知或点击通知消息,均执行该方法
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 {
    //使用此方法后，所有消息会进行去重，然后通过miPushReceiveNotification:回调返回给App
    NSLog(@"收到小米推送_____________");
     [MiPushSDK handleReceiveRemoteNotification:userInfo];
 }

/**
 iOS10 应用在前台收到通知
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"收到小米推送_____________");
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    /** 如果在前台收到推送消息,并且需要显示到通知栏,需要实现该Handler */
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

#pragma mark -- 点击通知栏消息进入app
/**
 iOS 10,应用处于后台或者未启动,点击通知栏进入应用,会先执行该方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"点击通知栏,响应小米推送_____________");
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
        /** 因为应用处于后台或者冷启动两种状态都会调用该方法,所以在该方法和 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 方法中都保存一下推送信息,保证两种状态都会存储推送信息 */
        [self saveMiPushMessage:userInfo];
        
        /** app冷启动时,点击通知栏消息会先执行该方法,然后执行 didFinishLaunchingWithOptions 方法,所以这个地方调用 dealMiPushMessage 只有应用处于后台时才会生效,因为如果是冷启动,window未初始化,无法做页面跳转操作 */
        [self dealMiPushMessage];
    }
    completionHandler();
}

#pragma mark -- 当app处在前台,长连接收取推送
 /**
  当app启动并运行在前台时,sdk内部会运行一个socket长连接到server端,来接收推送消息

  @param data 消息格式跟APNs格式一样
  */
 - ( void )miPushReceiveNotification:( NSDictionary *)data
 {
     NSLog(@"小米回调前台:%@",data);
 }

@end
