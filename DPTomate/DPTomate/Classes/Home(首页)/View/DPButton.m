//
//  DPButton.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPButton.h"

@implementation DPButton

- (void)awakeFromNib
{
    [self setTitleColor:DPOrangeColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)drawRect:(CGRect)rect {
    CGFloat cornerRadius;
    
    // 判断设备是iPhone or iPad
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPhone:
            cornerRadius = 35;
            break;
        case UIUserInterfaceIdiomPad:
            cornerRadius = 60;
            break;
        default:
            cornerRadius = 35;
            break;
    }
    
    self.layer.cornerRadius = cornerRadius;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = DPOrangeColor.CGColor;
    
}

@end
