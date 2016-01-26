//
//  EXPLoginViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/10/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPLoginViewController.h"
#import <DAKeyboardControl/DAKeyboardControl.h>
#import "EXPSignUpViewController.h"
#import "EXPHowItWorksViewController.h"
#import "EXPContestsViewController.h"
#import "User.h"
#import "EXPTabBarController.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define kKeyboardOffset 100

@interface EXPLoginViewController (){
    UINavigationController *navController;
    CGFloat keyboardHeight;
}

@end

@implementation EXPLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // load username if existing
    self.textFieldEmail.text = @"";
    self.textFieldPassword.text = @"";
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_KEY_EMAIL];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_KEY_PASSWORD];
    if (email.length > 0
        & password.length > 0) {
        self.textFieldEmail.text = email;
        self.textFieldPassword.text = password;
        [self buttonSignInTap:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    // dismiss keyboard
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(self.view.frame.origin.y != 0){
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            self.buttonHowItWork.frame = CGRectMake(self.buttonHowItWork.frame.origin.x, 37, self.buttonHowItWork.frame.size.width, self.buttonHowItWork.frame.size.height);
        }];
    }
}

#pragma mark - IB Actions
- (IBAction)buttonSignInTap:(id)sender {
    // checking
    NSString *emailTrimString = [self.textFieldEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
    if (emailTrimString.length <= 0 || self.textFieldPassword.text.length <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please fill both username & password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    // signin with service api
    [SVProgressHUD showWithStatus:@"Logging In"];
    [self.serviceAPI loginWithUserEmail:self.textFieldEmail.text password:self.textFieldPassword.text success:^(id responseObject) {
        //
        NSLog(@"Signin Successfully !");
        // save username for next time
        [[NSUserDefaults standardUserDefaults] setValue:self.textFieldEmail.text forKey:USERDEFAULT_KEY_EMAIL];
        [[NSUserDefaults standardUserDefaults] setValue:self.textFieldPassword.text forKey:USERDEFAULT_KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // save to global variables
        [Infrastructure sharedClient].currentUser = [User objectFromDictionary:responseObject];
        [SVProgressHUD dismiss];
        
        // register device token
        User *currentUser = [Infrastructure sharedClient].currentUser;
        if([Infrastructure sharedClient].deviceToken != nil){
            [self.serviceAPI registerDeviceWithUserId:currentUser.userId email:currentUser.email userToken:currentUser.authentication_token deviceToken:[Infrastructure sharedClient].deviceToken success:^(id responseObject) {
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSString *token= [Infrastructure sharedClient].deviceToken;
                
                NSLog(@"Error: %@", error);
            }];
        }
        
        // go to home screen
        EXPTabBarController *tabBarVC = [[EXPTabBarController alloc]init];
        [self.navigationController pushViewController:tabBarVC animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Signin Failed !");
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Email or password is not correct" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
}

- (IBAction)buttonSignUpTap:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    EXPSignUpViewController *signupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPSignUpViewControllerIdentifier"];
    [self.navigationController pushViewController:signupVC animated:YES];
    
}

- (IBAction)buttonHowitWorksTap:(id)sender {
    
}

- (IBAction)buttonBrowseTap:(id)sender {
    EXPTabBarController *tabBarVC = [[EXPTabBarController alloc]init];
    //navigate to tabBarVC
    [self.navigationController pushViewController:tabBarVC animated:YES];
}

- (IBAction)buttonForgotPasswordTap:(id)sender {
    //http://localhost:3000/agencies/password/new
    UIViewController *vc = [[UIViewController alloc]init];
    UIWebView *wv = [[UIWebView alloc]initWithFrame:vc.view.frame];
    wv.delegate = self;
    [vc.view addSubview:wv];
    navController = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelForgotPassword)];
    NSLog(@"%@",navController.navigationItem.rightBarButtonItem.title);
    [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://exposuretechnologies.com/users/password/new"]]];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        [navController dismissViewControllerAnimated:YES completion:nil];
    }
    return YES;
}

-(void)cancelForgotPassword {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;
    NSLog(@"%f",keyboardHeight);
    __block EXPLoginViewController *weakself = self;
    if (self.view.frame.origin.y == 0) {
        [UIView animateWithDuration:0.35 animations:^{
            int signinY = self.buttonSignin.frame.origin.y + self.buttonSignin.frame.size.height;
            int keyboardY = self.view.frame.size.height - self->keyboardHeight;
            if (signinY > keyboardY) {
                CGFloat difference = - (signinY - keyboardY);
                weakself.view.frame = CGRectMake(0, difference, weakself.view.frame.size.width, weakself.view.frame.size.height);
                weakself.buttonHowItWork.frame = CGRectMake(weakself.buttonHowItWork.frame.origin.x, weakself.buttonHowItWork.frame.origin.y - difference - 20, weakself.buttonHowItWork.frame.size.width, weakself.buttonHowItWork.frame.size.height);
            }
        }];
    }
}

#pragma mark - Segue Delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController class] == [EXPHowItWorksViewController class]) {
        self.navigationController.navigationBarHidden = NO;
    }
}

@end