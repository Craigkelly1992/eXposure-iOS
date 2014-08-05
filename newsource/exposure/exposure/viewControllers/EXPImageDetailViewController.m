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
        if ([currentPost.image_url rangeOfString:@"placeholder"].location == NSNotFound) {
            [self.imageviewPost setImageURL:[NSURL URLWithString:currentPost.image_url]];
        } else {
            [self.imageviewPost setImage:[UIImage imageNamed:@"placeholder.png"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void) loadPostUser:(NSNumber*)userId {
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

@end
