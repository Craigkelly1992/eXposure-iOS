//
//  EXPContestsCell.m
//  exposure
//
//  Created by stuart on 2014-06-03.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPContestsCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Brand.h"

@implementation EXPContestsCell

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

-(void)updateWithContest:(Contest *)contest{
    NSLog(@"HERE IS THE PICTURE %@", contest);
    [_contestImage setImageWithURL:[NSURL URLWithString:contest.picture]];
   
    _contestName.text = contest.brand_name;
    _contestSlogan.text = contest.title;
}


@end
