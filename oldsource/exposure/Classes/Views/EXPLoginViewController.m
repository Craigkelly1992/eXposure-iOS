//
//  EXPLoginViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPLoginViewController.h"
#import <DAKeyboardControl/DAKeyboardControl.h>
#import "EXPStreamViewController.h"
#import "EXPPortfolioViewController.h"
#import "EXPRankingsViewController.h"
#import "EXPNotificationsViewController.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestureToDismissKeyboard];
    _passwordField.delegate = self;
    _emailField.delegate = self;
    [self.navigationController.navigationBar setTranslucent:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - kKeyboardOffset);
//    }];
}

/*gestures*/
- (void)setupGestureToDismissKeyboard {
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)]];
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(self.view.frame.origin.y != 0){
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         }];
    }
}

- (IBAction)signIn:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging In"];
   [User loginUserWithEmail:_emailField.text password:_passwordField.text completion:^(User *user, NSError *error){
            if(!error){
                EXPTabBarController *tc = [[EXPTabBarController alloc]initWithUser:user];
                [[[UIApplication sharedApplication] keyWindow] setRootViewController:tc];
                [self removeFromParentViewController];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Login failed: %@", error.localizedDescription]];
            }
    }];
   
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

- (IBAction)signUp:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[EXPSignUpViewController alloc]init] animated:YES];
    
}

- (IBAction)howitWorks:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[[EXPHowItWorksViewController alloc]init] animated:YES];
    
}

//-(NSArray *)createTabBarViewControllers {
//    EXPStreamViewController *photoStreamVC = [[EXPStreamViewController alloc]init];
//    EXPPortfolioViewController *portfolio = [[EXPPortfolioViewController alloc]init];
//    EXPRankingsViewController *rankings = [[EXPRankingsViewController alloc]init];
//    EXPNotificationsViewController *notifications = [[EXPNotificationsViewController alloc]init];
//    EXPContestsViewController *contests = [[EXPContestsViewController alloc]init];
//    
//    UINavigationController *streamNav = [[UINavigationController alloc]initWithRootViewController:photoStreamVC];
//     streamNav.navigationBar.translucent = NO;
//    UINavigationController *notificationnav = [[UINavigationController alloc]initWithRootViewController:notifications];
//     notificationnav.navigationBar.translucent = NO;
//    UINavigationController *portfolioNav = [[UINavigationController alloc]initWithRootViewController:portfolio];
//     portfolioNav.navigationBar.translucent = NO;
//    UINavigationController *contestsNav = [[UINavigationController alloc]initWithRootViewController:contests];
//     contestsNav.navigationBar.translucent = NO;
//    UINavigationController *rankingsNav = [[UINavigationController alloc]initWithRootViewController:rankings];
//     rankingsNav.navigationBar.translucent = NO;
//    
//    notifications.title = @"Notifications";
//    portfolio.title = @"Portfolio";
//    photoStreamVC.title = @"Photo Stream";
//    rankings.title = @"Rankings";
//    contests.title = @"Contests";
//    return [NSArray arrayWithObjects:streamNav, contestsNav, rankingsNav, notificationnav, portfolioNav, nil];
//}

- (IBAction)browseBtn:(id)sender {
    EXPTabBarController *tc = [[EXPTabBarController alloc]init];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:tc];
    [self removeFromParentViewController];
}

- (IBAction)forgotPassword:(id)sender {
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
@end
