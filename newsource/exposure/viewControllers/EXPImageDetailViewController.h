//
//  EXPImageDetailViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPImageDetailViewController : EXPBaseViewController <UITableViewDataSource, UITableViewDelegate>

//
@property (strong, nonatomic) NSNumber *postId;
// Outlets
@property (strong, nonatomic) IBOutlet UIImageView *imageViewUser;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UIButton *buttonShare;
@property (strong, nonatomic) IBOutlet UIImageView *imageviewPost;
@property (strong, nonatomic) IBOutlet UILabel *labelPostName;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelContestName;
@property (strong, nonatomic) IBOutlet UILabel *labelXpCount;
@property (strong, nonatomic) IBOutlet UILabel *labelCommentCount;
@property (strong, nonatomic) IBOutlet UITableView *tableViewComment;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintCommentListHeight;
@property (strong, nonatomic) IBOutlet UITextField *textFieldComment;
@property (strong, nonatomic) IBOutlet UIButton *buttonExposure;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;

// Actions
- (IBAction)buttonExposureTap:(id)sender;
- (IBAction)buttonCommentTap:(id)sender;
- (IBAction)buttonShareTap:(id)sender;
- (IBAction)buttonSendTap:(id)sender;

@end
