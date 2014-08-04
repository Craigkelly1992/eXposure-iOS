//
//  EXPBrandViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPBrandViewController.h"
#import "Brand.h"
#import "UIImage+Utility.h"
#import "Submission.h"
#import "EXPImageDetailViewController.h"
#import "Contest.h"
#import "EXPContestDetailViewController.h"

#define kContestHeightMin 33
#define kContestHeightMax 142
#define kFollowHeaderHeight 44
#define kCollectionCellSize 120

@interface EXPBrandViewController ()

@end

@implementation EXPBrandViewController {
    Brand *currentBrand;
    NSMutableArray *arrayContest;
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
}

- (void)viewWillAppear:(BOOL)animated {
    // get info of brand
    [self getBrandInfo];
    // get contests of brand
    [self getContestsFromBrand];
}

-(void) getBrandInfo {
    User *currentUser = [[Infrastructure sharedClient] currentUser];
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getBrandWithId:self.brandId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        currentBrand = [Brand objectFromDictionary:responseObject];
        // fill data to UI
        self.labelBrandName.text = currentBrand.name;
        self.title = currentBrand.name;
        //
        if (currentBrand.picture_url) {
            [self.imageViewBrand setImageURL:[NSURL URLWithString:currentBrand.picture_url]];
        } else {
            self.imageViewBrand.image = [UIImage imageNamed:@"placeholder.png"];
        }
        //
        if (currentBrand.picture_url) {
            [self.imageViewBackground setImageURL:[NSURL URLWithString:currentBrand.picture_url]];
        } else {
            self.imageViewBrand.image = [UIImage imageNamed:@"sample.jpg"];
        }
        //
        self.labelSubmission.text = [NSString stringWithFormat:@"%@", currentBrand.submissions_count];
        //
        [self.collectionViewPost reloadData];
        [self updateScrollView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

-(void) getContestsFromBrand {
    [SVProgressHUD showWithStatus:@"Loading"];
    User *currentUser = [[Infrastructure sharedClient] currentUser];
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

-(void)viewDidLayoutSubviews {
    self.scrollViewHeader.contentSize = CGSizeMake(self.pageControl.numberOfPages*320, self.scrollViewHeader.frame.size.height);
    //
    [self updateScrollView];
}

-(void) updateScrollView {
    // for update tableview
    int numberOfPost = [currentBrand.submissions_count integerValue];
    self.constraintFollowViewHeight.constant = kFollowHeaderHeight + (numberOfPost / 3 + numberOfPost % 3)*kCollectionCellSize;
    // for main scroll view
    int newHeight = self.viewContestContainer.frame.origin.y + self.constraintContestListHeight.constant + self.constraintFollowViewHeight.constant;
    self.scrollviewContainer.contentSize = CGSizeMake(self.scrollviewContainer.frame.size.width, newHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)buttonFollowTap:(id)sender {
}

- (IBAction)buttonXPTap:(id)sender {
}

- (IBAction)buttonFacebookTap:(id)sender {
}

- (IBAction)buttonTwitterTap:(id)sender {
}

- (IBAction)buttonInstagramTap:(id)sender {
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
    Submission *submission = currentBrand.submissions[indexPath.row];
    //
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imagePost];
    imagePost.image = [UIImage imageNamed:@"placeholder.png"];
    if (submission.image_file_name && [submission.image_file_name rangeOfString:@"placeholder.png"].location == NSNotFound) {
        [imagePost setImageURL:[NSURL URLWithString:submission.image_file_name]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Submission *selectedPost = [Submission objectFromDictionary:[currentBrand.submissions objectAtIndex:indexPath.row]];
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
