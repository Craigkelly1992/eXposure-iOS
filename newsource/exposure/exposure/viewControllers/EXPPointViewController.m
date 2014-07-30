//
//  EXPPointViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPointViewController.h"
#import "User.h"
#import "EXPPortfolioViewController.h"

@interface EXPPointViewController ()

@end

@implementation EXPPointViewController {
    User *currentUser;
    NSMutableArray *arrayFollowing;
    NSMutableArray *arrayGlobal;
    NSMutableArray *arrayData;
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
    arrayFollowing = [[NSMutableArray alloc] init];
    arrayGlobal = [[NSMutableArray alloc] init];
    //
    self.title = @"eXposure Points";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)viewWillAppear:(BOOL)animated {
    [self getFollowingRanking:self.userId];
}

-(void) getFollowingRanking:(NSNumber*)userId {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getFollowingRankingWithUserEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
       
        [SVProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"status"]) {
            // There's no ranking
            arrayFollowing = [[NSMutableArray alloc] init];
            arrayData = arrayFollowing;
            [self.tableViewUser reloadData];
        } else {
            NSArray *array = responseObject;
            arrayFollowing = [[NSMutableArray alloc] init];
            User *user = nil;
            for (int i = 0; i < array.count; i++) {
                user = [User objectFromDictionary:array[i]];
                [arrayFollowing addObject:user];
            }
            arrayData = arrayFollowing;
            [self.tableViewUser reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"Fail"];
    }];
}

-(void) getGlobalRanking:(NSNumber*)userId {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getGlobalRankingWithUserEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"status"]) {
            // There's no ranking
            arrayGlobal = [[NSMutableArray alloc] init];
            arrayData = arrayGlobal;
            [self.tableViewUser reloadData];
        } else {
            NSArray *array = responseObject;
            arrayGlobal = [[NSMutableArray alloc] init];
            User *user = nil;
            for (int i = 0; i < array.count; i++) {
                user = [User objectFromDictionary:array[i]];
                [arrayGlobal addObject:user];
            }
            arrayData = arrayGlobal;
            [self.tableViewUser reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"Fail"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PointTableViewCellIdentifier"];
    }
    // load controls
    UILabel *labelOrder = (UILabel*)[cell viewWithTag:1];
    UIImageView *imageViewProfile = (UIImageView*)[cell viewWithTag:2];
    UILabel *labelUsername = (UILabel*)[cell viewWithTag:3];
    UILabel *labelPoint = (UILabel*)[cell viewWithTag:4];
    UIButton *buttonFollow = (UIButton*)[cell viewWithTag:5];
    // fill data
    User *user = [arrayData objectAtIndex:indexPath.row];
    labelOrder.text = [NSString stringWithFormat:@"%d.", indexPath.row + 1];
    labelUsername.text = user.username;
    labelPoint.text = [NSString stringWithFormat:@"%@Xp", user.cached_score];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewProfile];
    [imageViewProfile setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (user.profile_picture_url && [user.profile_picture_url rangeOfString:@"placeholder"].location == NSNotFound) {
        
        [imageViewProfile setImageURL:[NSURL URLWithString:user.profile_picture_url]];
    }
    //
    if ([user.userId isEqual:currentUser.userId]) {
        buttonFollow.hidden = YES;
    } else {
        buttonFollow.hidden = NO;
    }
    if ([user.current_user_following intValue] == 1) { // true
        [buttonFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_blue_small"] forState:UIControlStateNormal];
        
        
    } else if ([user.current_user_following intValue] == 0) { // false
        [buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
        
    }

    [buttonFollow addTarget:self
                     action:@selector(changeFollow:)
           forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void) changeFollow:(id)sender {
    UIButton *buttonFollow = sender;
    id view = buttonFollow;
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = [view superview];
    }
    UITableViewCell *tableViewCell = view;
    NSIndexPath* indexPath = [self.tableViewUser indexPathForCell:tableViewCell];
    User *user = [arrayData objectAtIndex:indexPath.row];
    //
    [SVProgressHUD showWithStatus:@"Loading"];
    if ([user.current_user_following integerValue] == 0) { // is unfollow
        [self.serviceAPI followUser:user.userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
            
            [SVProgressHUD showSuccessWithStatus:@"Success"];
            [buttonFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
            [buttonFollow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_blue_small"] forState:UIControlStateNormal];
            user.current_user_following = @1;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showSuccessWithStatus:@"Fail"];
        }];
    } else {
        [self.serviceAPI unfollowUser:user.userId userEmail:currentUser.email token:currentUser.authentication_token success:^(id responseObject) {
            
            if (self.segmentOption.selectedSegmentIndex == 1) {
                [SVProgressHUD showSuccessWithStatus:@"Success"];
                [buttonFollow setTitle:@"Follow" forState:UIControlStateNormal];
                [buttonFollow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [buttonFollow setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateNormal];
                user.current_user_following = @0;
            } else {
                [self getFollowingRanking:self.userId];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showSuccessWithStatus:@"Fail"];
        }];
    }
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
    User *user = [arrayData objectAtIndex:indexPath.row];
    EXPPortfolioViewController *portfolioVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPPortfolioViewControllerIdentifier"];
    portfolioVC.profileId = user.userId;
    [self.navigationController pushViewController:portfolioVC animated:YES];
}

- (IBAction)segmentValueChanged:(id)sender {
    if (self.segmentOption.selectedSegmentIndex == 0) { // Following
        
        [self getFollowingRanking:self.userId];
    } else if (self.segmentOption.selectedSegmentIndex == 1) { // Global
        
        [self getGlobalRanking:self.userId];
    }
}
@end
