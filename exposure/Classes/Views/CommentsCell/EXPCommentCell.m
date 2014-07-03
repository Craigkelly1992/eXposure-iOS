//
//  EXPCommentCell.m
//  exposure
//
//  Created by stuart on 2014-06-12.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPCommentCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation EXPCommentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCellWithComment:(Comment *)comment{
    _comment = comment;
    [_profileImage setImageWithURL:[NSURL URLWithString:comment.commentPicture]];
    _commenterName.text = comment.commenter_name;
    _commentLabel.text = comment.commentText;
    
}

@end
