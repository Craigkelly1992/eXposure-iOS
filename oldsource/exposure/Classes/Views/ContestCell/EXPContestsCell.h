//
//  EXPContestsCell.h
//  exposure
//
//  Created by stuart on 2014-06-03.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contest.h"

@interface EXPContestsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contestImage;
@property (weak, nonatomic) IBOutlet UILabel *contestName;
@property (weak, nonatomic) IBOutlet UILabel *contestSlogan;
@property (weak, nonatomic) IBOutlet UIImageView *enteredImage;

-(void)updateWithContest:(Contest *)contest;

@end
