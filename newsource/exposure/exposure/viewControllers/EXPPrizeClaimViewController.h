//
//  EXPPrizeClaimViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPPrizeClaimViewController : EXPBaseViewController <UITextFieldDelegate>

// Properties

// IBOutlet
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelWinnerText;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (strong, nonatomic) IBOutlet UITextField *textFieldStreet;
@property (strong, nonatomic) IBOutlet UITextField *textFieldCity;
@property (strong, nonatomic) IBOutlet UITextField *textFieldProvince;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPostalCode;


@end
