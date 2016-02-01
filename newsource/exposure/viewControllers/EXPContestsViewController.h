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
@property (strong, nonatomic) IBOutlet UIView *segmentOptionContainer;
@property (strong, nonatomic) IBOutlet UITableView *tableViewContest;
@property (strong, nonatomic) IBOutlet UILabel *labelNoItem;
@property (strong, nonatomic) IBOutlet UIView *viewBelow;

@end
