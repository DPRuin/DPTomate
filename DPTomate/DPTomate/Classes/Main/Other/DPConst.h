
#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DPLog(...) NSLog(__VA_ARGS__)
#else
#define DPLog(...)
#endif

#define DPColor(r, g, b, f) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(f)]
#define DPRGBColor(r, g, b) DPColor((r), (g), (b), 1.0)

extern NSString *const TimerTypeWorkKey;
extern NSString *const TimerTypeBreakKey;
extern NSString *const TimerTypeProcrastinationKey;

extern NSString *const LocalNotificationCategoryIdentifier;
extern NSString *const UserNotificationBreakActionIdentifier;
extern NSString *const UserNotificationWorkActionIdentifier;

#define DPOrangeColor DPRGBColor(231, 145, 100)  // 按钮颜色 导航栏字体颜色
#define DPBackgroundColor DPRGBColor(194, 218, 201)  // 背景颜色 导航栏背景色
#define DPTimerColor DPRGBColor(111, 193, 248)  // 未用
#define DPBlueColor DPRGBColor(255, 110, 78)  // 圆环颜色 设置界面字体颜色