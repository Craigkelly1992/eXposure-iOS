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
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = TRUE;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(self.view.frame.origin.y != 0){
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

#pragma mark - IB Actions
- (IBAction)buttonSignInTap:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging In"];
    
}

- (IBAction)buttonSignUpTap:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[EXPSignUpViewController alloc]init] animated:YES];
    
}

- (IBAction)buttonHowitWorksTap:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[EXPHowItWorksViewController alloc]init] animated:YES];
    
}

- (IBAction)buttonBrowseTap:(id)sender {
    EXPTabBarController *tc = [[EXPTabBarController alloc]init];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:tc];
    [self removeFromParentViewController];
}

- (IBAction)buttonForgotPasswordTap:(id)sender {
    //http://localhost:3000/agencies/password/new
    UIViewController *vc = [[UIViewController alloc]init];
    UIWebView *wv = [[UIWebView alloc]initWithFrame:vc.view.frame];
    [vc.view addSubview:wv];
    navController = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelForgotPassword)];
    NSLog(@"%@",navController.navigationItem.rightBarButtonItem.title);
    [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/agencies/password/new"]]];
    [self presentViewController:navController animated:YES completion:nil];
    
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
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat difference = self.view.frame.origin.y - self->keyboardHeight + self.navigationController.navigationBar.frame.size.height;
            weakself.view.frame = CGRectMake(0, difference, weakself.view.frame.size.width, weakself.view.frame.size.height);//CGPointMake(weakself.view.center.x, self->keyboardHeight - weakself.view.frame.size.height);
            // NSLog(@"%f %f", weakself.postBtn.center.x, weakself.postBtn.center.y);
        }];
    }
}

@end