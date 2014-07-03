//
//  EXPRankingsViewCell.m
//  exposure
//
//  Created by stuart on 2014-06-10.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPRankingsViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation EXPRankingsViewCell

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


- (IBAction)followBtn:(id)sender {
}

-(void)updateCellWithUser:(User *)user{
    _usernameLabel.text = user.userName;
    [_profileImage setImageWithURL:[NSURL URLWithString:user.profileImage]];
    
    
}
@end
