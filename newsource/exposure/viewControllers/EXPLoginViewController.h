//
//  EXPLoginViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/10/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPLoginViewController : EXPBaseViewController <UITextFieldDelegate, UIWebViewDelegate>


//IB Outlets
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonSignin;
@property (strong, nonatomic) IBOutlet UIButton *buttonSignup;
@property (strong, nonatomic) IBOutlet UIButton *buttonHowItWork;


//IB Actions
- (IBAction)buttonSignInTap:(id)sender;
- (IBAction)buttonSignUpTap:(id)sender;
- (IBAction)buttonHowitWorksTap:(id)sender;
- (IBAction)buttonBrowseTap:(id)sender;
- (IBAction)buttonForgotPasswordTap:(id)sender;

@end
