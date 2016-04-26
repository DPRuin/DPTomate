//
//  DPInputHostView.h
//  DPTomate
//
//  Created by 土老帽 on 16/4/20.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPInputHostView : UIView

- (void)setName:(NSString *)name duration:(NSString *)durationStr;
- (void)setDurationStr:(NSString *)durationStr;

@property (nonatomic, getter=isSelected) BOOL selected;
@end
