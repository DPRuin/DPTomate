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
#import "UIView+AutoLayout.h"
#import "DPConst.h"

#define TimerViewWH 100.0

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int maxValue;
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
    [self.timerView setTimeLabelFont:[UIFont systemFontOfSize:(TimerViewWH*0.9/3.0-10.0)]];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:btn];
    self.button = btn;
    
    [self.timerView autoSetDimension:ALDimensionHeight toSize:TimerViewWH];
    [self.timerView autoSetDimension:ALDimensionWidth toSize:TimerViewWH];
    [self.timerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.timerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0];
    
    [self.button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    DPLog(@"layoutSublayersOfLayer");
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {

    completionHandler(NCUpdateResultNoData);
}

@end
