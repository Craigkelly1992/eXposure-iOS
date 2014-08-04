//
//  EXPNewPostViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/18/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"
#import "EXPTabBarController.h"

@interface EXPNewPostViewController : EXPBaseViewController

//
@property (strong, nonatomic) UIImage *imagePost;
@property (strong, nonatomic) NSNumber *contestId;

// IBOutlet
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPost;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPostDescription;
@property (strong, nonatomic) IBOutlet UIView *viewDescription;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintViewDescriptionBottom;

// Action
- (IBAction)buttonSendTap:(id)sender;
@end
