//
//  PointTableViewCell.m
//  exposure
//
//  Created by Binh Nguyen on 7/30/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "PointTableViewCell.h"

@implementation PointTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadData {
    self.labelOrder.text = [NSString stringWithFormat:@"%d.", self.order];
    self.labelUsername.text = self.user.username;
    self.labelPoint.text = [NSString stringWithFormat:@"%@Xp", self.user.cached_score];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.imageViewProfile];
    [self.imageViewProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (self.user.profile_picture_url && [self.user.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound) {
        
        [self.imageViewProfile setImageURL:[NSURL URLWithString:self.user.profile_picture_url]];
    }
    if ([self.user.current_user_following intValue] == 1) { // true
        [self.buttonFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_blue_small"] forState:UIControlStateNormal];
        
        
    } else if ([self.user.current_user_following intValue] == 0) { // false
        [self.buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)buttonFollowTap:(id)sender {
    
}
@end
