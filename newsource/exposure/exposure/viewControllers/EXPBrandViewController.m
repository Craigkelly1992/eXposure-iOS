//
//  EXPBrandViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPBrandViewController.h"
#import "Brand.h"
#import "Submission.h"
#import "EXPImageDetailViewController.h"
#import "Contest.h"
#import "EXPContestDetailViewController.h"
#import "EXPBrandFollowViewController.h"

#define kContestHeightMin 33
#define kContestHeightMax 142
#define kFollowHeaderHeight 44
#define kCollectionCellSize 100

@interface EXPBrandViewController ()

@end

@implementation EXPBrandViewController {
    Brand *currentBrand;
    NSMutableArray *arrayContest;
    User *currentUser;
    UIImageView *imageViewBrand;
    UILabel *labelBrandName;
    UITextView *textViewDescription;
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
    self.title = @"";
    arrayContest = [[NSMutableArray alloc] init];
    currentUser = [[Infrastructure sharedClient] currentUser];
    //
    imageViewBrand = [[UIImageView alloc] init];
    CGRect frame1 = CGRectZero;
    frame1.origin.x = 15;
    frame1.origin.y = 53;
    frame1.size.width = 86;
    frame1.size.height = 86;
    imageViewBrand.frame = frame1;
    imageViewBrand.layer.borderWidth = 1.5f;
    imageViewBrand.layer.borderColor = [UIColor whiteColor].CGColor;
    
    labelBrandName = [[UILabel alloc] init];
    CGRect frame2 = CGRectZero;
    frame2.origin.x = 107;
    frame2.origin.y = 106;
    frame2.size.width = 193;
    frame2.size.height = 25;
    labelBrandName.textColor = [UIColor whiteColor];
    labelBrandName.font = [UIFont systemFontOfSize:21];
    labelBrandName.frame = frame2;
    
    textViewDescription = [[UITextView alloc] init];
    CGRect frame3 = CGRectZero;
    frame3.origin.x = 359;
    frame3.origin.y = 38;
    frame3.size.width = 215;
    frame3.size.height = 77;
    textViewDescription.textColor = [UIColor whiteColor];
    textViewDescription.backgroundColor = [UIColor clearColor];
    textViewDescription.textAlignment = NSTextAlignmentCenter;
    textViewDescription.font = [UIFont systemFontOfSize:14];
    textViewDescription.frame = frame3;
    
    self.scrollViewHeader.contentSize = CGSizeMake(2 * self.view.frame.size.width, self.scrollViewHeader.frame.size.height);
    
    [self.scrollViewHeader addSubview:imageViewBrand];
    [self.scrollViewHeader addSubview:labelBrandName];
    [self.scrollViewHeader addSubview:textViewDescription];
    
    // add interaction handler for follower & winner
    // add interaction for follower, following
    UITapGestureRecognizer *followerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewFollowerTap)];
    followerTapGesture.numberOfTapsRequired = 1;
    [self.viewFollowerContainer setGestureRecognizers:[[NSArray alloc] initWithObjects:followerTapGesture, nil]];
    //
    UITapGestureRecognizer *winnerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWinnerTap)];
    winnerTapGesture.numberOfTapsRequired = 1;
    [self.viewWinnerContainer setGestureRecognizers:[[NSArray alloc] initWithObjects:winnerTapGesture, nil]];
    //
}

- (void)viewWillAppear:(BOOL)animated {
    // get info of brand
    [self getBrandInfo];
    // check follow brand
    [self checkFollowBrand];
    // get contests of brand
    [self getContestsFromBrand];
}

- (void)viewDidLayoutSubviews {
    [self updateScrollView];
}

-(void)viewFollowerTap {
    EXPBrandFollowViewController *followerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPBrandFollowViewControllerIdentifier"];
    followerVC.isFollower = YES;
    followerVC.brandName = currentBrand.name;
    followerVC.arrayFollower = currentBrand.followers_list;
    followerVC.arrayWinner = currentBrand.winners;
    [self.navigationController pushViewController:followerVC animated:YES];
}

-(void)viewWinnerTap {
    EXPBrandFollowViewController *winnerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPBrandFollowViewControllerIdentifier"];
    winnerVC.isFollower = NO;
    winnerVC.brandName = currentBrand.name;
    winnerVC.arrayFollower = currentBrand.followers_list;
    winnerVC.arrayWinner = currentBrand.winners;
    [self.navigationController pushViewController:winnerVC animated:YES];
}

// Check if the current user is following the brand
- (void) checkFollowBrand {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI checkFollowBrand:self.brandId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
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
            [self.buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
            [self.buttonFollow addTarget:self
                                  action:@selector(followTap:)
                        forControlEvents:UIControlEventTouchUpInside];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)followTap:(id)sender {
    //
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI followBrand:self.brandId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.buttonFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
        [self.buttonFollow removeTarget:self action:@selector(followTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonFollow addTarget:self
                              action:@selector(unfollowTap:)
                    forControlEvents:UIControlEventTouchUpInside];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"Fail"];
    }];
}

