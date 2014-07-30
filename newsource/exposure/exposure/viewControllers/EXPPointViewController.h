//
//  EXPPointViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPPointViewController : EXPBaseViewController <UITableViewDataSource, UITableViewDelegate>

//
@property (strong, nonatomic) NSNumber *userId;
//
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOption;
@property (strong, nonatomic) IBOutlet UITableView *tableViewUser;
// Actions
- (IBAction)segmentValueChanged:(id)sender;
@end
