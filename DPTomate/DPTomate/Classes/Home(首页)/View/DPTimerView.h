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

/**
 *  设置持续时间
 *  @Param duration 剩余时间 秒
 *  @Param maxValue 总的时间 秒
 */
- (void)setDuration:(CGFloat)duration maxValue:(CGFloat)maxValue;

/**
 *  设置timeLabel字体大小
 */
- (void)setTimeLabelFont:(UIFont *)font;
@end
