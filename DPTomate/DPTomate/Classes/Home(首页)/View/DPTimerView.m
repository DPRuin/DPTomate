//
//  DPTimerView.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPTimerView.h"
#import "UIView+AutoLayout.h"
#import "DPConst.h"

@interface DPTimerView ()

@property (nonatomic, assign) CGFloat durationInSeconds; // CGFloat
@property (nonatomic, assign) CGFloat maxValue; // CGFloat

@property (nonatomic, getter=isShowRemaining) BOOL showRemaining;

/** 时间图层 */
@property (nonatomic, weak) CAShapeLayer *timerShapeLayer;
/** 秒图层 */
@property (nonatomic, weak) CAShapeLayer *secondsShapeLayer;
/** 时间label */
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation DPTimerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupTimerView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setupTimerView];
}

/**
 *  初始化timerView
 */
- (void)setupTimerView
{
    self.durationInSeconds = 0;
    self.maxValue = 60;
    self.showRemaining = YES;
    self.timerColor = DPBlueColor;
    
    // 时间图层
    CAShapeLayer *timerShapeLayer = [[CAShapeLayer alloc] init];
    self.timerShapeLayer = timerShapeLayer;
    [self.layer addSublayer:timerShapeLayer];
    
    // 秒图层
    CAShapeLayer *secondsShapeLayer = [[CAShapeLayer alloc] init];
    self.secondsShapeLayer = secondsShapeLayer;
    [self.layer addSublayer:secondsShapeLayer];
    
    // 时间label
    UILabel *timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:80];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = self.timerColor;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint timerCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = rect.size.width / 2 - 10;
    CGFloat startAngle = M_PI_2 * 3;
    
    // 画分钟
    CGFloat percentage;
    int dummyInt;
    if (!self.isShowRemaining) {
        dummyInt = (int)(100000.0*(1 - (self.durationInSeconds - 1) / self.maxValue));
    } else {
        dummyInt = (int)(100000.0*(self.durationInSeconds - 1) / self.maxValue);
    }
    
    percentage = dummyInt / 100000.0;
    
    UIBezierPath *timerRingPath = [UIBezierPath bezierPathWithArcCenter:timerCenter radius:radius startAngle:startAngle endAngle:startAngle - 0.001 clockwise:YES];
    
    self.timerShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.timerShapeLayer.strokeColor = self.timerColor.CGColor;
    self.timerShapeLayer.lineWidth = 3;
    self.timerShapeLayer.strokeEnd = percentage;
    self.timerShapeLayer.path = timerRingPath.CGPath;
    
    CGFloat totalMinutes = (self.maxValue - 1) / 60;
    CGFloat dashLength = 2 * radius * M_PI / totalMinutes;
    self.timerShapeLayer.lineDashPattern = @[@(dashLength - 2), @(2)];
    
    // 画秒
    CGFloat secondsPercentage;
    if (self.isShowRemaining) {
        secondsPercentage = ((int)self.durationInSeconds - 1) % 60;
    } else {
        secondsPercentage = 60 - ((int)self.durationInSeconds - 1) % 60;
    }
    
    UIBezierPath *secondsRingPath = [UIBezierPath bezierPathWithArcCenter:timerCenter radius:radius - 4 startAngle:startAngle endAngle:startAngle - 0.001 clockwise:YES];
    self.secondsShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.secondsShapeLayer.strokeColor = self.timerColor.CGColor;
    self.secondsShapeLayer.lineWidth = 1.0;
    self.secondsShapeLayer.strokeEnd = secondsPercentage / 60.0;
    self.secondsShapeLayer.path = secondsRingPath.CGPath;
    
    // 画外圆
    [self.timerColor set];
    UIBezierPath *fullRingPath = [UIBezierPath bezierPathWithArcCenter:timerCenter radius:radius + 4 startAngle:startAngle endAngle:startAngle - 0.001 clockwise:YES];
    fullRingPath.lineWidth = 1.0;
    [fullRingPath stroke];
    
    // 时间label
    if (!self.isShowRemaining) {
        self.durationInSeconds = self.maxValue - self.durationInSeconds;
    }
    
    int seconds = (int)self.durationInSeconds % 60;
    int minutes = (int)self.durationInSeconds / 60;
    NSString *labeText = [NSString stringWithFormat:@"%02d : %02d", minutes, seconds];
    self.timeLabel.text = labeText;
    [self.timeLabel setNeedsLayout];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.showRemaining = !self.isShowRemaining;
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.timeLabel autoCenterInSuperview];
    
}

/**
 *  设置持续时间
 *  @Param duration 剩余时间 秒
 *  @Param maxValue 总的时间 秒
 */
- (void)setDuration:(CGFloat)duration maxValue:(CGFloat)maxValue
{
    self.durationInSeconds = duration;
    self.maxValue = maxValue;
    [self setNeedsDisplay];
}

/**
 *  设置timeLabel字体大小
 */
- (void)setTimeLabelFont:(UIFont *)font
{
    self.timeLabel.font = font;
    [self.timeLabel setNeedsDisplay];
}

@end
