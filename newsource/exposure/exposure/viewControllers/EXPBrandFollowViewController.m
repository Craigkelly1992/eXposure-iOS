//
//  EXPFollowViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPBrandFollowViewController.h"
#import "User.h"
#import "EXPPortfolioViewController.h"
#import "EXPBrandFollowViewController.h"

@interface EXPBrandFollowViewController ()

@end

@implementation EXPBrandFollowViewController {
    NSArray *arrayData;
    User *currentUser; // user login
    User *userProfile; // user's profile we are watching
    int mode;
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
    //
    self.title = self.brandName;
    //
    currentUser = [Infrastructure sharedClient].currentUser;
    //
    if (self.isFollower) {
        self.segmentOption.selectedSegmentIndex = 0;
    } else {
        self.segmentOption.selectedSegmentIndex = 1;
    }
    // add gesture for removing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.viewContainer setUserInteractionEnabled:YES];
    [self.viewContainer addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    //
    if (self.isFollower) {
        [self loadFollowers];
    } else {
        [self loadWinners];
    }
}

- (void) loadFollowers {
    arrayData = self.arrayFollower;
    [self.collectionViewUser reloadData];
    [self filterUser];
}

- (void) loadWinners {
    arrayData = self.arrayWinner;
    [self.collectionViewUser reloadData];
    [self filterUser];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (arrayData && arrayData.count > 0) {
        self.labelNoItem.hidden = YES;
        self.collectionViewUser.hidden = NO;
        return arrayData.count;
    }
    self.labelNoItem.hidden = NO;
    self.collectionViewUser.hidden = YES;
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FollowCollectionViewCellIdentifier" forIndexPath:indexPath];
    //
    UIImageView *imageViewUserProfile = (UIImageView*)[cell viewWithTag:1];
    UILabel *labelUsername = (UILabel*)[cell viewWithTag:2];
    UIButton *buttonUnfollow = (UIButton*)[cell viewWithTag:3];
    buttonUnfollow.hidden = YES;
    // fill data
    User *user = [arrayData objectAtIndex:indexPath.row];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewUserProfile];
    [imageViewUserProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (user.profile_picture_url_thumb && [user.profile_picture_url_thumb rangeOfString:@"placeholder"].location == NSNotFound) {
        [imageViewUserProfile setImageURL:[NSURL URLWithString:user.profile_picture_url_thumb]];
    }
    //
    labelUsername.text = user.username;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    User *user = [arrayData objectAtIndex:indexPath.row];
    EXPPortfolioViewController *portfolioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPPortfolioViewControllerIdentifier"];
    portfolioVC.profileId = user.userId;
    [self.navigationController pushViewController:portfolioVC animated:YES];
}

#pragma mark - Actions
- (IBAction)segmentValueChanged:(id)sender {
    if (self.segmentOption.selectedSegmentIndex == 0) { // Followers
        
        [self loadFollowers];
    } else { // Winners
        
        [self loadWinners];
    }
}

#pragma mark - SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterUser];
}

- (void) filterUser {
    if ([self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length <= 0) {
        return;
    }
    NSLog(@"SearchBar:textDidChange with text [%@]", self.searchBar.text);
    [self.searchBar resignFirstResponder];
    //
    NSMutableArray *searchResult = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayData.count; i++) {
        User *user = [arrayData objectAtIndex:i];
        if ([user.username rangeOfString:self.searchBar.text].location != NSNotFound) {
            [searchResult addObject:user];
        }
    }
    arrayData = searchResult;
    [self.collectionViewUser reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // for cancel button, not for X clear button
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length <= 0) {
        if (self.segmentOption.selectedSegmentIndex == 0) { // Followers
            
            arrayData = self.arrayFollower;
            [self.collectionViewUser reloadData];
        } else { // Winner
            
            arrayData = self.arrayWinner;
            [self.collectionViewUser reloadData];
        }
    }
}

#pragma mark - Miscellaneous
/**
 * dismiss keyboard
 */
- (void) dismissKeyboard {
    [self.searchBar resignFirstResponder];
    [self filterUser];
}

@end
