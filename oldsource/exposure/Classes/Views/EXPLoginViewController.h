//
//  EXPLoginViewController.h
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPLoginViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *howItWorks;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

//IB Methods
- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)howitWorks:(id)sender;
- (IBAction)browseBtn:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end
