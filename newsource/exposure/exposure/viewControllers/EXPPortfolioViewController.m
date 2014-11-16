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
#import <Accounts/Accounts.h>
#import <Social/Social.h>

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
    UIImageView *imageViewProfile;
    UILabel *labelUsername;
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
    self.title = @"Portfolio";
    // post
    currentUser = [Infrastructure sharedClient].currentUser;
    arrayPost = [[NSArray alloc] init];
    
    // add interaction for follower, following
    UITapGestureRecognizer *followerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewFollowerTap)];
    followerTapGesture.numberOfTapsRequired = 1;
    [followerTapGesture setCancelsTouchesInView:NO];
    [self.viewFollower setGestureRecognizers:[[NSArray alloc] initWithObjects:followerTapGesture, nil]];
    //
    UITapGestureRecognizer *followTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewFollowTap)];
    followTapGesture.numberOfTapsRequired = 1;
    [followTapGesture setCancelsTouchesInView:NO];
    [self.viewFollowing setGestureRecognizers:[[NSArray alloc] initWithObjects:followTapGesture, nil]];
    //
    
    imageViewProfile = [[UIImageView alloc] init];
    CGRect frame1 = CGRectZero;
    frame1.origin.x = 15;
    frame1.origin.y = 53;
    frame1.size.width = 86;
    frame1.size.height = 86;
    imageViewProfile.frame = frame1;
    imageViewProfile.layer.borderWidth = 1.5f;
    imageViewProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.buttonSetting setTitle:@"Settings" forState:UIControlStateNormal];
    
    labelUsername = [[UILabel alloc] init];
    CGRect frame2 = CGRectZero;
    frame2.origin.x = 107;
    frame2.origin.y = 106;
    frame2.size.width = 193;
    frame2.size.height = 25;
    labelUsername.textColor = [UIColor whiteColor];
    labelUsername.font = [UIFont systemFontOfSize:21];
    labelUsername.frame = frame2;
    
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
    
    self.pagingView.contentSize = CGSizeMake(2 * self.view.frame.size.width, self.pagingView.frame.size.height);
    
    [self.pagingView addSubview:imageViewProfile];
    [self.pagingView addSubview:labelUsername];
    [self.pagingView addSubview:textViewDescription];
}

- (void)viewWillAppear:(BOOL)animated {
    //
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
        [self.buttonFollow removeTarget:self
                              action:@selector(followTap:)
                    forControlEvents:UIControlEventTouchUpInside];
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
        [self.buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
        [self.buttonFollow removeTarget:self
                                 action:@selector(unfollowTap:)
                       forControlEvents:UIControlEventTouchUpInside];
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
            labelUsername.text = profileUser.username;
            // profile image
            if ([profileUser.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound ) {
                [imageViewProfile setImageURL:[NSURL URLWithString:profileUser.profile_picture_url_thumb]];
            } else {
                [imageViewProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
            }
            // background image
            if ([profileUser.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound ) {
                [self.imageViewBackground setImageURL:[NSURL URLWithString:profileUser.background_picture_url_preview]];
            } else {
                [self.imageViewBackground setImage:[UIImage imageNamed:@"sample.jpg"]];
            }
            // description
            textViewDescription.text = profileUser.mDescription;
            // following, follower, submission count
            self.labelFollowerCount.text = [profileUser.followers_count stringValue];
            self.labelFollowingCount.text = [profileUser.follow_count stringValue];
            self.labelSubmissionCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[profileUser.posts count]];
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
                                    
        // get user's info
        [self getPostByUserId];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"Service Error. Please try again later!"];
        NSLog(@"Error: %@", error.description);
    }];
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
    
    [self.viewFollowContainer updateConstraints];
    [self.viewFollowContainer layoutSubviews];
    [self.scrollViewContainer layoutSubviews];
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
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithAllowLoginUI: YES];
    }
    [SVProgressHUD show];
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            NSURL *safariURL = [NSURL URLWithString:[result objectForKey:@"link"]];
            NSURL *inAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb:///profile/%@", [result objectForKey:@"id"]]];
            if ([[UIApplication sharedApplication] canOpenURL:inAppURL]){
                [[UIApplication sharedApplication] openURL:inAppURL];
            } else {
                [[UIApplication sharedApplication] openURL:safariURL];
            }
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            [SVProgressHUD showErrorWithStatus:@"Service Error. Please try again later!"];
            NSLog(@"Error: %@", error.description);
        }
    }];
    
}
- (IBAction)buttonInstagramTap:(id)sender {
    
    if ([InstagramEngine sharedEngine].accessToken) {
        [SVProgressHUD showWithStatus:@"Loading"];
        [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser *userDetail) {
            
            NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@", userDetail.username]];
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]){
                [[UIApplication sharedApplication] openURL:instagramURL];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://instagram.com/%@", userDetail.username]]];
            }
            
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismiss];
        }];
    } else {
        //
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please signup with an Instagram account in Profile Setting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}
- (IBAction)buttonContestTap:(id)sender {
    
}
- (IBAction)buttonTwitterTap:(id)sender {
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterAccountType =
        [accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [accountStore accountsWithAccountType:twitterAccountType];
                 ACAccount *account = [twitterAccounts lastObject];
                 if (!account) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please signin with an twitter account on Settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                 } else {
                     // open url
                     NSURL *twitterURL = [NSURL URLWithString:[NSString stringWithFormat:@"twitter:///user?screen_name=%@", account.username]];
                     if ([[UIApplication sharedApplication] canOpenURL:twitterURL]){
                         [[UIApplication sharedApplication] openURL:twitterURL];
                     } else {
                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", account.username]]];
                     }
                 }
                 
             }
         }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"You didn\'t set up any Twitter account, please sign in at least 1 on device Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
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
    contestVC.image_url = contest.picture_url;
    contestVC.image_url_preview = contest.picture_url_preview;
    contestVC.image_url_thumb = contest.picture_url_thumb;
    contestVC.image_url_square = contest.picture_url_square;
    [self.navigationController pushViewController:contestVC animated:YES];
}

@end
