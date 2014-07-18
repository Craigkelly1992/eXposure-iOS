//
//  EXPImageDetailViewController.h
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface EXPImageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *contestLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
- (IBAction)shareBtn:(id)sender;
- (IBAction)commentBtn:(id)sender;
- (IBAction)likeBtn:(id)sender;
- (IBAction)profileBtn:(id)sender;
-(id)initWithPost:(Post *)post;


@end
