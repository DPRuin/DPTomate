//
//  TodayViewController.m
//  DPToday
//
//  Created by 土老帽 on 16/4/27.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "DPTimerView.h"
#import "PureLayout.h"
#import "DPConst.h"

#define TimerViewWH 100.0

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, weak) DPTimerView *timerView;
@property (nonatomic, weak) UIButton *button;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DPTimerView *timerView = [[DPTimerView alloc] init];
    timerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:timerView];
    self.timerView = timerView;
    UIFont *timeLabelFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:(TimerViewWH*0.9/3.0-10.0)];
    [self.timerView setTimeLabelFont:timeLabelFont];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:btn];
    self.button = btn;
    self.button.backgroundColor = [UIColor clearColor];
    [self.button addTarget:self action:@selector(openApp) forControlEvents:UIControlEventTouchUpInside];
    
    // 布局
    [self.timerView autoSetDimension:ALDimensionWidth toSize:TimerViewWH];
    [self.timerView autoSetDimension:ALDimensionHeight toSize:TimerViewWH];
    [self.timerView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.timerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0];
    
    [self.button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}



- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(0, 0, 88.0, 0);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.dpruin.tomate"];
    
    double startDateAsTimeStamp = [defaults doubleForKey:@"date"];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:startDateAsTimeStamp];
    self.maxValue = [defaults integerForKey:@"maxValue"];
    
    DPLog(@"widgeUpdate-endate:%@ -maxValue-%ld", self.endDate, self.maxValue);
    
    [self.timerView setDuration:0 maxValue:1.0];
    
    [self.timer invalidate];
    if (self.endDate != nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    }
    
    completionHandler(NCUpdateResultNewData);
}

/**
 *  更新label
 */
- (void)updateLabel
{
    double durationInSeconds = [self.endDate timeIntervalSinceNow];
    if (durationInSeconds > 0) {
        [self.timerView setDuration:(CGFloat)durationInSeconds maxValue:(CGFloat)self.maxValue];
    } else {
        [self.timer invalidate];
    }
}

/**
 *  打开ContainingApp
 */
- (void)openApp
{
    NSURL *url = [NSURL URLWithString:@"DPTomate://"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        if (!success) {
            DPLog(@"打开app失败");
        }
    }];
}

@end
