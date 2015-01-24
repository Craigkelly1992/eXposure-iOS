//
//  EXPSignUpViewController.h
//  exposure
//
//  Created by Binh Nguyen on 2014-07-23.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPSignUpViewController : EXPBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;

-(BOOL)nameValidate:(NSString*)name;
-(BOOL)userNameValidate:(NSString*)userName;
-(BOOL)emailValidate:(NSString*)email;
-(BOOL)phoneValidate:(NSString*)phone;

@end
