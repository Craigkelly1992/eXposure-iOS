//
//  EXPPortFolioSettingsViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPortFolioSettingsViewController.h"
#import "EXPChangePasswordViewController.h"
#import "User.h"
#import "CLImageEditor.h"
#import "Brand.h"
#import "Post.h"
#import "EXPLoginViewController.h"
#import "Contest.h"
#import <FacebookSDK/FacebookSDK.h>
#import "InstagramKit.h"
#import "IKLoginViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface EXPPortFolioSettingsViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate> {
    int pictureType;
}

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation EXPPortFolioSettingsViewController {
    User *currentUser;
    BOOL isProfileChanged;
    BOOL isBackgroundChanged;
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
    self.title = @"Portfolio Settings";
    [self.navigationController.navigationBar setTranslucent:NO];
    // Back
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Done
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing)];
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    // Facebook
    self.viewFBLogin.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_photos"];
    // Instagram
    // check if logged in
    if ([InstagramEngine sharedEngine].accessToken) {
        [self.buttonInstagram setTitle:@"Logout Instagram" forState:UIControlStateNormal];
    } else {
        [self.buttonInstagram setTitle:@"Login Instagram" forState:UIControlStateNormal];
    }
    // Twitter
    self.accountStore = [[ACAccountStore alloc] init];
    // just load imageview from url here, because if we place it on viewWillAppear, the problem when we return back from DoneEditing will be strange
    currentUser = [Infrastructure sharedClient].currentUser;
    [self.imageViewProfile setImageURL:[NSURL URLWithString:currentUser.profile_picture_url_thumb]];
    [self.imageViewBackground setImageURL:[NSURL URLWithString:currentUser.background_picture_url_preview]];
    //
    isProfileChanged = NO;
    isBackgroundChanged = NO;
}

-(void) dismissKeyboard {
    [self.textFieldFirstname resignFirstResponder];
    [self.textFieldLastname resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldUsername resignFirstResponder];
    [self.textFieldPhone resignFirstResponder];
    [self.textFieldWebsite resignFirstResponder];
    [self.textFieldDescription resignFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [self.scrollViewContainer setContentSize:CGSizeMake(self.view.frame.size.width, self.viewContainer.frame.size.height)];
}

- (void)viewWillAppear:(BOOL)animated {
    // fill data
    self.textFieldFirstname.text = currentUser.first_name;
    self.textFieldLastname.text = currentUser.last_name;
    self.textFieldEmail.text = currentUser.email;
    self.textFieldPhone.text = currentUser.phone;
    self.textFieldUsername.text = currentUser.username;
    self.textFieldDescription.text = currentUser.description;
    self.textFieldWebsite.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)uploadProfile:(id)sender {
    pictureType = 1;
    [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil]showInView:self.view];
    
}
- (IBAction)uploadBackground:(id)sender {
    pictureType = 2;
    [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil]showInView:self.view];
}

- (IBAction)buttonInstagramTap:(id)sender {
    if (![InstagramEngine sharedEngine].accessToken) {
        // log in
        IKLoginViewController *loginVc = [self.storyboard instantiateViewControllerWithIdentifier:@"IKLoginViewControllerIdentifier"];
        loginVc.delegate = self;
        [self.navigationController pushViewController:loginVc animated:YES];
    } else {
        // log out
        [[InstagramEngine sharedEngine] logout];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULT_KEY_INSTAGRAM_TOKEN];
        [self.buttonInstagram setTitle:@"Login Instagram" forState:UIControlStateNormal];
    }
}

- (IBAction)buttonTwitterTap:(id)sender {
    [self fetchTimelineForUser];
}

- (IBAction)changePassword:(id)sender {
    
    EXPChangePasswordViewController *changePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPChangePasswordViewControllerIdentifier"];
    [self.navigationController pushViewController:changePasswordVC animated:YES];
}

