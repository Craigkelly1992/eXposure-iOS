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
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    self.viewContainer.gestureRecognizers = [[NSArray alloc] initWithObjects:tapGesture, nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLayoutSubviews {
    
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
    NSLog(@"ScrollView height before : %f", self.scrollViewContainer.frame.size.height);
    self.constraintBottomHeight.constant = kbSize.height;
    [self.view layoutSubviews];
    NSLog(@"ScrollView height after : %f", self.scrollViewContainer.frame.size.height);
    [self.scrollViewContainer setContentSize:self.viewContainer.frame.size];
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewContainer.contentInset = contentInsets;
    self.scrollViewContainer.scrollIndicatorInsets = contentInsets;
    self.constraintBottomHeight.constant = 0;
}

- (void) dismissKeyboard {
    [self.textFieldConfirmPassword resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldFirstname resignFirstResponder];
    [self.textFieldLastname resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldUsername resignFirstResponder];
}

@end
