//
//  EXPRankingsViewCell.h
//  exposure
//
//  Created by stuart on 2014-06-10.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface EXPRankingsViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
- (IBAction)followBtn:(id)sender;

-(void)updateCellWithUser:(User *)user;
@end
