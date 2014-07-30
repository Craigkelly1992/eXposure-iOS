//
//  EXPContestsViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPContestsViewController : EXPBaseViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

// Outlets
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarContest;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOption;
@property (strong, nonatomic) IBOutlet UITableView *tableViewContest;
// Actions
- (IBAction)segmentValueChanged:(id)sender;
@end
