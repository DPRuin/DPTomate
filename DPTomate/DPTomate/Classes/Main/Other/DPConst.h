
#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DPLog(...) NSLog(__VA_ARGS__)
#else
#define DPLog(...)
#endif

#define DPColor(r, g, b, f) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(f)]
#define DPRGBColor(r, g, b) DPColor((r), (g), (b), 1.0)
