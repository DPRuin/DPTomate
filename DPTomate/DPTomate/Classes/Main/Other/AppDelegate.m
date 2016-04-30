//
//  AppDelegate.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/6.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "AppDelegate.h"
#import "DPFocusViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppDelegate () <WCSessionDelegate>

@property (nonatomic, strong) DPFocusViewController *focusVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 应用的默认设置
    [self registerDefaultUserDefaults];
    
    [self setupSession];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  激活session
 */
- (void)setupSession
{
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
}

/**
 * 应用的默认设置
 */
- (void)registerDefaultUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setInteger:1501 forKey:TimerTypeWorkKey];
    [[NSUserDefaults standardUserDefaults] setInteger:301 forKey:TimerTypeBreakKey];
    [[NSUserDefaults standardUserDefaults] setInteger:601 forKey:TimerTypeProcrastinationKey];
    
    [NSUserDefaults standardUserDefaults] ;
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 注册通知
    // watch通知相关
    UIMutableUserNotificationAction *breakAction = [[UIMutableUserNotificationAction alloc] init];
    breakAction.identifier = UserNotificationBreakActionIdentifier;
    breakAction.title = NSLocalizedString(@"Start Break", nil);
    breakAction.activationMode = UIUserNotificationActivationModeBackground;
    
    UIMutableUserNotificationAction *workAcion = [[UIMutableUserNotificationAction alloc] init];
    workAcion.identifier = UserNotificationWorkActionIdentifier;
    workAcion.title = NSLocalizedString(@"Start Work", nil);
    workAcion.activationMode = UIUserNotificationActivationModeBackground;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    [category setActions:@[breakAction, workAcion] forContext:UIUserNotificationActionContextDefault];
    category.identifier = LocalNotificationCategoryIdentifier;
    
    UIUserNotificationType notificationType = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *notificaitonSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories: [NSSet setWithArray:@[category]]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificaitonSettings];
}

#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message
{
    
}

#pragma mark - 懒加载
/**
 *  懒加载
 */
- (DPFocusViewController *)focusVC
{
    if (!_focusVC) {
        UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        DPFocusViewController *focusVC = (DPFocusViewController *)[homeSB instantiateViewControllerWithIdentifier:@"DPFocusViewController"];
        self.focusVC = focusVC;
    }
    return _focusVC;
}

#pragma mark - applicationDelegate
/**
 *  Watch通知选中action后调用
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    DPLog(@"handleActionWithIdentifier");
    
    if (identifier == UserNotificationBreakActionIdentifier) { // 开始休息
        [self.focusVC startBreak:nil];
    } else if (identifier == UserNotificationWorkActionIdentifier) { // 开始工作
        [self.focusVC startWork:nil];
    }
    
    // 激活session
    [self setupSession];
    
    completionHandler();

}

/**
 *  3DTouch
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    
    NSString *shortcut = shortcutItem.type;
    DPLog(@"performActionForShortcutItem-%@", shortcut);
    NSString *last = [[shortcut componentsSeparatedByString:@"."] lastObject];
    if (last == nil) {
        completionHandler(NO);
    }
    
    if ([last isEqualToString:@"Work"]) {
        [self.focusVC startTimerWithType:TimerTypeWork];
    } else if ([last isEqualToString:@"Break"]) {
        [self.focusVC startTimerWithType:TimerTypeBreak];
    } else {
        completionHandler(NO);
    }
    
    completionHandler(YES);
}

@end
