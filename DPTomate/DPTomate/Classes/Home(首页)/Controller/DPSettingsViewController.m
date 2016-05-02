//
//  DPSettingsViewController.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPSettingsViewController.h"
#import "DPInputHostView.h"

@interface DPSettingsViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet DPInputHostView *workInputHostView;
@property (weak, nonatomic) IBOutlet DPInputHostView *breakInputHostView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

/** 工作间隔 */
@property (nonatomic, strong) NSArray *workTimes;
/** 休息间隔 */
@property (nonatomic, strong) NSArray *breakTimes;

/** 现在工作间隔 */
@property (nonatomic, assign) NSInteger currentWorkDurationInMinutes;
/** 现在休息间隔 */
@property (nonatomic, assign) NSInteger currentBreakDurationInMinutes;

@property (nonatomic, assign) SettingTimerType selectedTimerType;
@end

@implementation DPSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DPBackgroundColor;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    // 选中那行显示指示器
    self.pickerView.showsSelectionIndicator = YES;
    
    
    self.currentBreakDurationInMinutes = [[NSUserDefaults standardUserDefaults] integerForKey:TimerTypeBreakKey] / 60;
    self.currentWorkDurationInMinutes = [[NSUserDefaults standardUserDefaults] integerForKey:TimerTypeWorkKey] / 60;
    
    self.title = NSLocalizedString(@"Setting", nil);
    // 默认选中work
    self.selectedTimerType = SettingTimerTypeWork;
    self.workInputHostView.selected = YES;
    
    // 添加手势
    UITapGestureRecognizer *workTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputHostViewDidSelected:)];
    UITapGestureRecognizer *breakTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputHostViewDidSelected:)];
    [self.workInputHostView addGestureRecognizer:workTap];
    [self.breakInputHostView addGestureRecognizer:breakTap];
    
    [self.workInputHostView setName:NSLocalizedString(@"Work Duration", nil) duration:[NSString stringWithFormat:@"%ld min", self.currentWorkDurationInMinutes]];
    [self.breakInputHostView setName:NSLocalizedString(@"Break Duration", nil) duration:[NSString stringWithFormat:@"%ld min", self.currentBreakDurationInMinutes]];
    
    // 选择器默认显示选中那行
    int row = 0;
    for (int i = 0; i < self.workTimes.count; i++) {
        if (self.currentWorkDurationInMinutes == [self.workTimes[i] integerValue]) {
            row = i;
            break;
        }
    }
    
    [self.pickerView selectRow:row inComponent:0 animated:YES];
}


/**
 *  输入框被点击了
 */
- (void)inputHostViewDidSelected:(UITapGestureRecognizer *)tap
{
    // 改变选中状态
    DPInputHostView *selectInputHostView = (DPInputHostView *)tap.view;
    selectInputHostView.selected = YES;
    if (self.workInputHostView == selectInputHostView) {
        DPLog(@"workSelected");
        self.breakInputHostView.selected = NO;
        self.selectedTimerType = SettingTimerTypeWork;
    } else {
        DPLog(@"breakSelected");
        self.workInputHostView.selected = NO;
        self.selectedTimerType = SettingTimerTypeBreak;
    }
    
    // 选择器重新加载
    [self.pickerView reloadAllComponents];
    
    NSArray *times;
    NSInteger currentDuration;
    switch (self.selectedTimerType) {
        case SettingTimerTypeWork:
            times = self.workTimes;
            currentDuration = self.currentWorkDurationInMinutes;
            break;
            
        case SettingTimerTypeBreak:
            times = self.breakTimes;
            currentDuration = self.currentBreakDurationInMinutes;
            break;
            
        default:
            break;
    }
    
    // 选择器显示选中的那行
    int row = 0;
    for (int i = 0; i < times.count; i++) {
        if (currentDuration == [times[i] integerValue]) {
            row = i;
            break;
        }
    }
    [self.pickerView selectRow:row inComponent:0 animated:YES];
    
}

#pragma mark - 懒加载
- (NSArray *)workTimes
{
    if (!_workTimes) {
        self.workTimes = @[@"10", @"15", @"20", @"25", @"30", @"35", @"45", @"50", @"55"];
    }
    return _workTimes;
}

- (NSArray *)breakTimes
{
    if (!_breakTimes) {
        self.breakTimes = @[@"1", @"2", @"5", @"10"];
    }
    return _breakTimes;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.selectedTimerType) {
        case SettingTimerTypeWork:
            return self.workTimes.count;
            break;
        default:
            return self.breakTimes.count;
            break;
    }
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *minutes;
    switch (self.selectedTimerType) {
        case SettingTimerTypeWork:
            minutes = self.workTimes[row];

            break;
        default:
            minutes = self.breakTimes[row];
            break;
    }
    NSString *titleStr = [NSString stringWithFormat:@"%@ min", minutes];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSForegroundColorAttributeName : DPOrangeColor
                                                                                                 }];
    
    return title;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *minutes;
    NSInteger seconds;
    switch (self.selectedTimerType) {
        case SettingTimerTypeWork:
            minutes = self.workTimes[row];
            [self.workInputHostView setDurationStr:[NSString stringWithFormat:@"%@ min", minutes]];
            
            seconds = minutes.integerValue * 60 + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:seconds forKey:TimerTypeWorkKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        default:
            minutes = self.breakTimes[row];
            [self.breakInputHostView setDurationStr:[NSString stringWithFormat:@"%@ min", minutes]];
            
            seconds = minutes.integerValue * 60 + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:seconds forKey:TimerTypeBreakKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
    }
}



@end
