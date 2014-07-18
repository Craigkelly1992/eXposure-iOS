//
//  EXPNewPostViewController.m
//  exposure
//
//  Created by stuart on 2014-05-29.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPNewPostViewController.h"
#import "Post.h"
#import "User.h"
#import "SVProgressHUD.h"
@interface EXPNewPostViewController ()<UIGestureRecognizerDelegate> {
    UIImage * _iimage;
    CGFloat keyboardHeight;
    CGRect postBarRect;
    CGRect postBtnRect;
    NSDictionary *_contestAttributes;
}

@end

@implementation EXPNewPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage *)image attributes:(NSDictionary *)dict {
    self = [super init];
    if(self){
        _iimage = image;
        _contestAttributes = dict;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _image.image = _iimage;
    [self setupGestureToDismissKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    postBtnRect = _postBtn.frame;
    postBarRect = _postBar.frame;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGestureToDismissKeyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(_postBar.frame.origin.y != postBarRect.origin.y){
        __block EXPNewPostViewController *weakself = self;
            [UIView animateWithDuration:0.1 animations:^{
                
                weakself.postBar.frame = CGRectMake(0, weakself.view.frame.size.height - weakself.postBar.frame.size.height, weakself.postBar.frame.size.width, weakself.postBar.frame.size.height);
            }];
        
    }

}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    keyboardHeight = keyboardSize.height;
    NSLog(@"%f",keyboardHeight);
    __block EXPNewPostViewController *weakself = self;
    //NSLog(@"%f", );
        [UIView animateWithDuration:0.3 animations:^{

            weakself.postBar.center = CGPointMake(weakself.postBar.center.x, weakself.view.frame.size.height - self->keyboardHeight + 28);
            NSLog(@"%f %f %f", weakself.postBar.center.x, weakself.postBar.center.y, weakself.postBar.frame.size.height);
        }];
}


- (IBAction)postBtn:(id)sender {
    [SVProgressHUD show];
    User *user = [User currentUser];
    NSDictionary *params = @{@"post[contest_id]":_contestAttributes[@"contest_id"],@"post[uploader_id]":user.user_id, @"post[text]":_postText.text, @"user_email":user.email ,@"user_token": user.token, @"post[image_data]": [UIImageJPEGRepresentation(_image.image, 0.6f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] };
    [Post postPostWithAttributes:params image:_image.image Completion:^(NSError *error){
        [SVProgressHUD dismiss];
        if(!error){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
    
}
@end
