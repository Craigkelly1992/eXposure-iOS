//
//  Infrastructure.h
//  exposure
//
//  Created by Binh Nguyen on 7/22/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define USERDEFAULT_KEY_EMAIL @"userdefault_key_email"
#define USERDEFAULT_KEY_TOKEN @"userdefault_key_token"
#define USERDEFAULT_KEY_PASSWORD @"userdefault_key_password"
//
#define USERDEFAULT_KEY_INSTAGRAM_TOKEN @"userdefault_key_instagram_accesstoken"
//
#define kTabBarHeight 50

@interface Infrastructure : NSObject

#pragma mark - Singleton
+ (Infrastructure *)sharedClient;
@property(nonatomic, strong) User *currentUser;
@property(nonatomic, strong) NSString *deviceToken;
@property(nonatomic, strong) NSNumber *contestId;
@property(nonatomic, strong) NSNumber *notificationId;
@property(nonatomic, strong) NSString *facebookId;
@property(nonatomic, strong) NSString *instagramId;
@property(nonatomic, strong) NSString *twitterId;


@end
