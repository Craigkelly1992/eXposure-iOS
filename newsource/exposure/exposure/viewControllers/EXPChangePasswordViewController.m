//
//  EXPChangePasswordViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPChangePasswordViewController.h"

@interface EXPChangePasswordViewController ()

@end

@implementation EXPChangePasswordViewController {
    User *user;
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
    self.title = @"Change Password";
    [self.navigationController.navigationBar setTranslucent:NO];
    // Back
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Done
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing)];
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    //
    user = [Infrastructure sharedClient].currentUser;
}

- (void) dismissKeyboard {
    [self.textFieldCurrentPassword resignFirstResponder];
    [self.textFieldNewPassword resignFirstResponder];
    [self.textFieldConfirmPassword resignFirstResponder];
}

- (void)doneEditing {
    // check current password
    NSString *currentPassword = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_KEY_PASSWORD];
    
    NSString *newPassword = [self.textFieldNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if (!currentPassword
        || ![currentPassword isEqualToString:self.textFieldCurrentPassword.text]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Old password is not correct. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    } else if (newPassword.length < 8) {
         [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"The length of your password must be greater than 7 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
        return;
    } else if (![self.textFieldNewPassword.text isEqualToString:self.textFieldConfirmPassword.text]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"The confirmation password is not correct" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    //
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI updatePasswordWithNewPassword:newPassword userEmail:user.email token:user.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Fail: %@", error.description]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
