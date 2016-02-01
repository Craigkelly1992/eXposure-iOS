//
//  EXPChangePasswordViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPChangePasswordViewController : EXPBaseViewController

@property (strong, nonatomic) IBOutlet UITextField *textFieldCurrentPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;

@end
