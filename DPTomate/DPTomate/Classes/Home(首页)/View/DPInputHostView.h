//
//  DPInputHostView.h
//  DPTomate
//
//  Created by 土老帽 on 16/4/20.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPInputHostView : UIView

/** 是否选中 */
@property (nonatomic, getter=isSelected) BOOL selected;


/**
 *  更新label中文字
 *  @param name 名称
 *  @param durationStr 时间
 */
- (void)setName:(NSString *)name duration:(NSString *)durationStr;

/**
 *  更新label中文字
 *  @param durationStr 时间
 */
- (void)setDurationStr:(NSString *)durationStr;

@end
