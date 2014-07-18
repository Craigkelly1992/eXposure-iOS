//
//  EXPSignUpViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPSignUpViewController.h"
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


@interface EXPSignUpViewController ()<UITextFieldDelegate>{
    UITextField *activeField;
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
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnPressed)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self registerForKeyboardNotifications];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneBtnPressed {
    [SVProgressHUD showWithStatus:@"Signing Up"];
    // signup here
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


//-(NSArray *)createTabBarViewControllers {
//    EXPStreamViewController *vc = [[EXPStreamViewController alloc]init];
//    EXPPortfolioViewController *portfolio = [[EXPPortfolioViewController alloc]init];
//    EXPRankingsViewController *rankings = [[EXPRankingsViewController alloc]init];
//    EXPNotificationsViewController *notifications = [[EXPNotificationsViewController alloc]init];
//    EXPContestsViewController *contests = [[EXPContestsViewController alloc]init];
//    
//    UINavigationController *streamNav = [[UINavigationController alloc]initWithRootViewController:vc];
//    UINavigationController *notificationnav = [[UINavigationController alloc]initWithRootViewController:notifications];
//    UINavigationController *portfolioNav = [[UINavigationController alloc]initWithRootViewController:portfolio];
//    
//    UINavigationController *contestsNav = [[UINavigationController alloc]initWithRootViewController:contests];
//    UINavigationController *rankingsNav = [[UINavigationController alloc]initWithRootViewController:rankings];
//    
//    notifications.title = @"Notifications";
//    portfolio.title = @"Portfolio";
//    vc.title = @"Photo Stream";
//    rankings.title = @"Rankings";
//    contests.title = @"Contests";
//    return [NSArray arrayWithObjects:streamNav, contestsNav, rankingsNav, notificationnav, portfolioNav, nil];
//}


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
