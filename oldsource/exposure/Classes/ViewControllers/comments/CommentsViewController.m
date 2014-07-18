//
//  CommentsViewController.m
//  exposure
//
//  Created by stuart on 2014-06-12.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "CommentsViewController.h"
#import "EXPCommentCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
@interface CommentsViewController ()<UIGestureRecognizerDelegate>{
    CGFloat keyboardHeight;
    CGRect postBarRect;
    CGRect postBtnRect;
}

@end

@implementation CommentsViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    postBarRect = _postBar.frame;
    [self.navigationController.navigationBar setTranslucent:NO];

    
    [self.view setBackgroundColor:[UIColor colorWithRed:149.0f/255.0f green:209.0f/255.0f blue:197.0f/255.0f alpha:1]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self setupGestureToDismissKeyboard];
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_post commentsWithCompletion:nil];
    
}

-(void)setupGestureToDismissKeyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(_postBar.frame.origin.y != postBarRect.origin.y){
        __block CommentsViewController *weakself = self;
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
    __block CommentsViewController *weakself = self;
    [self.view bringSubviewToFront:_postBar];
    [UIView animateWithDuration:0.3 animations:^{
    
        weakself.postBar.center = CGPointMake(weakself.postBar.center.x, weakself.view.frame.size.height - self->keyboardHeight + 28);
        NSLog(@"%f %f %f", weakself.postBar.center.x, weakself.postBar.center.y, weakself.postBar.frame.size.height);
    }];
}

- (IBAction)postBtn:(id)sender {
    [SVProgressHUD showWithStatus:@"Posting Comment"];
    [Comment postComment:_textField.text ForPostID:_post.post_id completion:^(NSError *error){
        if(!error){
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CommentCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"EXPCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:simpleTableIdentifier];
    EXPCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        cell = [[EXPCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    // cell.textLabel.text = @"lolol";
    // Configure the cell...
    
    return cell;
}


@end
