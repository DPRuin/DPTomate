//
//  DPFocusViewController.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPFocusViewController.h"
#import "DPButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "PureLayout.h"

@interface DPFocusViewController () <WCSessionDelegate>

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSDate *endDate;
/** 本地通知 */
@property (nonatomic, strong) UILocalNotification *localNotification;

/** 倒计时类型 */
@property (nonatomic, assign) TimerType currentType;

@property (nonatomic, assign) int totalMinutes;

/** 倒计时钟 */
@property (weak, nonatomic) IBOutlet DPTimerView *timerView;

/** 工作按钮 */
@property (weak, nonatomic) IBOutlet DPButton *workButton;
/** 休息按钮 */
@property (weak, nonatomic) IBOutlet DPButton *breakButton;
/** 拖延按钮 */
@property (weak, nonatomic) IBOutlet DPButton *procrastinateButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *procrastinateTopSpace;

@end

@implementation DPFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentType = TimerTypeIdle;
    self.view.backgroundColor = DPBackgroundColor;
    // 导航栏不透明
    self.navigationController.navigationBar.translucent = NO;
    // self.navigationController.navigationBarHidden = YES;
    
    if (self.timer == nil) {
        [self.timerView setDuration:0 maxValue:1];
    }
    NSInteger duration = [[NSUserDefaults standardUserDefaults] integerForKey:TimerTypeWorkKey];
    DPLog(@"-duration- %ld", duration);
    
    // self.timerView.backgroundColor = [UIColor blueColor];
//    self.timerView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.timerView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.timerView];
    
    // DPLog(@"----%@", NSStringFromCGRect(self.view.frame));
    // ipad横屏启动时默认为20
//    if (self.view.frame.size.width == 1024) {
//        self.procrastinateTopSpace.constant = 20.0;
//    }
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    // 屏幕旋转时space 切换 20 - 40
//    CGFloat space = (size.width == 1024)? 20.0: -40.0;
//    self.procrastinateTopSpace.constant = space;
//    [self.timerView setNeedsDisplay];
//}

//- (void)viewWillLayoutSubviews
//{
//
//    [self.timerView setNeedsDisplay];
//}

/**
 *  修改电量条样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 按钮点击了
/**
 *  开始工作
 */
- (IBAction)startWork:(DPButton *)sender {
    if (self.currentType == TimerTypeWork) {
        // 提示
        [self showAlert];
        return;
    }
    [self startTimerWithType:TimerTypeWork];
}

/**
 *  开始休息
 */
- (IBAction)startBreak:(DPButton *)sender {
    if (self.currentType == TimerTypeBreak) {
        // 提示
        [self showAlert];
        return;
    }
    [self startTimerWithType:TimerTypeBreak];
}

/**
 *  开始拖延
 */
- (IBAction)startProcrastination:(DPButton *)sender {
    if (self.currentType == TimerTypeProcrastination) {
        // 提示
        [self showAlert];
        return;
    }
    [self startTimerWithType:TimerTypeProcrastination];
}

/**
 *  开时倒计时
 */
- (void)startTimerWithType:(TimerType)type
{
    DPLog(@"startTimerWithType-%ld", type);
    [self.timerView setDuration:0 maxValue:1.0];
    
    // 倒计多少秒
    NSInteger seconds;
    // 用于本地通知
    NSString *typeName = @"";
    
    switch (type) {
        case TimerTypeWork: {
            self.currentType = TimerTypeWork;
            seconds = [[NSUserDefaults standardUserDefaults] integerForKey:TimerTypeWorkKey];
            typeName = NSLocalizedString(@"Work", nil);
            break;
        }
            
        case TimerTypeBreak: {
            self.currentType = TimerTypeBreak;
            seconds = [[NSUserDefaults standardUserDefaults] integerForKey:TimerTypeBreakKey];
            typeName = NSLocalizedString(@"Break", nil);
            break;
        }
            
        case TimerTypeProcrastination: {
            self.currentType = TimerTypeProcrastination;
            seconds = [[NSUserDefaults standardUserDefaults] integerForKey:TimerTypeProcrastinationKey];
            typeName = NSLocalizedString(@"Procrastination", nil);
            break;
        }
            
        default: {
            self.currentType = TimerTypeIdle;
            seconds = 0;
            [self resetTimer];
            
            // 取消通知
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            break;
        }
    }
    DPLog(@"--seconds-%ld", seconds);
    // 结束时间
    self.endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:seconds];
    
    // 按钮状态设置
    [self setUIModeForTimerType:type];
    
    // WidgeExtention 传递数据
    double endTimeStamp = [self.endDate timeIntervalSince1970];
    NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dpruin.dppomodoro"];
    if (shareDefaults) {
        [shareDefaults setDouble:endTimeStamp forKey:@"date"];
        [shareDefaults setInteger:seconds forKey:@"maxValue"];
        [shareDefaults synchronize];
    }
    
    // watch传输数据
    WCSession *session = [WCSession defaultSession];
    if (session.paired && session.watchAppInstalled) { // watch已配对且watchApp已安装
        NSError *error;
        [session updateApplicationContext:@{@"date" : @(endTimeStamp), @"maxValue" : @(seconds)} error:&error];
        if (error) {
            DPLog(@"session-发送数据出错");
        }
        
        [session transferCurrentComplicationUserInfo:@{@"date" : @(endTimeStamp), @"maxValue" : @(seconds)}];
        
    }
    
    // 定时器
    [self.timer invalidate];
    NSNumber *secondsNumber = [NSNumber numberWithInteger:seconds];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeLabel:) userInfo:@{@"timerType" : secondsNumber} repeats:YES];
    
    // 本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.localNotification = [[UILocalNotification alloc] init];
    self.localNotification.fireDate = self.endDate;
    NSString *alertBody = NSLocalizedString(@"time is up!", nil);
    
    self.localNotification.alertBody = [NSString stringWithFormat:@"%@ %@", typeName, alertBody];
    self.localNotification.soundName = UILocalNotificationDefaultSoundName;
    self.localNotification.category = LocalNotificationCategoryIdentifier;
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    
    
    
}

