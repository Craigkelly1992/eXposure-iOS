//
//  SubmissionList.h
//  exposure
//
//  Created by Binh Nguyen on 7/18/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface SubmissionList : Jastor

///
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSArray *submissions;

@end
