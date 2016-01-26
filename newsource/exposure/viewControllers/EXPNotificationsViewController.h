//
//  EXPNotificationsViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPNotificationsViewController : EXPBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViewNotification;

@end
