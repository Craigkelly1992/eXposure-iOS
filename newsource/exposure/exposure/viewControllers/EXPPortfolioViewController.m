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

#define kContestHeightMin 33
#define kContestHeightMax 142
#define kFollowHeaderHeight 44
#define kCollectionCellSize 120

@interface EXPPortfolioViewController ()

@end

@implementation EXPPortfolioViewController {
    NSArray *arrayPost;
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
    arrayPost = [[NSArray alloc] init];
    // fill user's data
    if ([Infrastructure sharedClient].currentUser) {
        // has login yet
        User *user = [Infrastructure sharedClient].currentUser;
        self.labelUsername.text = user.username;
        // profile image
        if ([user.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound ) {
            [self.imageViewProfile setImageURL:[NSURL URLWithString:user.profile_picture_url]];
        } else {
            [self.imageViewProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        // background image
        if ([user.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound ) {
            [self.imageViewBackground setImageURL:[NSURL URLWithString:user.background_picture_url]];
        } else {
            [self.imageViewBackground setImage:[UIImage imageNamed:@"sample.jpg"]];
        }
        // description
        self.textViewDescription.text = user.description;
        // following, follower, submission count
        self.labelFollowerCount.text = [user.followers_count stringValue];
        self.labelFollowingCount.text = [user.follow_count stringValue];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    // synchronize from server
    if ([Infrastructure sharedClient].currentUser) {
        User *currentUser = [Infrastructure sharedClient].currentUser;
        [SVProgressHUD showWithStatus:@"Loading"];
        [self.serviceAPI getPostByUserId:currentUser.userId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
            
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
}

- (void)viewWillLayoutSubviews {
    
}

-(void)viewDidLayoutSubviews {
    self.pagingView.contentSize = CGSizeMake(self.pageControl.numberOfPages*self.pagingView.frame.size.width, self.pagingView.frame.size.height);
    [self updateScrollView];
}

-(void) updateScrollView {
    // for update tableview
    self.constraintHeightFollowContainer.constant = kFollowHeaderHeight + ([self.collectionViewPost numberOfItemsInSection:0]/3 + 1)*kCollectionCellSize;
    // for main scroll view
    int newHeight = self.viewContestContainer.frame.origin.y + self.constraintHeightContest.constant + kFollowHeaderHeight + ([self.collectionViewPost numberOfItemsInSection:0]/3 + 1) * kCollectionCellSize;
    self.scrollViewContainer.contentSize = CGSizeMake(self.scrollViewContainer.frame.size.width, newHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)buttonXPTap:(id)sender {
    
}
- (IBAction)buttonSettingTap:(id)sender {
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
    
    // test
    return 10;
    //
    if (arrayPost) {
        return [arrayPost count];
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortfolioPostViewCellIdentifier" forIndexPath:indexPath];
    // parse dictionary to Post object
//    Post *post = [Post objectFromDictionary:[arrayPost objectAtIndex:indexPath.row]];
//    // fill to cell
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
//    if ([post.image_url rangeOfString:@"placeholder"].location != NSNotFound ) {
//        [imageView setImageURL:[NSURL URLWithString:post.image_url]];
//    } else {
        [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
//    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContestTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContestTableViewCellIdentifier"];
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

@end
