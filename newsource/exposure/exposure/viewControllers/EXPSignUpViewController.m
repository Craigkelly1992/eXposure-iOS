//
//  EXPSignUpViewController.m
//  exposure
//
//  Created by Binh Nguyen on 2014-07-23.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPSignUpViewController.h"
#import "EXPPhotoStreamViewController.h"
#import "EXPPortfolioViewController.h"
#import "EXPRankingsViewController.h"
#import "EXPNotificationsViewController.h"
#import "EXPSignUpViewController.h"
#import "EXPHowItWorksViewController.h"
#import "EXPContestsViewController.h"
#import "User.h"
#import "EXPTabBarController.h"

@interface EXPSignUpViewController ()<UITextFieldDelegate>{
    UITextField *activeField;
    NSString *deviceToken;
}

@end

@implementation EXPSignUpViewController

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
    self.title = @"Sign Up";
    // Back
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Done button
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnPressed)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    // Navigation
    [self.navigationController.navigationBar setTranslucent:NO];
    // Keyboard
//    [self registerForKeyboardNotifications];
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken {
    
    NSString *token = [[_deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    deviceToken = token;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneBtnPressed {
    [SVProgressHUD showWithStatus:@"Signing Up"];
    // signup here
    NSString *firstName = self.textFieldFirstname.text;
    NSString *lastName = self.textFieldLastname.text;
    NSString *email = self.textFieldEmail.text;
    NSString *phone = self.textFieldPhone.text;
    NSString *username = self.textFieldUsername.text;
    NSString *password = self.textFieldPassword.text;
    User *user = [[User alloc] init];
    user.first_name = firstName;
    user.last_name = lastName;
    user.phone = phone;
    user.email = email;
    user.username = username;
    user.password = password;
    user.device_token = deviceToken;
    // call service
    [SVProgressHUD showWithStatus:@"Signing up"];
    [self.serviceAPI signupWithUser: user
        success:^(id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"Sign up successfully !"];
            // save to global variables
            [Infrastructure sharedClient].currentUser = [User objectFromDictionary:responseObject];
            // go to home screen
//            EXPTabBarController *tabBarVC = [[EXPTabBarController alloc]init];
            [self.navigationController popViewControllerAnimated:NO]; // back to login
//            [self.navigationController removeFromParentViewController];
//            [self.navigationController pushViewController:tabBarVC animated:YES]; // go to tab bar
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showSuccessWithStatus:@"Sign up failed !"];
        }];
}
#pragma mark - text field delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect kbrect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect dRect = CGRectMake(kbrect.origin.x, kbrect.origin.y - 50, kbrect.size.width, kbrect.size.height + 50);
    CGRect bkgndRect = activeField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [activeField.superview setFrame:bkgndRect];
    if (CGRectContainsPoint(dRect, activeField.frame.origin) ) {
    [self.scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:NO];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

@end
