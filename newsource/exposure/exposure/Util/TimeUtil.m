//
//  Util.m
//  CobbAndCoach
//
//  Created by Binh Nguyen on 12/2/14.
//  Copyright (c) 2014 cloudsenk. All rights reserved.
//

#import "TimeUtil.h"
#import <UIKit/UIKit.h>

@implementation TimeUtil {

    NSDateFormatter *dateTimeZFormatter;
}

#pragma mark Singleton Methods

+ (id)sharedUtil {
    static TimeUtil *sharedUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtil = [[self alloc] init];
    });
    return sharedUtil;
}

- (id)init {
    if (self = [super init]) {
        
        // parse 2015-01-08T15:36:37.000Z -> date
        dateTimeZFormatter = [[NSDateFormatter alloc] init];
        [dateTimeZFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateTimeZFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateTimeZFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

// jobDateTime in format @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'" -> date
- (NSDate*) convertToDateZFormat:(NSString*)dateTime {
    return [dateTimeZFormatter dateFromString:dateTime];
}

// encode
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

// decode
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

// get local date time
- (NSDate*) getCurrentDate {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return destinationDate;
}

/*
 *  params      :   date (NSDate)
 *  returns     :   elapsed Value (NSString)
 */

- (NSString *)elapsedTimeSince:(NSDate *)date {
    if (!date) {
        NSLog(@"Can't find elapsed time since now");
        return @"";
    }
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    NSAssert(timeInterval<0, @"Please provide past date for elapsed time");
    
    timeInterval = abs(timeInterval);
    
    double seconds = 60;
    double minutes = 60;
    double hours = 24;
    
    int noOfSeconds = fmod(timeInterval, seconds);
    int noOfMinutes = timeInterval/seconds;
    
    if (noOfMinutes == 0) {
        return [NSString stringWithFormat:@"%d seconds ago", (int)noOfSeconds];
    } else if (noOfMinutes > 0) {
        int noOfHours = noOfMinutes/minutes;
        if (noOfHours == 0) {
            return [NSString stringWithFormat:@"%d %@ ago", (int)noOfMinutes, (int)noOfMinutes == 1? @"Minute":@"Minutes"];
        } else {
            
            int noOfDays = noOfHours/hours;
            if (noOfDays == 0) {
                return [NSString stringWithFormat:@"%d %@ ago", (int)noOfHours, (int)noOfHours == 1? @"Hour":@"Hours"];
            } else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMM d, y"];
                return [dateFormatter stringFromDate:date];
            }
        }
    }
    return @"";
}

@end
