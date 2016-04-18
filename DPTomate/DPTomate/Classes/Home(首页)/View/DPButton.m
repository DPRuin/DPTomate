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
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22];
}

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 40;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    
}

@end
