//
//  Infrastructure.m
//  exposure
//
//  Created by Binh Nguyen on 7/22/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "Infrastructure.h"

@implementation Infrastructure

+ (Infrastructure *)sharedClient {
    static Infrastructure *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Infrastructure alloc] init];
    });
    return _sharedClient;
}


@end
