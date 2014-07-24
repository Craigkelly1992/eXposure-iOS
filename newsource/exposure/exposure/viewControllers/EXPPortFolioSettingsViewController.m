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
@interface EXPPortFolioSettingsViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate> {
    int pictureType;
}

@end

@implementation EXPPortFolioSettingsViewController {
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
    [self.scrollViewContainer setContentSize:CGSizeMake(self.view.frame.size.width, 586)];
}

- (void)viewWillAppear:(BOOL)animated {
    User *currentUser = [Infrastructure sharedClient].currentUser;
    // fill data
    self.textFieldFirstname.text = currentUser.first_name;
    self.textFieldLastname.text = currentUser.last_name;
    self.textFieldEmail.text = currentUser.email;
    self.textFieldPhone.text = currentUser.phone;
    self.textFieldUsername.text = currentUser.username;
    self.textFieldDescription.text = currentUser.description;
    self.textFieldWebsite.text = @"";
    [self.imageViewProfile setImageURL:[NSURL URLWithString:currentUser.profile_picture_url]];
    [self.imageViewBackground setImageURL:[NSURL URLWithString:currentUser.background_picture_url]];
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

- (IBAction)changePassword:(id)sender {
    
    EXPChangePasswordViewController *changePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPChangePasswordViewControllerIdentifier"];
    [self.navigationController pushViewController:changePasswordVC animated:YES];
}

-(void)doneEditing{
    User *user = [Infrastructure sharedClient].currentUser;
    NSData *profilePicture;
    NSData *backgroundPicture;
    if (![self.textFieldFirstname.text isEqualToString:@""]) {
        user.first_name = self.textFieldFirstname.text;
    }
    if(![self.textFieldLastname.text isEqualToString:@""]){
        user.last_name = self.textFieldLastname.text;
    }
    if(![self.textFieldEmail.text isEqualToString:@""]){
        user.email = self.textFieldEmail.text;
    }
    if(![self.textFieldPhone.text isEqualToString:@""]){
        user.phone = self.textFieldPhone.text;
    }
    if(![self.textFieldUsername.text isEqualToString:@""]){
        user.username = self.textFieldUsername.text;
    }
    if(self.imageViewProfile.image != nil){
        profilePicture = UIImagePNGRepresentation(self.imageViewProfile.image);
    }
    if(self.imageViewBackground.image != nil){
        backgroundPicture = UIImagePNGRepresentation(self.imageViewBackground.image);
    }
    
    // call service here
    [SVProgressHUD showWithStatus:@"Updating"];
    [self.serviceAPI editUserProfileWithUser:user
                              profilePicture:profilePicture
                           backgroundPicture:backgroundPicture
                                     success:^(id responseObject) {
        
         [SVProgressHUD showSuccessWithStatus:@"Success"];
         [Infrastructure sharedClient].currentUser = [User objectFromDictionary:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Failed"];
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
        self.imageViewProfile.image = image;
    }
    else if(pictureType == 2) {
        self.imageViewBackground.image = image;
    }
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signOut:(id)sender {
    // TODO: signout here
}
@end
