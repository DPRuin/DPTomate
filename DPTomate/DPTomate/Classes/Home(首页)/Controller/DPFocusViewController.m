//
//  DPFocusViewController.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPFocusViewController.h"
#import "DPTimerView.h"
#import "DPButton.h"

#define DPOrangeColor DPRGBColor(212, 167, 42)
#define DPBackgroundColor DPRGBColor(41, 42, 55)

@interface DPFocusViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) UILocalNotification *localNotification;
/** 倒计时类型 */
@property (nonatomic, assign) TimerType currentType;

@property (nonatomic, assign) int totalMinutes;

/** 倒计时钟 */
@property (weak, nonatomic) IBOutlet DPTimerView *timerView;
@property (weak, nonatomic) IBOutlet DPButton *workButton;
@property (weak, nonatomic) IBOutlet DPButton *breakButton;
@property (weak, nonatomic) IBOutlet DPButton *procrastinateButton;


@end

@implementation DPFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentType = TimerTypeIdle;
    self.view.backgroundColor = DPBackgroundColor;
    
}

/**
 *  修改电量条样式
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  开始工作
 */
- (IBAction)startWork:(DPButton *)sender {
    if (self.currentType == TimerTypeWork) {
        // 提示
        [self showAlert];
        [self startTimerWithType:TimerTypeWork];
        return;
    }
}

/**
 *  开始休息
 */
- (IBAction)startBreak:(DPButton *)sender {
    if (self.currentType == TimerTypeBreak) {
        // 提示
        [self showAlert];
        [self startTimerWithType:TimerTypeBreak];
        return;
    }
}

/**
 *  开始拖延
 */
- (IBAction)startProcrastination:(DPButton *)sender {
    if (self.currentType == TimerTypeProcrastination) {
        // 提示
        [self showAlert];
        [self startTimerWithType:TimerTypeProcrastination];
        return;
    }
}

/**
 *  倒计时
 */
- (void)startTimerWithType:(TimerType)type
{
    self.timerView.durationInSeconds = 0;
    self.timerView.maxValue = 1;
    [self.timerView setNeedsDisplay];
    
    switch (type) {
        case TimerTypeWork: {
            self.currentType = TimerTypeWork;
            
            break;
        }
            
        case TimerTypeBreak: {
            self.currentType = TimerTypeBreak;
            
            break;
        }
            
        case TimerTypeProcrastination: {
            self.currentType = TimerTypeProcrastination;
            
            break;
        }
            
        default: {
            self.currentType = TimerTypeIdle;
            
            break;
        }
    }
}

/**
 *  点击按钮后按钮状态改变
 */
- (void)setUIModeForTimerType:(TimerType)type
{
    
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
