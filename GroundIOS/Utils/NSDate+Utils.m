//
//  NSDate+Utils.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 13. 7. 30..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate(Utils)
- (NSDate *)dateByAddingCalendarUnits:(NSCalendarUnit)calendarUnit amount:(NSInteger)amount
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *newDate;
    
    switch (calendarUnit) {
        case NSHourCalendarUnit:{
            [components setHour:amount];
            break;
        }
        case NSDayCalendarUnit:{
            [components setDay:amount];
            break;
        }
        case NSWeekCalendarUnit:{
            [components setWeek:amount];
            break;
        }
        case NSMonthCalendarUnit:{
            [components setMonth:amount];
            break;
        }
        default:
            NSLog(@"addCanlendar does not support that calendarUnit");
            break;
    }
    newDate = [gregorian dateByAddingComponents:components toDate:self options:0];
    return newDate;
}

+ (NSInteger)extractCalendarUnitsFromNSTimeInterval:(NSTimeInterval)timeInterval calendarUnit:(NSCalendarUnit)calendarUnit
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    NSDateComponents *breakDown = [sysCalendar components:calendarUnit fromDate:date];
    NSInteger value;
    
    switch (calendarUnit) {
        case NSMinuteCalendarUnit:
        {
            value = [breakDown minute];
            break;
        }
        case NSHourCalendarUnit:
        {
            value = [breakDown hour];
            break;
        }
        case NSDayCalendarUnit:
        {
            value = [breakDown day];
            break;
        }
        case NSWeekdayCalendarUnit:
        {
            value = [breakDown weekday];
            break;
        }
        case NSMonthCalendarUnit:
        {
            value = [breakDown month];
            break;
        }
        case NSYearCalendarUnit:
        {
            value = [breakDown year];
            break;
        }
            
        default:
            NSLog(@"TimeInterval Convert Error");
            value = 0;
            break;
    }
    return value;
}

+ (NSString *)GeneralFormatDateFromNSTimeInterval:(NSTimeInterval)time format:(NSInteger)formatNumber
{
    
    NSInteger year = [self extractCalendarUnitsFromNSTimeInterval:time calendarUnit:NSYearCalendarUnit];
    NSInteger month = [self extractCalendarUnitsFromNSTimeInterval:time calendarUnit:NSMonthCalendarUnit];
    NSInteger day = [self extractCalendarUnitsFromNSTimeInterval:time calendarUnit:NSDayCalendarUnit];
    NSInteger hour = [self extractCalendarUnitsFromNSTimeInterval:time calendarUnit:NSHourCalendarUnit];
    NSInteger minute = [self extractCalendarUnitsFromNSTimeInterval:time calendarUnit:NSMinuteCalendarUnit];
    
    NSInteger hour_hh;
    NSString *ampm;
    
    if(hour >= 12){
        ampm = @"PM";
    }else ampm = @"AM";
    
    if((int)(hour/12) == 1){
        hour_hh = hour - 12;
    }else hour_hh = hour;
    
    NSInteger roundOffMin = (int)(lroundf(minute/10)*10);
    NSInteger roundOffHour = hour;
    if (roundOffMin == 60) {
        roundOffMin = 0;
        roundOffHour++;
    }
    
    NSString *generalFormatDate;
    
    switch (formatNumber) {
        case 1:{
            generalFormatDate = [NSString stringWithFormat:@"%d년 %d월 %d일", year, month, day];
            break;
        }
        case 2:{
            generalFormatDate = [NSString stringWithFormat:@"%d-%d-%d", year, month, day];
            break;
        }
        case 3:{
            generalFormatDate = [NSString stringWithFormat:@"%d년%d월%d일 %d시%d분", year, month, day, hour, minute];
            break;
        }
        case 4:{
            generalFormatDate = [NSString stringWithFormat:@"%d시%d분", hour, minute];
            break;
        }
        case 5:{
            generalFormatDate = [NSString stringWithFormat:@"%d.%d.%d %d", year, month, day, hour];
            break;
        }
        case 6:{
            generalFormatDate = [NSString stringWithFormat:@"%02d.%02d", month, day];
            break;
        }
        case 7:{
            generalFormatDate = [NSString stringWithFormat:@"%d.%d. %d시", month, day, hour];
            break;
        }
        case 8:{
            generalFormatDate = [NSString stringWithFormat:@"%d시", hour];
            break;
        }
        case 9:{
            generalFormatDate = [NSString stringWithFormat:@"%d월%d일 %d시%d분", month, day, roundOffHour, roundOffMin];
            break;
        }
        case 10:{
            generalFormatDate = [NSString stringWithFormat:@"%02d:%02d", roundOffHour, roundOffMin];
            break;
        }
        case 11:{
            generalFormatDate = [NSString stringWithFormat:@"%d.%02d.%02d", year, month, day];
            break;
        }
        case 12:{
            generalFormatDate = [NSString stringWithFormat:@"%@ %02d:%02d", ampm, hour_hh, minute];
            break;
        }
        case 13:{
            NSString *dateUnit;
            NSInteger date;
            NSTimeInterval timeDiff = ([[NSDate date] timeIntervalSince1970] - time);
            if (timeDiff/31536000 >= 1) {
                date = (int)timeDiff/31536000;
                dateUnit = @"년";
            }else if (timeDiff/2592000 >= 1) {
                date = (int)timeDiff/2592000;
                dateUnit = @"월";

            }else if (timeDiff/86400 >= 1) {
                date = (int)timeDiff/86400;
                dateUnit = @"일";
            }else if (timeDiff/3600 >= 1) {
                date = (int)timeDiff/3600;
                dateUnit = @"시간";
            }else{
                date = timeDiff/60;
                dateUnit = @"분";
            }
            generalFormatDate = [NSString stringWithFormat:@"%d%@ 전", date, dateUnit];
            break;
        }default:
            generalFormatDate = nil;
            NSLog(@"TimeInterval Convert to String Error");
            break;
    }
    return generalFormatDate;
}

