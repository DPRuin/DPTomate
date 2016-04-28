//
//  DPInputHostView.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/20.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPInputHostView.h"
#import "PureLayout.h"

@interface DPInputHostView ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *durationLabel;

@end

@implementation DPInputHostView

- (void)awakeFromNib
{
    UILabel *nameLabel = [self setupLabel];
    self.nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    UILabel *durationLabel = [self setupLabel];
    self.durationLabel = durationLabel;
    durationLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:durationLabel];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = DPBackgroundColor;
}

/**
 *  创建label
 */
- (UILabel *)setupLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = DPBlueColor;
    label.text = @"-";
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.nameLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 8, 0, 0) excludingEdge:ALEdgeRight];
    [self.durationLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 8) excludingEdge:ALEdgeLeft];
    
}

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    
    
    if (self.isSelected) {
        self.layer.borderWidth = 1;
    } else {
        self.layer.borderWidth = 0;
    }
}

/**
 *  更新label中文字
 *  @param name 名称
 *  @param durationStr 时间
 */
- (void)setName:(NSString *)name duration:(NSString *)durationStr
{
    self.nameLabel.text = name;
    self.durationLabel.text = durationStr;
    [self.nameLabel setNeedsDisplay];
    [self.durationLabel setNeedsDisplay];
}

/**
 *  更新label中文字
 *  @param durationStr 时间
 */
- (void)setDurationStr:(NSString *)durationStr
{
    self.durationLabel.text = durationStr;
    [self.durationLabel setNeedsDisplay];
}

/**
 *  重写set方法
 */
- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

@end
