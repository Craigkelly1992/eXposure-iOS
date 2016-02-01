//
//  PointTableViewCell.h
//  exposure
//
//  Created by Binh Nguyen on 7/30/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PointTableViewCell : UITableViewCell

//
@property (nonatomic) int order;
@property (strong, nonatomic) User *user;
//
@property (strong, nonatomic) IBOutlet UILabel *labelOrder;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UILabel *labelPoint;
@property (strong, nonatomic) IBOutlet UIButton *buttonFollow;
//
- (IBAction)buttonFollowTap:(id)sender;
//
- (void) loadData;

@end
