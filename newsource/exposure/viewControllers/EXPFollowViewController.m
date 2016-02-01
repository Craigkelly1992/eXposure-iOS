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
#import "PPiFlatSegmentedControl.h"

@interface EXPFollowViewController ()

@end

@implementation EXPFollowViewController {
    NSMutableArray *arrayFollowing;
    NSMutableArray *arrayFollower;
    NSMutableArray *arrayData;
    User *currentUser; // user login
    User *userProfile; // user's profile we are watching
    NSMutableArray* current_user_following;
    int mode;
    PPiFlatSegmentedControl *segmented;
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
    
    // add gesture for removing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setCancelsTouchesInView:NO];
    [self.viewContainer setUserInteractionEnabled:YES];
    [self.viewContainer addGestureRecognizer:tapGesture];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // load user
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getUserWithId:self.userId email:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        [SVProgressHUD dismiss];
        userProfile = [User objectFromDictionary:responseObject];
        self.title = userProfile.username;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
    /////
    NSArray *items = @[[[PPiFlatSegmentItem alloc] initWithTitle:@"Following" andIcon:nil],
                       [[PPiFlatSegmentItem alloc] initWithTitle:@"Followers" andIcon:nil]];
    segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:self.segmentOption.frame items:items
                                                iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
                                                    
                                                    [self segmentValueChanged:segmentIndex];
                                                    
                                                } iconSeparation:0.0f];
    segmented.color=[UIColor colorWithRed:4.0f/255.0 green:45.0f/255.0 blue:104.0f/255.0 alpha:1];
    segmented.borderWidth=0;
    segmented.borderColor=[UIColor darkGrayColor];
    segmented.selectedColor=[UIColor colorWithRed:237.0f/255.0 green:189.0f/255.0 blue:42.0f/255.0 alpha:1];
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:11],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:11],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.view addSubview:segmented];
    
    //
    if (self.isFollowing) {
        [segmented setSegmentAtIndex:0 enabled:YES];
    } else {
        [segmented setSegmentAtIndex:1 enabled:YES];
    }
    
    //
    if (self.userId && [segmented isSelectedSegmentAtIndex:0]) {
        [self loadFollowingUser:self.userId];
    } else if (self.userId && [segmented isSelectedSegmentAtIndex:1]) {
        [self loadFollowerUser:self.userId];
    }
}

#pragma mark - Segment
- (void)segmentValueChanged:(NSUInteger) segmentIndex {
    
    if (segmentIndex == 0) { // Following
        [self loadFollowingUser:self.userId];
    } else { // Follower
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
        NSMutableArray *currUserFollowing = [[NSMutableArray alloc] init];

        for (int i = 0; i < array.count; i++) {
            user = [User objectFromDictionary:array[i]];
            [arrayFollower addObject:user];
            [currUserFollowing addObject:user.current_user_following];
        }
        arrayData = arrayFollower;
        current_user_following = currUserFollowing;
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
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
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
    UIImageView *imageViewUserProfile = (UIImageView*)[cell viewWithTag:3];
    UILabel *labelUsername = (UILabel*)[cell viewWithTag:2];
    UIButton *buttonUnfollow = (UIButton*)[cell viewWithTag:1];
    //buttonUnfollow.tag = indexPath.row;
    [buttonUnfollow addTarget:self
                       action:@selector(unfollowTap:event:)
       forControlEvents:UIControlEventTouchUpInside];
    // fill data
    User *user = [arrayData objectAtIndex:indexPath.row];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewUserProfile];
    [imageViewUserProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (user.profile_picture_url_thumb && [user.profile_picture_url_thumb rangeOfString:@"placeholder"].location == NSNotFound) {
        [imageViewUserProfile setImageURL:[NSURL URLWithString:user.profile_picture_url_thumb]];
    }
    if ([segmented isSelectedSegmentAtIndex:0]) { // Following
        buttonUnfollow.hidden = NO;
    } else {
        NSInteger index = indexPath.row;
        NSString *value = [current_user_following objectAtIndex:index];
        if([value boolValue]){
            buttonUnfollow.hidden = NO;
        }else{
            buttonUnfollow.hidden = YES;
        }
    }
    //
    labelUsername.text = user.username;
    return cell;
}

-(void)unfollowTap:(id)sender event:(id) event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.collectionViewUser];
    
    NSIndexPath *buttonCellIndexPath = [self.collectionViewUser indexPathForItemAtPoint:currentTouchPosition];
    NSInteger index = buttonCellIndexPath.row;
    
    User *user = [arrayData objectAtIndex:index];
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI unfollowUser:user.userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [arrayFollowing removeObject:user];
        if (self.userId && [segmented isSelectedSegmentAtIndex:0]) {
            [self loadFollowingUser:self.userId];
        } else if (self.userId && [segmented isSelectedSegmentAtIndex:1]) {
            [self loadFollowerUser:self.userId];
        }
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
//- (IBAction)segmentValueChanged:(id)sender {
//    if (self.segmentOption.selectedSegmentIndex == 0) { // Following
//        [self loadFollowingUser:self.userId];
//    } else { // Follower
//        [self loadFollowerUser:self.userId];
//    }
//}

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
        if ([segmented isSelectedSegmentAtIndex:0]) { // Following
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
