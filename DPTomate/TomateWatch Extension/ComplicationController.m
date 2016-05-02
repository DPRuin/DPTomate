//
//  ComplicationController.m
//  DPTomate
//
//  Created by 土老帽 on 16/5/1.
//  Copyright © 2016年 DPRuin. All rights reserved.
//

#import "ComplicationController.h"
#import "DPConst.h"

@interface ComplicationController ()

@property (nonatomic, strong) NSDate *nextDate;

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    DPLog(@"getSupportedTimeTravelDirectionsForComplication");
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

/**
 *  时间线开始
 */
- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    DPLog(@"getTimelineStartDateForComplication");
    
    handler(nil);
}

/**
 *  时间线结束
 */
- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    DPLog(@"getTimelineEndDateForComplication");
    
    handler(nil);
}

/**
 *  锁屏的时候是否隐藏complication
 */
- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    DPLog(@"getPrivacyBehaviorForComplication");
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

/**
 *  获取当前的complication
 */
- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    DPLog(@"getCurrentTimelineEntryForComplication");
    // Call the handler with the current timeline entry
    
    double timeStamp = [[NSUserDefaults standardUserDefaults] doubleForKey:@"timeStamp"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    self.nextDate = date;
    
    CLKComplicationTimelineEntry *entry;
    
    switch (complication.family) {
        case CLKComplicationFamilyModularSmall: {
            // 模板
            CLKComplicationTemplateModularSmallSimpleText *template = [[CLKComplicationTemplateModularSmallSimpleText alloc] init];
            
            if (timeStamp < 1) {
                template.textProvider = [CLKSimpleTextProvider textProviderWithText:@"-:--"];
            } else {
                template.textProvider = [CLKRelativeDateTextProvider textProviderWithDate:date style:CLKRelativeDateStyleTimer units:NSCalendarUnitMinute];
            }
            
            entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
            
            break;
        }
            
        case CLKComplicationFamilyModularLarge: {
            
            CLKComplicationTemplateModularLargeTallBody *template = [[CLKComplicationTemplateModularLargeTallBody alloc] init];
            template.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:NSLocalizedString(@"Remaining", nil)];
            if (timeStamp < 1) {
                template.bodyTextProvider = [CLKSimpleTextProvider textProviderWithText:@"-:--"];
            } else {
                template.bodyTextProvider = [CLKRelativeDateTextProvider textProviderWithDate:date style:CLKRelativeDateStyleTimer units:NSCalendarUnitMinute | NSCalendarUnitSecond];
            }
            
            entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
            
            break;
        }
            
        case CLKComplicationFamilyCircularSmall: {
            
            // 模板
            CLKComplicationTemplateCircularSmallSimpleText *template = [[CLKComplicationTemplateCircularSmallSimpleText alloc] init];
            
            if (timeStamp < 1) {
                template.textProvider = [CLKSimpleTextProvider textProviderWithText:@"-:--"];
            } else {
                template.textProvider = [CLKRelativeDateTextProvider textProviderWithDate:date style:CLKRelativeDateStyleTimer units:NSCalendarUnitMinute];
            }
            
            entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
            
            break;
        }
            
        case CLKComplicationFamilyUtilitarianLarge: {
            
            CLKComplicationTemplateUtilitarianLargeFlat *template = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            if (timeStamp < 1) {
                template.textProvider = [CLKSimpleTextProvider textProviderWithText:@"-:--"];
            } else {
                template.textProvider = [CLKRelativeDateTextProvider textProviderWithDate:date style:CLKRelativeDateStyleTimer units:NSCalendarUnitMinute | NSCalendarUnitSecond];
            }
            
            entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
            
            break;
        }
            
        case CLKComplicationFamilyUtilitarianSmall: {
            
            // 模板
            CLKComplicationTemplateUtilitarianSmallFlat *template = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            
            if (timeStamp < 1) {
                template.textProvider = [CLKSimpleTextProvider textProviderWithText:@"-:--"];
            } else {
                template.textProvider = [CLKRelativeDateTextProvider textProviderWithDate:date style:CLKRelativeDateStyleTimer units:NSCalendarUnitMinute];
            }
            
            entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
            
            break;
        }
            
        default:
            entry = nil;
            break;
    }
    
    handler(entry);
}

/**
 *  获取limit时间点前的complication
 */
- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    DPLog(@"getTimelineEntriesForComplication");
    handler(nil);
}

/**
 *  获取limit时间点后的complication
 */
- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    DPLog(@"getTimelineEntriesForComplication");
    handler(nil);
}

#pragma mark Update Scheduling

/**
 *  多久时间更新时间线
 */
- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    DPLog(@"getNextRequestedUpdateDateWithHandler");
    handler(nil);
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached
    DPLog(@"getPlaceholderTemplateForComplication");
    
    CLKComplicationTemplate *template;
    
    switch (complication.family) {
        case CLKComplicationFamilyModularSmall: {
            
            CLKComplicationTemplateModularSmallRingText *modularSmallTemplate = [[CLKComplicationTemplateModularSmallRingText alloc] init];
            modularSmallTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:@"25"];
            modularSmallTemplate.fillFraction = 1.00;
            modularSmallTemplate.ringStyle = CLKComplicationRingStyleClosed;
            
            template = modularSmallTemplate;
            break;
        }
            
        case CLKComplicationFamilyModularLarge: {
            
            CLKComplicationTemplateModularLargeTallBody *modularLargeTemplate = [[CLKComplicationTemplateModularLargeTallBody alloc] init];
            modularLargeTemplate.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:NSLocalizedString(@"Remaining", nil)];
            modularLargeTemplate.bodyTextProvider = [CLKSimpleTextProvider textProviderWithText:@"25.00"];
            
            template = modularLargeTemplate;
            break;
        }
            
        case CLKComplicationFamilyCircularSmall: {
            CLKComplicationTemplateCircularSmallRingText *circularSmallTemplate = [[CLKComplicationTemplateCircularSmallRingText alloc] init];
            circularSmallTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:@"25"];
            circularSmallTemplate.fillFraction = 1.00;
            circularSmallTemplate.ringStyle = CLKComplicationRingStyleClosed;
            
            template = circularSmallTemplate;
            
            break;
        }
            
        case CLKComplicationFamilyUtilitarianLarge: {
            
            CLKComplicationTemplateUtilitarianLargeFlat *utilitarianLargeTemplate = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            utilitarianLargeTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:@"25:00"];
            template = utilitarianLargeTemplate;
            
            break;
        }
            
        case CLKComplicationFamilyUtilitarianSmall: {
            CLKComplicationTemplateUtilitarianSmallRingText *utilitaranSmallTemplate = [[CLKComplicationTemplateUtilitarianSmallRingText alloc] init];
            
            utilitaranSmallTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:@"25"];
            utilitaranSmallTemplate.fillFraction = 1.00;
            utilitaranSmallTemplate.ringStyle = CLKComplicationRingStyleClosed;
            template = utilitaranSmallTemplate;
            
            break;
        }
            
            
        default:
            break;
    }
    
    
    handler(template);
}

@end
