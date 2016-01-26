//
//  SubmissionContest.h
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"
#import "Contest.h"

@interface SubmissionContest : Jastor

@property (nonatomic, copy) NSString *status;
@property (nonatomic, retain) Contest *info;

@end
