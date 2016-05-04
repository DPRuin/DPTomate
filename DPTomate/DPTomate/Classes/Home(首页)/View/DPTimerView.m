//
//  DPTimerView.m
//  DPTomate
//
//  Created by 土老帽 on 16/4/11.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "DPTimerView.h"
#import "PureLayout.h"
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
    self.backgroundColor = [UIColor blueColor];
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
    self.backgroundColor = [UIColor clearColor];
    
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
    
    // 判断设备是iphone还是ipad
    UIFont *font;
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPhone:
            
            font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:80];
            break;
        case UIUserInterfaceIdiomPad:
            font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:140];
            break;
        default:
            font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:80];
            break;
    }
    
    timeLabel.font = font;
    
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = self.timerColor;
}

- (void)drawRect:(CGRect)rect {
    
    // 判断设备是iphone or ipad
    CGFloat radiusEdge; // 圆环半径边缘间距
    CGFloat minuteLineWidth; // 分针宽度
    CGFloat secondsLineWidth; // 秒针宽度
    CGFloat ringLineWidth;
    CGFloat pathW;
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPhone: {
            radiusEdge = 10.0;
            minuteLineWidth  = 3.0;
            secondsLineWidth = 1.0;
            ringLineWidth = 1.0;
            pathW = 4.0;
            break;
        }
            
        case UIUserInterfaceIdiomPad: {
            radiusEdge = 20.0;
            minuteLineWidth  = 6.0;
            secondsLineWidth = 1.0;
            ringLineWidth = 1.0;
            pathW = 8.0;
            break;
        }
            
        default: {
            radiusEdge = 10.0;
            minuteLineWidth  = 3.0;
            secondsLineWidth = 1.0;
            ringLineWidth = 1.0;
            pathW = 4.0;
            break;
        }
    }
    
    CGPoint timerCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = rect.size.width / 2 - radiusEdge;
    CGFloat startAngle = M_PI_2 * 3;
    
    // 画分钟
    CGFloat percentage;
    NSInteger dummyInt;
    if (!self.isShowRemaining) {
        dummyInt = (NSInteger)(100000.0*(1 - (self.durationInSeconds - 1) / self.maxValue));
    } else {
        dummyInt = (NSInteger)(100000.0*(self.durationInSeconds - 1) / self.maxValue);
    }
    
    percentage = dummyInt / 100000.0;
    
    UIBezierPath *timerRingPath = [UIBezierPath bezierPathWithArcCenter:timerCenter radius:radius startAngle:startAngle endAngle:startAngle - 0.001 clockwise:YES];
    
    self.timerShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.timerShapeLayer.strokeColor = self.timerColor.CGColor;
    self.timerShapeLayer.lineWidth = minuteLineWidth;
    self.timerShapeLayer.strokeEnd = percentage;
    self.timerShapeLayer.path = timerRingPath.CGPath;
    
    CGFloat totalMinutes = (self.maxValue - 1) / 60;
    CGFloat dashLength = 2 * radius * M_PI / totalMinutes;
    self.timerShapeLayer.lineDashPattern = @[@(dashLength - 2), @(2)];
    
    // 画秒
    CGFloat secondsPercentage;
    if (self.isShowRemaining) {
        dummyInt = (NSInteger)(100000 * (self.durationInSeconds - 1)) % (60 * 100000);
    } else {
        dummyInt = (60 * 100000 - (NSInteger)( 100000 * (self.durationInSeconds - 1))) % (60*100000);
    }
    
    secondsPercentage = (CGFloat)dummyInt / 100000.0;
    
    DPLog(@"-secondsPercentage-%f-dumint-%ld", secondsPercentage, dummyInt);
    
    UIBezierPath *secondsRingPath = [UIBezierPath bezierPathWithArcCenter:timerCenter radius:radius - pathW startAngle:startAngle endAngle:startAngle - 0.001 clockwise:YES];
    self.secondsShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.secondsShapeLayer.strokeColor = self.timerColor.CGColor;
    self.secondsShapeLayer.lineWidth = secondsLineWidth;
    self.secondsShapeLayer.strokeEnd = secondsPercentage / 60.0;
    self.secondsShapeLayer.path = secondsRingPath.CGPath;
    
    // 画外圆
    [self.timerColor set];
    UIBezierPath *fullRingPath = [UIBezierPath bezierPathWithArcCenter:timerCenter radius:radius + pathW startAngle:startAngle endAngle:startAngle - 0.001 clockwise:YES];
    fullRingPath.lineWidth = ringLineWidth;
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

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.showRemaining = !self.isShowRemaining;
//    [self setNeedsDisplay];
//}

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
