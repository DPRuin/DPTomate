//
//  InterfaceController.m
//  TomateWatch Extension
//
//  Created by 土老帽 on 16/4/29.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "InterfaceController.h"
#import "DPConst.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <ClockKit/ClockKit.h>

static NSString *const timeStampKey = @"timeStamp";
static NSString *const maxValueKey = @"maxValue";

@interface InterfaceController() <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTimer *timeInterface;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *backgroundGroup;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** backgroundGroup背景图片数字 */
@property (nonatomic, assign) NSInteger currentBackgroundImageNumber;
/** 分母 */
@property (nonatomic, assign) NSInteger maxValue;

/** 倒计时结束时间 */
@property (nonatomic, strong) NSDate *endDate;


@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.currentBackgroundImageNumber = 0;
    self.maxValue = 1;
    
    // 激活session
    WCSession *session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
}

- (void)willActivate {
    [super willActivate];
    double timeStamp = [[NSUserDefaults standardUserDefaults] doubleForKey:timeStampKey];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    self.maxValue = [[NSUserDefaults standardUserDefaults] integerForKey:maxValueKey];
    self.currentBackgroundImageNumber = 0;
}

- (void)didDeactivate {
    [super didDeactivate];
    
}

/**
 *  更新时间环
 */
- (void)updateUserInterface
{
}

/** 
 *  重写set方法
 */
- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    
    if ([self.endDate compare:[NSDate date]] == NSOrderedDescending) { // 继续倒计时
        [self.timeInterface setDate:self.endDate];
        [self.timeInterface start];
        
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateUserInterface) userInfo:nil repeats:YES];
    } else {
        [self.timeInterface stop];
        [self.timer invalidate];
    }
    
}

#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        double timeStamp = [applicationContext[@"date"] doubleValue];
        if (timeStamp > 0) {
            
            self.maxValue = [applicationContext[@"maxValue"] integerValue];
            self.endDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
            self.currentBackgroundImageNumber = 0;
            
            [[NSUserDefaults standardUserDefaults] setDouble:timeStamp forKey:timeStampKey];
            [[NSUserDefaults standardUserDefaults] setInteger:self.maxValue forKey:maxValueKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {
            [self.timer invalidate];
            [self.timeInterface stop];
            [self.timeInterface setDate:[NSDate date]];
            [self.backgroundGroup setBackgroundImageNamed:nil];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:timeStampKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:maxValueKey];
            
        }
    });
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo
{
    // 自定义表盘
}



@end



