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
        currentPost = [Post objectFromDictionary:responseObject];
        // get user posted
        [self loadPostUser:currentPost.uploader_id];
        // get contest post in
        [self loadPostContest:currentPost.contest_id];
        // get comments of post
        [self loadPostComment:currentPost.postId];
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
        NSArray *array = responseObject;
        arrayComment = [[NSMutableArray alloc] init];
        Comment *comment = nil;
        for(int i = 0; i < array.count; i++) {
            comment = [Comment objectFromDictionary:array[i]];
            [arrayComment addObject:comment];
        }
        // fill data
        self.labelCommentCount.text = [NSString stringWithFormat:@"%d", arrayComment.count];
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
@end
