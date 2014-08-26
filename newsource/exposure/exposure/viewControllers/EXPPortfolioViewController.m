//
//  EXPPortfolioViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPortfolioViewController.h"
#import "EXPPortFolioSettingsViewController.h"
#import "Post.h"
#import "EXPFollowViewController.h"
#import "Contest.h"
#import "EXPContestDetailViewController.h"
#import "EXPPointViewController.h"
#import "EXPImageDetailViewController.h"

#define kContestHeightMin 33
#define kContestHeightMax 142
#define kFollowHeaderHeight 44
#define kCollectionCellSize 100

@interface EXPPortfolioViewController ()

@end

@implementation EXPPortfolioViewController {
    NSArray *arrayPost;
    NSMutableArray *arrayContest;
    User *currentUser;
    User *profileUser;
    NSNumber *userId;
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
    self.title = @"Portfolio";
    // GUI
    self.imageViewProfile.layer.borderWidth = 1.5f;
    self.imageViewProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.buttonSetting setTitle:@"Settings" forState:UIControlStateNormal];
    // post
    currentUser = [Infrastructure sharedClient].currentUser;
    arrayPost = [[NSArray alloc] init];
    // add interaction for follower, following
    UITapGestureRecognizer *followerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewFollowerTap)];
    followerTapGesture.numberOfTapsRequired = 1;
    [self.viewFollower setGestureRecognizers:[[NSArray alloc] initWithObjects:followerTapGesture, nil]];
    //
    UITapGestureRecognizer *followTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewFollowTap)];
    followTapGesture.numberOfTapsRequired = 1;
    [self.viewFollowing setGestureRecognizers:[[NSArray alloc] initWithObjects:followTapGesture, nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.profileId) {
        // there's no profile id, so we're entering our home
        userId = currentUser.userId;
        [self.buttonFollow setTitle:@"Setting" forState:UIControlStateNormal];
        [self.buttonFollow addTarget:self
                              action:@selector(buttonSettingTap:)
                    forControlEvents:UIControlEventTouchUpInside];
    } else {
        userId = self.profileId;
        [self.buttonFollow setTitle:@"" forState:UIControlStateNormal];
        // check if follow/ unfollow
        [SVProgressHUD showWithStatus:@"Loading"];
        [self.serviceAPI checkFollowUser:userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
            
            [SVProgressHUD dismiss];
            if ([[responseObject objectForKey:@"following"] boolValue] == YES) {
                [self.buttonFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
                [self.buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
                [self.buttonFollow addTarget:self
                                 action:@selector(unfollowTap:)
                       forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
                [self.buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
                [self.buttonFollow addTarget:self
                                 action:@selector(followTap:)
                       forControlEvents:UIControlEventTouchUpInside];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
    }
    //
    [self getUserInfo];
    // get user's info
    [self getPostByUserId];
    //
    [self getContestByUserId];
}

-(void)followTap:(id)sender {
    //
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI followUser:userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.buttonFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
        [self.buttonFollow addTarget:self
                         action:@selector(unfollowTap:)
               forControlEvents:UIControlEventTouchUpInside];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"Fail"];
    }];
}

-(void)unfollowTap:(id)sender {

    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI unfollowUser:userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
        [self.buttonFollow addTarget:self
                         action:@selector(followTap:)
               forControlEvents:UIControlEventTouchUpInside];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"Fail"];
    }];
}

