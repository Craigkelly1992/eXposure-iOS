//
//  EXPRankingsViewController.h
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface EXPRankingsViewController : UIViewController<UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
