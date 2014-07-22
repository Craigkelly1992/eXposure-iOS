//
//  Infrastructure.h
//  exposure
//
//  Created by Binh Nguyen on 7/22/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Infrastructure : NSObject

#pragma mark - Singleton
+ (Infrastructure *)sharedClient;
@property(nonatomic, strong) User *currentUser;

@end
