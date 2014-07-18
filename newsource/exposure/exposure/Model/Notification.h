//
//  Notification.h
//  exposure
//
//  Created by Binh Nguyen on 7/10/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"


@interface Notification : Jastor

@property (nonatomic, retain) NSString * notification_id;
@property (nonatomic, retain) NSString * notificationImage;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * type;

@end