- (NSInteger)getCalendarUnitsFromNSTimeInterval:(NSTimeInterval)timeInterval calendarUnit:(NSCalendarUnit)calendarUnit
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
    NSDateComponents *breakDown = [sysCalendar components:calendarUnit fromDate:date];
    NSInteger value;
    
    switch (calendarUnit) {
        case NSMinuteCalendarUnit:
        {
            value = [breakDown minute];
            break;
        }
        case NSHourCalendarUnit:
        {
            value = [breakDown hour];
            break;
        }
        case NSDayCalendarUnit:
        {
            value = [breakDown day];
            break;
        }
        case NSWeekdayCalendarUnit:
        {
            value = [breakDown weekday];
            break;
        }
        case NSMonthCalendarUnit:
        {
            value = [breakDown month];
            break;
        }
        case NSYearCalendarUnit:
        {
            value = [breakDown year];
            break;
        }
        default:
            NSLog(@"TimeInterval Convert Error");
            value = 0;
            break;
    }
    return value;
}

- (NSString *)getDateFromNSTimeInterval:(NSTimeInterval)time format:(NSInteger)formatNumber
{
    NSInteger year = [self getCalendarUnitsFromNSTimeInterval:time calendarUnit:NSYearCalendarUnit];
    NSInteger month = [self getCalendarUnitsFromNSTimeInterval:time calendarUnit:NSMonthCalendarUnit];
    NSInteger day = [self getCalendarUnitsFromNSTimeInterval:time calendarUnit:NSDayCalendarUnit];
    NSInteger hour = [self getCalendarUnitsFromNSTimeInterval:time calendarUnit:NSHourCalendarUnit];
    NSInteger minute = [self getCalendarUnitsFromNSTimeInterval:time calendarUnit:NSMinuteCalendarUnit];
    NSString *generalFormatDate;
    
    switch (formatNumber) {
        case 1:{
            generalFormatDate = [NSString stringWithFormat:@"%d년 %d월 %d일", year, month, day];
            break;
        }
        case 2:{
            generalFormatDate = [NSString stringWithFormat:@"%d-%d-%d", year, month, day];
            break;
        }
        case 3:{
            generalFormatDate = [NSString stringWithFormat:@"%d년%d월%d일 %d시%d분", year, month, day, hour, minute];
            break;
        }
        case 4:{
            generalFormatDate = [NSString stringWithFormat:@"%d시%d분", hour, minute];
            break;
        }
        case 5:{
            generalFormatDate = [NSString stringWithFormat:@"%d.%d.%d %d", year, month, day, hour];
            break;
        }
        case 6:{
            generalFormatDate = [NSString stringWithFormat:@"%d.%d", month, day];
            break;
        }
        case 7:{
            generalFormatDate = [NSString stringWithFormat:@"%d.%d. %d시", month, day, hour];
            break;
        }
        case 8:{
            generalFormatDate = [NSString stringWithFormat:@"%d시", hour];
            break;
        }
        case 9:{
            generalFormatDate = [NSString stringWithFormat:@"%d월%d일 %d시%d분", month, day, hour, minute];
            break;
        }
        case 10:{
            generalFormatDate = [NSString stringWithFormat:@"%d:%d", hour, minute];
            break;
        }
        default:
            generalFormatDate = nil;
            NSLog(@"TimeInterval Convert to String Error");
            break;
    }
    return generalFormatDate;
}

+ (NSInteger)extractCalendarUnitsFromNSDate:(NSDate *)date calendarUnit:(NSCalendarUnit)calendarUnit
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents *breakDown = [sysCalendar components:calendarUnit fromDate:date];
    NSInteger value;
    
    switch (calendarUnit) {
        case NSMinuteCalendarUnit:
        {
            value = [breakDown minute];
            break;
        }
        case NSHourCalendarUnit:
        {
            value = [breakDown hour];
            break;
        }
        case NSDayCalendarUnit:
        {
            value = [breakDown day];
            break;
        }
        case NSMonthCalendarUnit:
        {
            value = [breakDown month];
            break;
        }
        case NSYearCalendarUnit:
        {
            value = [breakDown year];
            break;
        }
        default:
            NSLog(@"NSDate Extract Error");
            value = 0;
            break;
    }
    return value;
}

+ (NSString *)getWeekdayFromNSTimeInterval:(NSTimeInterval)time
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateComponents *breakDown = [sysCalendar components:NSWeekdayCalendarUnit fromDate:date];
    NSArray *weekday = [[NSArray alloc] initWithObjects:@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", nil];
    return [weekday objectAtIndex:([breakDown weekday]-1)];
}

+ (NSDate *)setDateTimeWithDate:(NSDate *)date setHour:(NSInteger)hour setMinute:(NSInteger)minute
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    [components setHour:hour];
    [components setMinute:minute];
    
    return [calendar dateFromComponents:components];
}

@end
