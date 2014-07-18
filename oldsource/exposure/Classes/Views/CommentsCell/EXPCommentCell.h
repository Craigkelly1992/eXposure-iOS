//
//  EXPCommentCell.h
//  exposure
//
//  Created by stuart on 2014-06-12.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface EXPCommentCell : UITableViewCell {
    Comment *_comment;
}
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commenterName;

-(void)updateCellWithComment:(Comment *)comment;
@end
