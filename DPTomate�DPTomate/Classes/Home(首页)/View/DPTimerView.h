//
//  DPTimerView.h
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum : NSUInteger {
    TimerTypeWork, // 工作
    TimerTypeBreak, // 休息
    TimerTypeProcrastination, // 拖延
    TimerTypeIdle // 无工作
    
} TimerType;

@interface DPTimerView : UIView

@property (nonatomic, strong) UIColor *timerColor;

- (void)setDuration:(CGFloat)duration maxValue:(CGFloat)maxValue;
@end
