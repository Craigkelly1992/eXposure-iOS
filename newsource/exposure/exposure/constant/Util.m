//
//  Util.m
//  CobbAndCoach
//
//  Created by Binh Nguyen on 12/2/14.
//  Copyright (c) 2014 cloudsenk. All rights reserved.
//

#import "Util.h"
#import <UIKit/UIKit.h>

@implementation Util {
    NSDateFormatter *startDateTimeFormatter;
    NSDateFormatter *endDateTimeFormatter;
    NSDateFormatter *dateTimeFormatter;
    NSDateFormatter *friendlyDateTimeFormatter;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *timeFormatter;
}

#pragma mark Singleton Methods

+ (id)sharedUtil {
    static Util *sharedUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUtil = [[self alloc] init];
    });
    return sharedUtil;
}

- (id)init {
    if (self = [super init]) {
        // parse 2011-01-21T12:26:47 -> date
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        [dateTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateTimeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateTimeFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
        
        // parse 2011/01/21,12:26:47 -> friendly date time
        friendlyDateTimeFormatter = [[NSDateFormatter alloc] init];
        [friendlyDateTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [friendlyDateTimeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [friendlyDateTimeFormatter setDateFormat:@"dd'/'MM'/'yyyy'-'HH':'mm"];
        
        // parse 2011-01-21T00:00:00
        startDateTimeFormatter = [[NSDateFormatter alloc] init];
        [startDateTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [startDateTimeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [startDateTimeFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'00':'00':'00"];
        
        // parse 2011-01-21T23:59:59
        endDateTimeFormatter = [[NSDateFormatter alloc] init];
        [endDateTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [endDateTimeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [endDateTimeFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'23':'59':'59"];
        
        // date -> Wed 18 Nov 2014
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"E d MMM yyyy"];
        
        // time -> 2:00pm
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [timeFormatter setDateFormat:@"hh:mma"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

// jobDateTime in format @"yyyy'-'MM'-'dd'T'HH':'mm':'ss"
- (NSString*) convertToDateFormat:(NSString*)jobDateTime {
    NSDate *dateTime = [dateTimeFormatter dateFromString:jobDateTime];
    NSDate *currentDate = [[NSDate alloc] init];
    NSString *jobDateString = [dateFormatter stringFromDate:dateTime];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *date;
    if ([jobDateString isEqualToString:currentDateString]) {
        date = @"Today";
    } else {
        date = jobDateString;
    }
    return date;
}

// convert friendly date time format to format @"yyyy'-'MM'-'dd'T'HH':'mm':'ss"
- (NSString*) convertToDateTimeFormatFromFriendly:(NSString*)friendlyTimeString {
    NSDate *dateTime = [friendlyDateTimeFormatter dateFromString:friendlyTimeString];
    NSString *dateString = [dateTimeFormatter stringFromDate:dateTime];

    return dateString;
}

// jobDateTime in format @"yyyy'-'MM'-'dd'T'HH':'mm':'ss"
- (NSString*) convertToTimeFormat:(NSString*)jobDateTime {
    NSDate *dateTime = [dateTimeFormatter dateFromString:jobDateTime];
    NSString *time = [timeFormatter stringFromDate:dateTime];
    return time;
}

// jobDateTime in format @"yyyy'-'MM'-'dd'T'HH':'mm':'ss"
- (NSString*) convertToFriendlyDateTimeFormat:(NSString*)jobDateTime {
    NSDate *dateTime = [dateTimeFormatter dateFromString:jobDateTime];
    NSString *friendlyTime = [friendlyDateTimeFormatter stringFromDate:dateTime];
    return friendlyTime;
}


- (NSString*) convertToFriendlyDateTimeFormatFromDate:(NSDate*)jobDateTime {
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:jobDateTime];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:jobDateTime];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:jobDateTime];
    
    // convert to new format
    NSString *datetime = [friendlyDateTimeFormatter stringFromDate:destinationDate];

    return datetime;
}

- (NSDate*) parseFriendlyDateTimeFormat:(NSString*)jobDateTime {
    NSDate *dateTime = [friendlyDateTimeFormatter dateFromString:jobDateTime];
    
    return dateTime;
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

// get local date time string
- (NSString*) getCurrentDateString {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    // convert to new format
    NSString *datetime = [dateTimeFormatter stringFromDate:destinationDate];
    
    return datetime;
}

- (NSString*) getCurrentFriendlyDateString {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    // convert to new format
    NSString *datetime = [friendlyDateTimeFormatter stringFromDate:destinationDate];
    
    return datetime;
}

// get local date time string with start date, begin with 00:00:00
- (NSString*) getCurrentStartDateString {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    // convert to new format
    NSString *datetime = [startDateTimeFormatter stringFromDate:destinationDate];
    
    return datetime;
}

// get local date time string with end date, begin with 23:59:59
- (NSString*) getCurrentEndDateString {
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    // convert to new format
    NSString *datetime = [endDateTimeFormatter stringFromDate:destinationDate];
    
    return datetime;
}

@end
