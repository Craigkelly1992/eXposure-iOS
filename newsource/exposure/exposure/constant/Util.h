//
//  Util.h
//  CobbAndCoach
//
//  Created by Binh Nguyen on 12/2/14.
//  Copyright (c) 2014 cloudsenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject {
}

+ (id)sharedUtil;
- (NSString*) convertToFriendlyDateTimeFormat:(NSString*)jobDateTime;
- (NSString*) convertToFriendlyDateTimeFormatFromDate:(NSDate*)jobDateTime;
- (NSString*) convertToDateFormat:(NSString*)jobDateTime;
- (NSString*) convertToTimeFormat:(NSString*)jobDateTime;
// convert friendly date time format to format @"yyyy'-'MM'-'dd'T'HH':'mm':'ss"
- (NSString*) convertToDateTimeFormatFromFriendly:(NSString*)friendlyTimeString;
- (NSString *)encodeToBase64String:(UIImage *)image;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (NSDate*) getCurrentDate;
- (NSString*) getCurrentDateString;
- (NSString*) getCurrentFriendlyDateString;
- (NSString*) getCurrentStartDateString;
- (NSString*) getCurrentEndDateString;
// 2015-01-01T11:52:00.000Z
- (NSString*) getCurrentSystemDateString;
- (NSDate*) parseFriendlyDateTimeFormat:(NSString*)jobDateTime;

@end
