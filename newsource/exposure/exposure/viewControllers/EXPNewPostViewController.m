//
//  EXPNewPostViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/18/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPNewPostViewController.h"

@interface EXPNewPostViewController ()

@end

@implementation EXPNewPostViewController {
    CGRect postBarRect;
    float keyboardHeight;
}

#pragma mark - Life Cycle
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
    // Do any additional setup after loading the view.
    self.title = @"Create Post";
    //
    [self setupGestureToDismissKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    postBarRect = self.viewDescription.frame;
}

- (void)viewWillAppear:(BOOL)animated {
    self.imageViewPost.image = self.imagePost;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)buttonSendTap:(id)sender {
    [SVProgressHUD showWithStatus:@"Creating Post"];
    User *user = [Infrastructure sharedClient].currentUser;
    [self.serviceAPI createPostWithContestId:self.contestId
                                  uploaderId:user.userId
                                        text:self.textFieldPostDescription.text
                                   imageData:[UIImageJPEGRepresentation(self.imagePost, 0.6f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] userEmail:user.email
                                   userToken:user.authentication_token
                                     success:^(id responseObject) {
                          
                                        [SVProgressHUD showSuccessWithStatus:@"Success"];
                                        [self.navigationController popViewControllerAnimated:YES];
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                      }];
}

#pragma mark - Helper
-(void)setupGestureToDismissKeyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(self.viewDescription.frame.origin.y != postBarRect.origin.y){
        __block EXPNewPostViewController *weakself = self;
        [UIView animateWithDuration:0.1 animations:^{
            weakself.constraintViewDescriptionBottom.constant = 0;
        }];
    }
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;
    __block EXPNewPostViewController *weakself = self;
    //NSLog(@"%f", );
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"%f",keyboardHeight);
        weakself.constraintViewDescriptionBottom.constant = keyboardHeight;
    }];
}

@end
