//
//  DPFocusViewController.h
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPTimerView.h"

@class DPButton;

@interface DPFocusViewController : UIViewController
/**
 *  开始休息
 */
- (IBAction)startBreak:(DPButton *)sender;

/**
 *  开始工作
 */
- (IBAction)startWork:(DPButton *)sender;

/**
 *  开时倒计时
 */
- (void)startTimerWithType:(TimerType)type;
@end
