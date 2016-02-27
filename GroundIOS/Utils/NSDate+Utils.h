//
//  NSDate+Utils.h
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 30..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Utils)
- (NSDate *)dateByAddingCalendarUnits:(NSCalendarUnit)calendarUnit amount:(NSInteger)amount;
+ (NSInteger)extractCalendarUnitsFromNSTimeInterval:(NSTimeInterval)timeInterval calendarUnit:(NSCalendarUnit)calendarUnit;
+ (NSString *)GeneralFormatDateFromNSTimeInterval:(NSTimeInterval)time format:(NSInteger)formatNumber;
+ (NSInteger)extractCalendarUnitsFromNSDate:(NSDate *)date calendarUnit:(NSCalendarUnit)calendarUnit;
+ (NSString *)getWeekdayFromNSTimeInterval:(NSTimeInterval)time;
+ (NSDate *)setDateTimeWithDate:(NSDate *)date setHour:(NSInteger)hour setMinute:(NSInteger)minute;

- (NSInteger)getCalendarUnitsFromNSTimeInterval:(NSTimeInterval)timeInterval calendarUnit:(NSCalendarUnit)calendarUnit;
- (NSString *)getDateFromNSTimeInterval:(NSTimeInterval)time format:(NSInteger)formatNumber;

@end
