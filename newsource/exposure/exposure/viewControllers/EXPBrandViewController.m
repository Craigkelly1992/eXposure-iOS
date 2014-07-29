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

#define kContestHeightMin 33
#define kContestHeightMax 142
#define kFollowHeaderHeight 44
#define kCollectionCellSize 120

@interface EXPBrandViewController ()

@end

@implementation EXPBrandViewController {
    Brand *currentBrand;
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
}

- (void)viewWillAppear:(BOOL)animated {
    User *currentUser = [[Infrastructure sharedClient] currentUser];
    [SVProgressHUD show];
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
    self.constraintFollowViewHeight.constant = kFollowHeaderHeight + ([self.collectionViewPost numberOfItemsInSection:0]/3 + 1)*kCollectionCellSize;
    // for main scroll view
    int newHeight = self.viewContestContainer.frame.origin.y + self.constraintContestListHeight.constant + kFollowHeaderHeight + ([self.collectionViewPost numberOfItemsInSection:0]/3 + 1) * kCollectionCellSize;
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

#pragma mark - CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCellIdentifier" forIndexPath:indexPath];
    UIImageView *imagePost = (UIImageView*)[cell viewWithTag:1];
    imagePost.image = [UIImage imageNamed:@"placeholder.png"];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
