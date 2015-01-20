//
//  EXPPortFolioSettingsViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "IKLoginViewController.h"

@interface EXPPortFolioSettingsViewController : EXPBaseViewController<UIScrollViewDelegate, FBLoginViewDelegate, InstagramDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWebsite;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (strong, nonatomic) IBOutlet FBLoginView *viewFBLogin;
@property (strong, nonatomic) IBOutlet UIButton *buttonChangePassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonInstagram;
@property (strong, nonatomic) IBOutlet UIButton *buttonTwitter;
// Actions
- (IBAction)signOut:(id)sender;
- (IBAction)changePassword:(id)sender;
- (IBAction)uploadProfile:(id)sender;
- (IBAction)uploadBackground:(id)sender;
- (IBAction)buttonInstagramTap:(id)sender;
- (IBAction)buttonTwitterTap:(id)sender;

@end
