//
//  EXPAPIClient.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPAPIClient.h"

@implementation EXPAPIClient

static NSString * const AFAppDotNetAPIBaseURLString = @"http://exposuretechnologies.com/api/";

+ (instancetype)sharedClient {
    static EXPAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EXPAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        //_sharedClient.securityPolicy.allowInvalidCertificates = TRUE;
    });
    
    return _sharedClient;
}


@end
