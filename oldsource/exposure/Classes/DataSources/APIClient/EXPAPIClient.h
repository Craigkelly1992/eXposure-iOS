//
//  EXPAPIClient.h
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

@interface EXPAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
