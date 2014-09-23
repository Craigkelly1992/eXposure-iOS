//
//  EXPImageDetailViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPImageDetailViewController.h"
#import "Post.h"
#import "ContestDetail.h"
#import "Comment.h"

@interface EXPImageDetailViewController ()

@end

@implementation EXPImageDetailViewController {
    User *currentUser;
    Post *currentPost;
    User *postUser;
    ContestDetail *postContest;
    NSMutableArray *arrayComment;
    CGPoint textFieldCommentOrigin;
    int currentLikeNumber;
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
    // Do any additional setup after loading the view.
    currentUser = [Infrastructure sharedClient].currentUser;
    [SVProgressHUD showWithStatus:@"Loading Post"];
    [self.serviceAPI getPostByPostId:self.postId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        NSLog(@"Current Post: %@", responseObject);
        currentPost = [Post objectFromDictionary:responseObject];
        // get user posted
        [self loadPostUser:currentPost.uploader_id];
        // get contest post in
        [self loadPostContest:currentPost.contest_id];
        // get comments of post
        [self loadPostComment:self.postId];
        // fill data
        self.labelPostName.text = currentPost.text;
        self.title = currentPost.text;
        self.labelTime.text = @"----";
        self.labelXpCount.text = [currentPost.cached_votes_up stringValue];
        if (currentPost.current_user_likes) {
            [self.buttonExposure setBackgroundImage:[UIImage imageNamed:@"expose_btn_selected"] forState:UIControlStateNormal];
        } else {
            [self.buttonExposure setBackgroundImage:[UIImage imageNamed:@"expose_btn"] forState:UIControlStateNormal];
        }
        currentLikeNumber = [currentPost.cached_votes_up integerValue];
        if ([currentPost.image_url rangeOfString:@"placeholder"].location == NSNotFound) {
            [self.imageviewPost setImageURL:[NSURL URLWithString:currentPost.image_url_preview]];
        } else {
            [self.imageviewPost setImage:[UIImage imageNamed:@"placeholder.png"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    //
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void) loadPostUser:(NSNumber*)userId {
    [SVProgressHUD showWithStatus:@"Loading User"];
    [self.serviceAPI getUserWithId:userId email:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        postUser = [User objectFromDictionary:responseObject];
        // fill data
        if ([postUser.profile_picture_file_name rangeOfString:@"placeholder"].location == NSNotFound) {
            [self.imageViewUser setImageURL:[NSURL URLWithString:postUser.profile_picture_file_name]];
        } else {
            [self.imageViewUser setImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        //
        self.labelUsername.text = postUser.username;
        //
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

-(void) loadPostContest:(NSNumber*)contestId {
    [SVProgressHUD showWithStatus:@"Loading Contest"];
    [self.serviceAPI getContestWithContestId:contestId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        postContest = [ContestDetail  objectFromDictionary:responseObject];
        // fill data
        self.labelContestName.text = postContest.contest.info.title;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void) loadPostComment:(NSNumber*)postId {
    [SVProgressHUD showWithStatus:@"Loading Comment"];
    [self.serviceAPI getCommentFromPostId:postId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        NSLog(@"Array Comment: %@", responseObject);
        NSArray *array = responseObject;
        arrayComment = [[NSMutableArray alloc] init];
        Comment *comment = nil;
        for(int i = 0; i < array.count; i++) {
            comment = [Comment objectFromDictionary:array[i]];
            [arrayComment addObject:comment];
        }
        //
        self.labelCommentCount.text = [NSString stringWithFormat:@"%d", arrayComment.count];
        // fill data
        float tableHeight = arrayComment.count * self.tableViewComment.rowHeight;
        //
        CGRect scrollView = self.scrollViewContainer.frame;
        self.scrollViewContainer.contentSize = CGSizeMake(scrollView.size.width, self.tableViewComment.frame.origin.y + tableHeight);
        // load comment
        self.constraintCommentListHeight.constant = tableHeight;
        [self.tableViewComment reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)buttonExposureTap:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading"];
    
    if (!currentPost.current_user_likes) {
        [self.serviceAPI likePostWithPostId:self.postId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
            
            [self likePostHandler:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error: %@", error]];
        }];
    } else {
        [self.serviceAPI unlikePostWithPostId:self.postId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
            
            [self likePostHandler:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Error: %@", error]];
        }];
    }
}

- (void) likePostHandler:(id) responseObject {
    [SVProgressHUD showSuccessWithStatus:@"Success"];
    NSLog(@"Response: [%@] and Like: [%@]", responseObject, [responseObject valueForKey:@"like"]);
    if ([[responseObject valueForKey:@"like"] boolValue] == NO) {
        [self.buttonExposure setBackgroundImage:[UIImage imageNamed:@"expose_btn"] forState:UIControlStateNormal];
    } else {
        [self.buttonExposure setBackgroundImage:[UIImage imageNamed:@"expose_btn_selected"] forState:UIControlStateNormal];
    }
    // load post info again
    [SVProgressHUD showWithStatus:@"Loading Post"];
    [self.serviceAPI getPostByPostId:self.postId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        NSLog(@"Current Post: %@", responseObject);
        currentPost = [Post objectFromDictionary:responseObject];
        self.labelXpCount.text = [currentPost.cached_votes_up stringValue];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (IBAction)buttonCommentTap:(id)sender {
    
}

- (IBAction)buttonShareTap:(id)sender {
    NSURL *imageURL = [NSURL URLWithString:currentPost.image_url];
    [SVProgressHUD showWithStatus:@"Loading"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            UIImage *image = [UIImage imageWithData:imageData];
            NSArray *objectsToShare = [[NSArray alloc] initWithObjects:currentPost.text, image, nil];
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            [self presentViewController:controller animated:YES completion:nil];
        });
    });
}

- (IBAction)buttonSendTap:(id)sender {
    [self dismissKeyboard];
    NSString *commentText = [self.textFieldComment.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if (commentText.length <= 0) {
        
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input comment first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    //
    [SVProgressHUD showWithStatus:@"Sending"];
    [self.serviceAPI createComment:self.postId text:commentText userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.textFieldComment setText:@""];
        [self loadPostComment:self.postId];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"Fail. Please try again later"];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayComment.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCommentTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostCommentTableViewCellIdentifier"];
    }
    //
    UILabel *labelComment = (UILabel*)[cell viewWithTag:1];
    Comment *comment = [arrayComment objectAtIndex:indexPath.row];
    labelComment.text = comment.text;
    // color for cell
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:Rgb2UIColor(255, 122, 98)];
        
    } else {
        [cell setBackgroundColor:Rgb2UIColor(170, 170, 170)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This code is commented out in order to allow users to click on the collection view cells.
}

#pragma mark - Helper
- (void)keyboardWasShown:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float keyboardHeight = keyboardSize.height;
    //NSLog(@"%f", );
    //
    textFieldCommentOrigin = self.scrollViewContainer.contentOffset;
    //
    [UIView animateWithDuration:0.5 animations:^{
        float minY = self.scrollViewContainer.contentOffset.y + self.scrollViewContainer.frame.size.height - keyboardHeight - self.textFieldComment.frame.size.height;
        float deltaY = self.textFieldComment.frame.origin.y - minY;
        NSLog(@"%f",keyboardHeight);
        self.scrollViewContainer.contentOffset = CGPointMake(self.scrollViewContainer.contentOffset.x, self.scrollViewContainer.contentOffset.y + deltaY);
    }];
}

- (void) dismissKeyboard {
    [self.textFieldComment resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollViewContainer.contentOffset = textFieldCommentOrigin;
    }];
}

@end
