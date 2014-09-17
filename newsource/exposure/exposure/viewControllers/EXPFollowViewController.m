//
//  EXPFollowViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPFollowViewController.h"
#import "User.h"
#import "EXPPortfolioViewController.h"

@interface EXPFollowViewController ()

@end

@implementation EXPFollowViewController {
    NSMutableArray *arrayFollowing;
    NSMutableArray *arrayFollower;
    NSMutableArray *arrayData;
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
    // Do any additional setup after loading the view.
    arrayFollowing = [[NSMutableArray alloc] init];
    arrayFollower = [[NSMutableArray alloc] init];
    //
    currentUser = [Infrastructure sharedClient].currentUser;
    //
    if (self.isFollowing) {
        self.segmentOption.selectedSegmentIndex = 0;
    } else {
        self.segmentOption.selectedSegmentIndex = 1;
    }
    // add gesture for removing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setCancelsTouchesInView:NO];
    [self.viewContainer setUserInteractionEnabled:YES];
    [self.viewContainer addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    // load user
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getUserWithId:self.userId email:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        userProfile = [User objectFromDictionary:responseObject];
        self.title = userProfile.username;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
    //
    if (self.userId && self.isFollowing) {
        [self loadFollowingUser:self.userId];
    } else if (self.userId && !self.isFollowing) {
        [self loadFollowerUser:self.userId];
    }
}

- (void) loadFollowingUser:(NSNumber*)userId {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getFollowingWithUserId:userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        NSArray *array = responseObject;
        arrayFollowing = [[NSMutableArray alloc] init];
        User *user = nil;
        for (int i = 0; i < array.count; i++) {
            user = [User objectFromDictionary:array[i]];
            [arrayFollowing addObject:user];
        }
        arrayData = arrayFollowing;
        [self.collectionViewUser reloadData];
        [self filterUser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void) loadFollowerUser:(NSNumber*)userId {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getFollowerWithUserId:userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        NSArray *array = responseObject;
        arrayFollower = [[NSMutableArray alloc] init];
        User *user = nil;
        for (int i = 0; i < array.count; i++) {
            user = [User objectFromDictionary:array[i]];
            [arrayFollower addObject:user];
        }
        arrayData = arrayFollower;
        [self.collectionViewUser reloadData];
        [self filterUser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
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
    buttonUnfollow.tag = indexPath.row;
    [buttonUnfollow addTarget:self
                 action:@selector(unfollowTap:)
       forControlEvents:UIControlEventTouchUpInside];
    // fill data
    User *user = [arrayData objectAtIndex:indexPath.row];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewUserProfile];
    [imageViewUserProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (user.profile_picture_url && [user.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound) {
        [imageViewUserProfile setImageURL:[NSURL URLWithString:user.profile_picture_url]];
    }
    if (self.segmentOption.selectedSegmentIndex == 1) { // Follower
        buttonUnfollow.hidden = YES;
    } else {
        buttonUnfollow.hidden = NO;
    }
    //
    labelUsername.text = user.username;
    return cell;
}

-(void)unfollowTap:(id)sender {
    UIButton *buttonFollow = sender;
    int index = buttonFollow.tag;
    User *user = [arrayData objectAtIndex:index];
    //
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI unfollowUser:user.userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [arrayFollowing removeObject:user];
        [self.collectionViewUser reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"Fail"];
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    User *user = [arrayData objectAtIndex:indexPath.row];
    EXPPortfolioViewController *portfolioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPPortfolioViewControllerIdentifier"];
    portfolioVC.profileId = user.userId;
    [self.navigationController pushViewController:portfolioVC animated:YES];
}

#pragma mark - Actions
- (IBAction)segmentValueChanged:(id)sender {
    if (self.segmentOption.selectedSegmentIndex == 0) { // Following
        
        [self loadFollowingUser:self.userId];
    } else { // Follower
        
        [self loadFollowerUser:self.userId];
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
        if (self.segmentOption.selectedSegmentIndex == 0) { // Following
            
            arrayData = arrayFollowing;
            [self.collectionViewUser reloadData];
        } else { // Follower
            
            arrayData = arrayFollower;
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
