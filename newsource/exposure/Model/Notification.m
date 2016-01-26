//
//  Notification.m
//  exposure
//
//  Created by Binh Nguyen on 7/10/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "Notification.h"


@implementation Notification

- (NSDictionary *)map{
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithDictionary:[super map]];
    [map setObject:@"id" forKey:@"notificationId"];
    return [NSDictionary dictionaryWithDictionary:map];
}


@end
