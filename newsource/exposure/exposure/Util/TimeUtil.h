//
//  Util.h
//  CobbAndCoach
//
//  Created by Binh Nguyen on 12/2/14.
//  Copyright (c) 2014 cloudsenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TimeUtil : NSObject {
}

+ (id)sharedUtil;
- (NSDate*) convertToDateZFormat:(NSString*)dateTime;
- (NSString *)encodeToBase64String:(UIImage *)image;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (NSDate*) getCurrentDate;
- (NSString *)elapsedTimeSince:(NSDate *)date;

@end
