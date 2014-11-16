//
//  EXPPrizeClaimViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPrizeClaimViewController.h"

@interface EXPPrizeClaimViewController ()

@end

@implementation EXPPrizeClaimViewController {
    User *currentUser;
    User *winnerUser;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Claim Your Prize";
    currentUser = [Infrastructure sharedClient].currentUser;
    // Back
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Done
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing)];
}

- (void)viewDidLayoutSubviews {
    // scroll view
    self.scrollViewContainer.contentSize = CGSizeMake(self.scrollViewContainer.frame.size.width, self.textFieldProvince.frame.origin.y + 50);
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserInfo];
}

-(void) getUserInfo {
    // load user
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getUserWithId:currentUser.userId email:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        winnerUser = [User objectFromDictionary:responseObject];
        // fill user's data
        if (winnerUser) {
            //
            self.textFieldFirstName.text = winnerUser.first_name;
            self.textFieldLastName.text = winnerUser.last_name;
            self.textFieldEmail.text = winnerUser.email;
            self.textFieldPhone.text = winnerUser.phone;
            [self.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
            if ([winnerUser.profile_picture_url_thumb rangeOfString:@"placeholder"].location == NSNotFound) {
                [self.imageView setImageURL:[NSURL URLWithString:winnerUser.profile_picture_url_thumb]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void)doneEditing {
    // check valid data
    BOOL valid =
    [self checkStringEmpty:self.textFieldFirstName withErrorString:@"Please input your first name"]&&
    [self checkStringEmpty:self.textFieldLastName withErrorString:@"Please input your last name"]
    &&
    [self checkStringEmpty:self.textFieldPhone withErrorString:@"Please input your phone"]
    &&
    [self checkStringEmpty:self.textFieldEmail withErrorString:@"Please input your email"]
    &&
    [self checkStringEmpty:self.textFieldStreet withErrorString:@"Please input your street"]
    &&
    [self checkStringEmpty:self.textFieldCity withErrorString:@"Please input your city"]
    &&
    [self checkStringEmpty:self.textFieldProvince withErrorString:@"Please input your province"]
    &&
    [self checkStringEmpty:self.textFieldPostalCode withErrorString:@"Please input your postal code"];
    if (!valid) {
        return;
    }
    
    // Send data to server
    [SVProgressHUD showWithStatus:@"Sending data"];
    [self.serviceAPI claimThePrizeWithWinnerFirstName:self.textFieldFirstName.text
                                       winnerLastName:self.textFieldLastName.text
                                          winnerEmail:self.textFieldEmail.text
                                          winnerPhone:self.textFieldPhone.text
                                         winnerStreet:self.textFieldStreet.text
                                           winnerCity:self.textFieldCity.text
                                       winnerProvince:self.textFieldProvince.text
                                     winnerPostalCode:self.textFieldPostalCode.text
                                            userEmail: currentUser.email
                                            userToken:currentUser.authentication_token
                                              success:^(id responseObject) {
        
                                                  NSLog(@"Success: %@", responseObject);
                                                  [SVProgressHUD showSuccessWithStatus:@"Success"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Service Error. Please try again later!"];
        NSLog(@"Error: %@", error.description);
    }];
}

- (BOOL) checkStringEmpty:(UITextField*)textField withErrorString:(NSString*)errorString {
    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length <= 0) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