/**
 *  更新timeLabel
 */
- (void)updateTimeLabel:(NSTimer *)timer
{
    CGFloat totalNumberOfSeconds;
    NSNumber *seconds = timer.userInfo[@"timerType"];
    // DPLog(@"-seconds-%@", seconds);
    if (seconds) {
        totalNumberOfSeconds = seconds.floatValue;
    } else {
        NSAssert(NO, @"错误：不应该来到这里");
        totalNumberOfSeconds = -1.0;
    }
    
    CGFloat timeInterval = [self.endDate timeIntervalSinceNow];
    if (timeInterval < 0) {
        [self resetTimer];
        if (timeInterval > -1) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
        
        [self.timerView setDuration:0 maxValue:1.0];
        
        return;
    }

    [self.timerView setDuration:timeInterval maxValue:totalNumberOfSeconds];
    
}

/**
 *  重置定时器
 */
- (void)resetTimer
{
    // 定时器无效
    [self.timer invalidate];
    self.timer = nil;
    
    self.currentType = TimerTypeIdle;
    [self setUIModeForTimerType:TimerTypeIdle];
    
    // widgeExtention
    NSUserDefaults *shareDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dpruin.dppomodoro"];
    if (shareDefaults) {
        [shareDefaults removeObjectForKey:@"date"];
        [shareDefaults synchronize];
    }
    
    // watch发送数据
    WCSession *session = [WCSession defaultSession];
    if (session.paired && session.watchAppInstalled) {
        NSError *error;
        [session updateApplicationContext:@{@"date" : @(-1.0), @"maxValue" : @(-1)} error:&error];
        if (error) {
            DPLog(@"session-resert-发送数据出错");
        }
        
        [session transferCurrentComplicationUserInfo:@{@"date" : @(-1.0), @"maxValue" : @(-1)}];
    }
}

/**
 *  点击按钮后按钮状态改变
 */
- (void)setUIModeForTimerType:(TimerType)type
{
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        switch (type) {
            case TimerTypeWork: { // 工作
                [self setButton:self.workButton enabled:YES];
                [self setButton:self.breakButton enabled:NO];
                [self setButton:self.procrastinateButton enabled:NO];
                
                break;
            }
                
            case TimerTypeBreak: { // 休息
                [self setButton:self.workButton enabled:NO];
                [self setButton:self.breakButton enabled:YES];
                [self setButton:self.procrastinateButton enabled:NO];
                break;
            }
                
            case TimerTypeProcrastination: { // 拖延
                [self setButton:self.workButton enabled:NO];
                [self setButton:self.breakButton enabled:NO];
                [self setButton:self.procrastinateButton enabled:YES];
                break;
            }
                
            default: {
                [self setButton:self.workButton enabled:YES];
                [self setButton:self.breakButton enabled:YES];
                [self setButton:self.procrastinateButton enabled:YES];
                break;
            }
        }
        
    } completion:nil];
}

/**
 *  设置按钮enabled
 */
- (void)setButton:(DPButton *)button enabled:(BOOL)enabled
{
    if (enabled) {
        button.enabled = YES;
        button.alpha = 1.0;
    } else {
        button.enabled = NO;
        button.alpha = 0.3;
    }
}


/**
 *  提示
 */
- (void)showAlert {
    
    NSMutableString *alertMessage = [NSMutableString stringWithString:NSLocalizedString(@"Do you want to stop this ", nil)];
    switch (self.currentType) {
        case TimerTypeWork: // 工作
            [alertMessage appendString:NSLocalizedString(@"work timer?", nil)];
            break;
            
        case TimerTypeBreak: // 休息
            [alertMessage appendString:NSLocalizedString(@"break timer?", nil)];
            break;
            
        case TimerTypeProcrastination: // 拖延
            [alertMessage appendString:NSLocalizedString(@"procrastination?", nil)];
            break;
        default:
            break;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Stop?", nil) message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *stopAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Stop", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 停止倒计时
        [self startTimerWithType:TimerTypeIdle];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:stopAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
