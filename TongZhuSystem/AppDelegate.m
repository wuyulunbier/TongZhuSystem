//
//  AppDelegate.m
//  TongZhuSystem
//
//  Created by hsk on 2021/1/14.
//

#import "AppDelegate.h"
#import "WebViewController.h"

#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

#define APPKey @"60014ee46a2a470e8f7b1f94"
#define APPSecret @"3rp5ngvdxnkw3njfrz6a8ia8c0pv0iqm"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor =[UIColor blueColor];
    
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    
    [self UmengPush:launchOptions delegate:self];
    
    self.window.rootViewController = [[WebViewController alloc]initWithURL:@"http://1.180.192.34:8010/"];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}



/**
 *友盟推送
 */
- (void)UmengPush:(NSDictionary *)options delegate:(id)delegate{
    
    
    [UMConfigure initWithAppkey:@"60014ee46a2a470e8f7b1f94" channel:@"App Store"];
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
       
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:options Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            NSLog(@"--get--");
        }else{
            NSLog(@"--refuse--");
        }
        
        NSLog(@"--%@",error.description);
        
    }];

    

    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate= delegate;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
   
    //推送通知
    NSNotification *notification =[NSNotification notificationWithName:@"notice" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
    
        //[UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    }else{
        //应用处于前台时的本地推送接受
    }
    //推送通知
    NSNotification *notice =[NSNotification notificationWithName:@"notice" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"notification-userinfo:%@", userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
     
    } else {
        
    }
}

//iOS10以前接收的方法
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //这个方法用来做action点击的统计
//    [UMessage sendClickReportForRemoteNotification:userInfo];
    
    //推送通知
    NSNotification *notification =[NSNotification notificationWithName:@"notice" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken

{

    if (![deviceToken isKindOfClass:[NSData class]]) return;
       const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
       NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                             ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                             ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                             ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
       NSLog(@"deviceToken:%@",hexToken);

}



@end