-(void)doneEditing{
    User *user = [Infrastructure sharedClient].currentUser;
    NSData *profilePicture = nil;
    NSData *backgroundPicture = nil;
    NSString *firstName = nil;
    NSString *lastName = nil;
    NSString *newEmail = nil;
    NSString *phone = nil;
    NSString *userName = nil;
    NSString *deviceToken = nil;
    NSString *description = nil;
    NSString *website = nil;
    if (![self.textFieldFirstname.text isEqualToString:@""]
        && ![self.textFieldFirstname.text isEqualToString:user.first_name]) {
        firstName = self.textFieldFirstname.text;
    }
    if(![self.textFieldLastname.text isEqualToString:@""]
       && ![self.textFieldLastname.text isEqualToString:user.last_name]){
        lastName = self.textFieldLastname.text;
    }
    if(![self.textFieldEmail.text isEqualToString:@""]
       && ![self.textFieldEmail.text isEqualToString:user.email]){
        newEmail = self.textFieldEmail.text;
    }
    if(![self.textFieldPhone.text isEqualToString:@""]
       && ![self.textFieldPhone.text isEqualToString:user.phone]){
        phone = self.textFieldPhone.text;
    }
    if(![self.textFieldUsername.text isEqualToString:@""]
       && ![self.textFieldUsername.text isEqualToString:user.username]){
        userName = self.textFieldUsername.text;
    }
    if(![self.textFieldDescription.text isEqualToString:@""]
       && ![self.textFieldDescription.text isEqualToString:user.description]){
        description = self.textFieldDescription.text;
    }
    if(![self.textFieldWebsite.text isEqualToString:@""]
       && ![self.textFieldWebsite.text isEqualToString:user.website]){
        website = self.textFieldWebsite.text;
    }
    if(self.imageViewProfile.image != nil && isProfileChanged) {
        profilePicture = UIImageJPEGRepresentation(self.imageViewProfile.image, 0.6f); // JPEG
        if (!profilePicture) {
            profilePicture = UIImagePNGRepresentation(self.imageViewProfile.image); // PNG
        }
    }
    if(self.imageViewBackground.image != nil && isBackgroundChanged){
        backgroundPicture = UIImageJPEGRepresentation(self.imageViewBackground.image, 0.6f); // JPEG
        if (!backgroundPicture) {
            backgroundPicture = UIImagePNGRepresentation(self.imageViewBackground.image); // PNG
        }
    }
    
    // call service here
    [SVProgressHUD showWithStatus:@"Updating"];
    [self.serviceAPI editUserProfileWithFirstname:firstName
                                         lastName:lastName
                                         newEmail:newEmail
                                            phone:phone
                                         userName:userName
                                      deviceToken: deviceToken
                                      description:description
                                          website:website
                                   profilePicture:profilePicture
                                backgroundPicture:backgroundPicture
                                        userEmail:user.email
                                        userToken:user.authentication_token
                                          success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [Infrastructure sharedClient].currentUser = [User objectFromDictionary:responseObject];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Failed: %@", error.description]];
        NSLog(@"Failed: %@", error.description);
    }];
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        case 1:
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    CLImageToolInfo *tonalTool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
    tonalTool.available = NO;
    
    CLImageToolInfo *adjustmentTool = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:NO];
    adjustmentTool.available = NO;
    
    CLImageToolInfo *effectTool = [editor.toolInfo subToolInfoWithToolName:@"CLEffectTool" recursive:NO];
    effectTool.available = NO;
    
    CLImageToolInfo *blurTool = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:NO];
    blurTool.available = NO;
    
    NSArray *array = [editor.toolInfo subtools];
    for (CLImageToolInfo *tool in array) {
        NSLog(@"%@",tool.toolName);
    }
    [picker pushViewController:editor animated:YES];
    
}

#pragma mark - image editor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    if (pictureType == 1) {
        [self.imageViewProfile setImage:image];
        isProfileChanged = YES;
    }
    else if(pictureType == 2) {
        [self.imageViewBackground setImage:image];
        isBackgroundChanged = YES;
    }
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signOut:(id)sender {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Facebook Login Delegate
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    
}

#pragma mark - Instagram Delegate
-(void)instagramLoginSuccessWithToken:(NSString*)accessToken {
    // save token
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:USERDEFAULT_KEY_INSTAGRAM_TOKEN];
    //
    [SVProgressHUD showSuccessWithStatus:@"Success"];
    [self.buttonInstagram setTitle:@"Logout Instagram" forState:UIControlStateNormal];
}

-(void)instagramLoginFail:(NSError*)error {
    [SVProgressHUD showErrorWithStatus:@"Fail"];
}

#pragma mark - Twitter
- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)fetchTimelineForUser
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [SVProgressHUD showWithStatus:@"Loading"];
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             [SVProgressHUD dismiss];
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 [[[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"You\'re having %lu Twitter account, app will automatically use the last account", (unsigned long)twitterAccounts.count] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                 
                 
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
                 [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please allow application use Twitter account in device Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
             }
         }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"You didn\'t set up any Twitter account, please sign in at least 1 on device Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

@end