-(void) getUserInfo {
    // load user
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getUserWithId:userId email:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        profileUser = [User objectFromDictionary:responseObject];
        // fill user's data
        if (profileUser) {
            // has login yet
            self.labelUsername.text = profileUser.username;
            // profile image
            if ([profileUser.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound ) {
                [self.imageViewProfile setImageURL:[NSURL URLWithString:profileUser.profile_picture_url_thumb]];
            } else {
                [self.imageViewProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            // background image
            if ([profileUser.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound ) {
                [self.imageViewBackground setImageURL:[NSURL URLWithString:profileUser.background_picture_url_preview]];
            } else {
                [self.imageViewBackground setImage:[UIImage imageNamed:@"sample.jpg"]];
            }
            // description
            self.textViewDescription.text = profileUser.description;
            // following, follower, submission count
            self.labelFollowerCount.text = [profileUser.followers_count stringValue];
            self.labelFollowingCount.text = [profileUser.follow_count stringValue];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

-(void) getPostByUserId {

    [SVProgressHUD showWithStatus:@"Loading"];
    arrayPost = [[NSArray alloc] init];
    [self.serviceAPI getPostByUserId:userId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        NSLog(@"%@", responseObject);
        arrayPost = responseObject;
        [self.collectionViewPost reloadData];
        [self updateScrollView];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Can\'t retrieve data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [SVProgressHUD dismiss];
    }];
}

-(void) getContestByUserId {
    
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getContestOfUserId:userId
                              userEmail:currentUser.email
                              userToken:currentUser.authentication_token
                                success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        NSArray *array = responseObject;
        Contest *contest = nil;
        arrayContest = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++) {
            contest = [Contest objectFromDictionary:array[i]];
            [arrayContest addObject:contest];
        }
        [self.tableViewContest reloadData];
        if (arrayContest.count <= 0) {
            // hide contest
            self.constraintHeightContest.constant = kContestHeightMin;
            [self.buttonIndicatorContest setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        }
        [self updateScrollView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

-(void)viewDidLayoutSubviews {
    self.pagingView.contentSize = CGSizeMake(self.pageControl.numberOfPages*self.pagingView.frame.size.width, self.pagingView.frame.size.height);
    [self updateScrollView];
}

-(void) updateScrollView {
    // for update tableview
    int numRow = arrayPost.count / 3;
    if (arrayPost.count % 3 != 0) {
        numRow++;
    }
    self.constraintHeightFollowContainer.constant = kFollowHeaderHeight +  numRow *(kCollectionCellSize + 10);
    // for main scroll view
    int newHeight = self.viewContestContainer.frame.origin.y + self.constraintHeightContest.constant + self.constraintHeightFollowContainer.constant;
    self.scrollViewContainer.contentSize = CGSizeMake(self.scrollViewContainer.frame.size.width, newHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)buttonXPTap:(id)sender {
    EXPPointViewController *pointVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPPointViewControllerIdentifier"];
    pointVC.userId = userId;
    [self.navigationController pushViewController:pointVC animated:YES];
}

- (void)buttonSettingTap:(id)sender {
    EXPPortFolioSettingsViewController *portfolioSettingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPPortFolioSettingsViewControllerIdentifier"];
    [self.navigationController pushViewController:portfolioSettingVC animated:YES];
}
- (IBAction)buttonFacebookTap:(id)sender {
    
}
- (IBAction)buttonInstagramTap:(id)sender {
    
}
- (IBAction)buttonContestTap:(id)sender {
    
}
- (IBAction)buttonFollowTap:(id)sender {
    
}
- (IBAction)buttonTwitterTap:(id)sender {
    
}

- (IBAction)buttonIndicatorContestTap:(id)sender {
    if (self.constraintHeightContest.constant >= kContestHeightMax) {
        self.constraintHeightContest.constant = kContestHeightMin;
        [self.buttonIndicatorContest setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    } else {
        self.constraintHeightContest.constant = kContestHeightMax;
        [self.buttonIndicatorContest setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    }
    [self updateScrollView];
}

-(void)viewFollowerTap {
    EXPFollowViewController *followVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPFollowViewControllerIdentifier"];
    followVC.isFollowing = NO;
    followVC.userId = userId;
    [self.navigationController pushViewController:followVC animated:YES];
}

-(void)viewFollowTap {
    EXPFollowViewController *followVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPFollowViewControllerIdentifier"];
    followVC.isFollowing = YES;
    followVC.userId = userId;
    [self.navigationController pushViewController:followVC animated:YES];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.pagingView.frame.size.width;
    float xPos = self.pagingView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    self.pageControl.currentPage = (int)xPos/width;
}

#pragma mark - CollectionView datasource & delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (arrayPost) {
        return [arrayPost count];
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortfolioPostViewCellIdentifier" forIndexPath:indexPath];
    // parse dictionary to Post object
    Post *post = [Post objectFromDictionary:[arrayPost objectAtIndex:indexPath.row]];
    // fill to cell
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (post.image_url_thumb && [post.image_url_thumb rangeOfString:@"placeholder"].location == NSNotFound ) {
        [imageView setImageURL:[NSURL URLWithString:post.image_url_thumb]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Post *post = [Post objectFromDictionary:[arrayPost objectAtIndex:indexPath.row]];
    EXPImageDetailViewController *postVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EXPImageDetailViewControllerIdentifier"];
    postVC.postId = post.postId;
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayContest count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContestTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContestTableViewCellIdentifier"];
    }
    // fill data
    Contest *contest = arrayContest[indexPath.row];
    UIImageView *imageViewContest = (UIImageView*)[cell viewWithTag:1];
    UILabel *labelContestName = (UILabel*)[cell viewWithTag:2];
    UILabel *labelContestDescription = (UILabel*)[cell viewWithTag:3];
    //
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewContest];
    [imageViewContest setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (contest.picture_url && [contest.picture_url rangeOfString:@"placeholder.png"].location == NSNotFound) {
        [imageViewContest setImageURL:[NSURL URLWithString:contest.picture_url]];
    }
    //
    labelContestName.text = contest.title;
    labelContestDescription.text = contest.description;
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
    // go to contest
    Contest *contest = arrayContest[indexPath.row];
    EXPContestDetailViewController *contestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPContestDetailViewControllerIdentifier"];
    contestVC.contestId = contest.contestId;
    [self.navigationController pushViewController:contestVC animated:YES];
}

@end
