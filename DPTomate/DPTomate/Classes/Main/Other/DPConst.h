
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

#define DPOrangeColor DPRGBColor(212, 167, 42)
#define DPBackgroundColor DPRGBColor(41, 42, 55)
#define DPTimerColor DPRGBColor(111, 193, 248)
#define DPBlueColor DPRGBColor(63, 117, 255)