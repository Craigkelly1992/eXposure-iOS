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
    UITextField *textFieldSelected;
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
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.scrollViewContainer addGestureRecognizer:tapGesture];
}

- (void)viewDidLayoutSubviews {
    // scroll view
    self.scrollViewContainer.contentSize = CGSizeMake(self.scrollViewContainer.frame.size.width, self.textFieldProvince.frame.origin.y + 50);
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserInfo];
    [self registerForKeyboardNotifications];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self deregisterFromKeyboardNotifications];
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
            if ([[Infrastructure sharedClient].AdPrizeClaim rangeOfString:@"placeholder"].location == NSNotFound) {
                [self.imageView setImageURL:[NSURL URLWithString:[Infrastructure sharedClient].AdPrizeClaim]];
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
    [self checkStringEmpty:self.textFieldEmail withErrorString:@"Please input your email"];

    if (!valid) {
        return;
    }
    
    // Send data to server
    NSNumber *contestID = [Infrastructure sharedClient].contestId;
    NSNumber *notificationId = [Infrastructure sharedClient].notificationId;
    NSLog(@"-----------LOG-----------");
    NSLog(@"%i", [contestID intValue]);
    NSLog(@"%i", [notificationId intValue]);
    NSLog(@"-----------END-----------");
    
    [SVProgressHUD showWithStatus:@"Sending data"];
    [self.serviceAPI claimThePrizeWithContestId:contestID
                                       notificationId:notificationId
                                      WinnerFirstName:self.textFieldFirstName.text
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
        
                                                  NSLog(@"Claim Success: %@", responseObject);
                                                  [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                                                  
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Claim Fail. Please try again later!"];
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

#pragma mark - UITextView Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textFieldSelected = textField;
    return YES;
}

#pragma mark - keyboard notification
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint buttonOrigin = textFieldSelected.frame.origin;
    
    CGFloat buttonHeight = textFieldSelected.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        [self.scrollViewContainer setContentOffset:scrollPoint animated:YES];
        
    }
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    [self.scrollViewContainer setContentOffset:CGPointZero animated:YES];
    
}

- (void) clickOnView {
    [self.textFieldFirstName resignFirstResponder];
    [self.textFieldLastName resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldStreet resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldProvince resignFirstResponder];
    [self.textFieldPostalCode resignFirstResponder];
}

@end
