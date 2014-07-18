//
//  EXPPortFolioSettingsViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPPortFolioSettingsViewController.h"
#import "EXPChangePasswordViewController.h"
#import "User.h"
#import "CLImageEditor.h"
#import "Brand.h"
#import "Post.h"
#import "EXPLoginViewController.h"
#import "Contest.h"
#import "CoreData+MagicalRecord.h"
@interface EXPPortFolioSettingsViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate> {
    int pictureType;
}

@end

@implementation EXPPortFolioSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)uploadProfile:(id)sender {
    pictureType = 1;
    [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil]showInView:self.view];

}
- (IBAction)uploadBackground:(id)sender {
    pictureType = 2;
    [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil]showInView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Portfolio Settings";
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 568)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing)];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // _firstNameField.text = [Use]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePassword:(id)sender {

    EXPChangePasswordViewController *vc = [[EXPChangePasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)doneEditing{
      NSMutableDictionary *mDict = [[NSMutableDictionary alloc]init];
    if (![_firstNameField.text isEqualToString:@""]) {
            [mDict setObject:_firstNameField.text forKey:@"user[first_name]"];
    }
    if(![_lastNameField.text isEqualToString:@""]){
            [mDict setObject:_firstNameField.text forKey:@"user[last_name]"];
    }
    if(![_emailField.text isEqualToString:@""]){
            [mDict setObject:_emailField.text forKey:@"user[email"];
    }
    if(![_phoneField.text isEqualToString:@""]){
            [mDict setObject:_emailField.text forKey:@"user[phone"];
    }
    if(![_usernameField.text isEqualToString:@""]){
            [mDict setObject:_usernameField forKey:@""];
    }
    if(_profilePicture.image != nil){
        [mDict setObject:[UIImagePNGRepresentation(_profilePicture.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] forKey:@"user[profile_picture"];
    }
    if(_backgroundImage.image != nil){
        [mDict setObject:[UIImagePNGRepresentation(_backgroundImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] forKey:@"user[backdrop_picture"];
    }

    [mDict setObject:[User currentUser].token forKey:@"user_token"];
    [mDict setObject:[User currentUser].email forKey:@"user_email"];
   // NSDictionary *dict = @{@"user[first_name": _firstNameField.text, @"user[last_name]":_lastNameField.text, @"user[email]":_emailField.text, @"user[phone]": _phoneField.text, @"user[username]":_usernameField.text, @"user[profile_picture": [UIImagePNGRepresentation(_profilePicture.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength], @"user[backdrop_picture]":[UIImagePNGRepresentation(_backgroundImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]};
    [User editUserProfileWithAttributes:[NSDictionary dictionaryWithDictionary:mDict] completion:^(User *user, NSError *error){
        if(!error){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            NSLog(@"%@", error);
        }
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
        _profilePicture.image = image;
    }
    else if(pictureType == 2) {
        _backgroundImage.image = image;
    }
    
    //EXPNewPostViewController *vc = [[EXPNewPostViewController alloc]initWithImage:image attributes:@{@"contest_id": _contest.contest_id}];
    
    //[self.navigationController pushViewController:vc animated:YES];
    [editor dismissViewControllerAnimated:YES completion:nil];
}





- (IBAction)signOut:(id)sender {
    [User MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [Post MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [Brand MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [Contest MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error){
        EXPLoginViewController *vc = [[EXPLoginViewController alloc]init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
        [self removeFromParentViewController];
    }];
    
  
  
    
}
@end
