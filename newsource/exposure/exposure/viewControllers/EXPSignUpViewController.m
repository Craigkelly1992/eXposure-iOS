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

//validation
#define REGEX_USER_NAME @"[A-Za-z0-9]{6,16}"
#define REGEX_NAME @"[A-Za-z]{1,}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{1,}"

@interface EXPSignUpViewController ()<UITextFieldDelegate>{
    UITextField *activeField;
    NSString *deviceToken;
    NSMutableArray *arrEmails;
    NSMutableArray *arrUsers;
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
-(id)init{
    self = [super init];
   
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self.serviceAPI getAllEmailsUsers:nil
                               success:^(id responseObject) {
                                   //Array emails, users
                                   //Parsing
                                   NSMutableArray *arrayEmails = [[NSMutableArray alloc] init];
                                   NSMutableArray *arrayUsers = [[NSMutableArray alloc] init];
                                   for(NSObject *object in responseObject){
                                       [arrayEmails addObject:[object valueForKey:@"email"]];
                                       [arrayUsers addObject:[object valueForKey:@"username"]];
                                   }
                                   arrEmails = arrayEmails;
                                   arrUsers  = arrayUsers;
                                   [SVProgressHUD showSuccessWithStatus:@"Success"];
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   [SVProgressHUD showErrorWithStatus:@"Service Error. Please try again later!"];
                                   NSLog(@"Error: %@", error.description);
                               }];
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
    // signup here
    NSString *firstName = self.textFieldFirstname.text;
    NSString *lastName = self.textFieldLastname.text;
    NSString *email = self.textFieldEmail.text;
    NSString *phone = self.textFieldPhone.text;
    NSString *username = self.textFieldUsername.text;
    NSString *password = self.textFieldPassword.text;
    NSString *confirmpassword= self.textFieldConfirmPassword.text;
    NSString *errorMessage = @"";
    NSString *errorFirstName = @"\n*First name: Enter valid name with at least one alphabet (a-z,A-Z)";
    NSString *errorLastName = @"\n*Last name: Enter valid name with at least one alphabet (a-z,A-Z)";
    NSString *errorEmail = @"\n*Email: Enter valid email (abcd@xyz.com)";
    NSString *errorPhone = @"\n*Phone: Enter valid phone number (0-9)";
    NSString *errorExistedEmail = @"*Email already exists";
    NSString *errorUserName = @"\n*Username: Enter valid username between 6 - 16 characters (a-z,A-Z,0-9)";
    NSString *errorExistedUsername = @"\n*Username already exists";
    NSString *errorPassword = @"\n*Password: Enter valid password between 6 - 20 characters (a-z,A-Z,0-9)";
    NSString *errorConfirmPassword = @"\n*Confirm Password: Enter confirm password same as password";
    User *user = [[User alloc] init];
    user.first_name = firstName;
    user.last_name = lastName;
    user.phone = phone;
    user.email = email;
    user.username = username;
    user.password = password;
    user.device_token = deviceToken;
    bool isExistedEmails = false;
    bool isExistedUsers = false;
    
    //validation
    if(![self nameValidate:firstName]){
        NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorFirstName, nil];
        errorMessage = [arrayErrorString componentsJoinedByString:@""];
    }
    if(![self nameValidate:lastName]){
        NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorLastName, nil];
        errorMessage = [arrayErrorString componentsJoinedByString:@""];
    }
    if(![self emailValidate:email]){
        NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorEmail, nil];
        errorMessage = [arrayErrorString componentsJoinedByString:@""];
    }
    if(arrEmails != nil && arrEmails.count !=0){
        for(NSObject *objEmails in arrEmails){
            NSString *compareStr = objEmails;
            if([email isEqualToString:compareStr]){
                isExistedEmails = true;
                break;
            }
        }
        if(isExistedEmails && [self emailValidate:email]){
            NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorExistedEmail, nil];
            errorMessage = [arrayErrorString componentsJoinedByString:@""];
        }
    }
    if(arrUsers != nil && arrUsers.count !=0){
        for(NSObject *objUsers in arrUsers){
            NSString *compareStr = objUsers;
            if([username isEqualToString:compareStr]){
                isExistedUsers = true;
                break;
            }
        }
        if(isExistedUsers && [self userNameValidate:username]){
            NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorExistedUsername, nil];
            errorMessage = [arrayErrorString componentsJoinedByString:@""];
        }
    }
    if(![self userNameValidate:username]){
        NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorUserName, nil];
        errorMessage = [arrayErrorString componentsJoinedByString:@""];
    }
    if(![self phoneValidate:phone]){
        NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorPhone, nil];
        errorMessage = [arrayErrorString componentsJoinedByString:@""];
    }
    if(![self passwordValidate:password]){
        NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorPassword, nil];
        errorMessage = [arrayErrorString componentsJoinedByString:@""];
    }
    if(![password isEqualToString:confirmpassword])
    {
        NSArray *arrayErrorString = [[NSArray alloc] initWithObjects:errorMessage, errorConfirmPassword, nil];
        errorMessage = [arrayErrorString componentsJoinedByString:@""];

    }
    
    if([self nameValidate:firstName] && [self nameValidate:lastName] && [self emailValidate:email] && [self userNameValidate:username] && [self phoneValidate:phone] && [self passwordValidate:password] && !isExistedEmails && !isExistedUsers && [password isEqualToString:confirmpassword]){
        // call service
        [SVProgressHUD showWithStatus:@"Signing up"];
        [self.serviceAPI signupWithUser: user
                                success:^(id responseObject) {
                                    
                                    // save to global variables
                                    [Infrastructure sharedClient].currentUser = [User objectFromDictionary:responseObject];
                                    // go to home screen
                                    //            EXPTabBarController *tabBarVC = [[EXPTabBarController alloc]init];
                                    [SVProgressHUD showSuccessWithStatus:@"Sign up successfully !"];
                                    [self.navigationController popViewControllerAnimated:NO]; // back to login
                                    //            [self.navigationController removeFromParentViewController];
                                    //            [self.navigationController pushViewController:tabBarVC animated:YES]; // go to tab bar
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [SVProgressHUD showSuccessWithStatus:@"Sign up failed !\n"];
                                }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Your Info Again"
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
//validation
-(bool)nameValidate:(NSString*)name
{
    NSPredicate *nameValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_NAME];
    bool isValid = [nameValidate evaluateWithObject:name];
    return isValid;
}
-(bool)userNameValidate:(NSString*)userName
{
    NSPredicate *userNameValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_USER_NAME];
    bool isValid = [userNameValidate evaluateWithObject:userName];
    return isValid;
}
-(bool)emailValidate:(NSString*)email
{
    NSPredicate *emailValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_EMAIL];
    bool isValid = [emailValidate evaluateWithObject:email];
    return isValid;
}
-(bool)phoneValidate:(NSString*)phone
{
    NSPredicate *phoneValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_PHONE_DEFAULT];
    bool isValid = [phoneValidate evaluateWithObject:phone];
    return isValid;
}
-(bool)passwordValidate:(NSString*)password
{
    NSPredicate *passwordValidate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_PASSWORD];
    bool isValid = [passwordValidate evaluateWithObject:password];
    return isValid;
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