-(void)unfollowTap:(id)sender {
    
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI unfollowBrand:self.brandId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [self.buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [self.buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
        [self.buttonFollow removeTarget:self action:@selector(unfollowTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonFollow addTarget:self
                              action:@selector(followTap:)
                    forControlEvents:UIControlEventTouchUpInside];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"Fail"];
    }];
}

// Get Information from a brand
-(void) getBrandInfo {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getBrandWithId:self.brandId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        currentBrand = [Brand objectFromDictionary:responseObject];
        // fill data to UI
        labelBrandName.text = currentBrand.name;
        textViewDescription.text = currentBrand.mDescription;
        self.title = currentBrand.name;
        //
        if (currentBrand.picture_url) {
            [imageViewBrand setImageURL:[NSURL URLWithString:currentBrand.picture_url]];
        } else {
            imageViewBrand.image = [UIImage imageNamed:@"placeholder.png"];
        }
        //
        if (currentBrand.picture_url) {
            [self.imageViewBackground setImageURL:[NSURL URLWithString:currentBrand.picture_url]];
        } else {
            imageViewBrand.image = [UIImage imageNamed:@"sample.jpg"];
        }
        // submission count
        self.labelSubmission.text = [NSString stringWithFormat:@"%@", currentBrand.submissions_count];
        
        // follower count
        self.labelFollower.text = [NSString stringWithFormat:@"%@", currentBrand.followers_count];
        
        // winner count
        self.labelWinner.text = [NSString stringWithFormat:@"%@", currentBrand.winners_count];
        //
        
        [self.collectionViewPost reloadData];
        [self updateScrollView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

-(void) getContestsFromBrand {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getContestByBrandId:self.brandId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        arrayContest = [[NSMutableArray alloc] init];
        NSArray *array = responseObject;
        Contest *contest = nil;
        for (int i = 0; i < array.count; i++) {
            contest = [Contest objectFromDictionary:array[i]];
            [arrayContest addObject:contest];
        }
        [self.tableViewContest reloadData];
        [self updateScrollView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

-(void) updateScrollView {
    
    // for update tableview
    int numberOfPost = [currentBrand.submissions_count intValue];
    int numRow = numberOfPost / 3;
    if (numberOfPost % 3 != 0) {
        numRow++;
    }
    self.constraintFollowViewHeight.constant = kFollowHeaderHeight + numRow * (kCollectionCellSize + 10); // 10: for spacing between cell
    // for main scroll view
    int newHeight = self.viewContestContainer.frame.origin.y + self.constraintContestListHeight.constant + self.constraintFollowViewHeight.constant;
    self.scrollviewContainer.contentSize = CGSizeMake(self.scrollviewContainer.frame.size.width, newHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonXPTap:(id)sender {
}

- (IBAction)buttonFacebookTap:(id)sender {
    NSURL *facebookURL = [NSURL URLWithString:currentBrand.facebook];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]){
        [[UIApplication sharedApplication] openURL:facebookURL];
    }
}

- (IBAction)buttonTwitterTap:(id)sender {
    NSURL *twitterURL = [NSURL URLWithString:currentBrand.twitter];
    [[UIApplication sharedApplication] openURL:twitterURL];
}

- (IBAction)buttonInstagramTap:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:currentBrand.instagram];
    [[UIApplication sharedApplication] openURL:instagramURL];
}

- (IBAction)buttonContestIndicatorTap:(id)sender {
    if (self.constraintContestListHeight.constant == 140) {
        self.constraintContestListHeight.constant = 33;
        [self.buttonIndicatorContest setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    } else {
        self.constraintContestListHeight.constant = 140;
        [self.buttonIndicatorContest setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    }
    [self updateScrollView];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayContest.count;
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
    if (contest.picture_url_thumb && [contest.picture_url_thumb rangeOfString:@"placeholder.png"].location == NSNotFound) {
        [imageViewContest setImageURL:[NSURL URLWithString:contest.picture_url_thumb]];
    }
    //
    labelContestName.text = contest.title;
    labelContestDescription.text = contest.mDescription;
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

#pragma mark - CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [currentBrand.submissions_count integerValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCellIdentifier" forIndexPath:indexPath];
    UIImageView *imagePost = (UIImageView*)[cell viewWithTag:1];
    //
    Submission *submission = currentBrand.submissions_mobile[indexPath.row];
    //
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imagePost];
    imagePost.image = [UIImage imageNamed:@"placeholder.png"];
    if (submission.image_url_thumb && [submission.image_url_thumb rangeOfString:@"placeholder.png"].location == NSNotFound) {
        [imagePost setImageURL:[NSURL URLWithString:submission.image_url_thumb]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Submission *selectedPost = currentBrand.submissions_mobile[indexPath.row];
    EXPImageDetailViewController *postVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EXPImageDetailViewControllerIdentifier"];
    postVC.postId = selectedPost.submissionId;
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.scrollViewHeader.frame.size.width;
    float xPos = self.scrollViewHeader.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    self.pageControl.currentPage = (int)xPos/width;
}

@end
