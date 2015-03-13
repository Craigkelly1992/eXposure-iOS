//
//  EXPContestsViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPContestsViewController.h"
#import "Contest.h"
#import "EXPContestDetailViewController.h"
#import "Util.h"

@interface EXPContestsViewController ()

@end

@implementation EXPContestsViewController {
    NSMutableArray *arrayAll;
    NSMutableArray *arrayFollowing;
    NSArray *arrayContest;
    NSIndexPath *selectedIndexPath;
    User *currentUser;
    NSString *currentDateTime;
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
    self.title = @"Contests";
    if(![Infrastructure sharedClient].currentUser){
        self.segmentOption.selectedSegmentIndex = 1;
    }
    // get all contest
    currentUser = [Infrastructure sharedClient].currentUser;
    arrayContest = [[NSArray alloc] init];
    // add gesture for removing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setCancelsTouchesInView:NO];
    [self.viewBelow setUserInteractionEnabled:YES];
    [self.viewBelow addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    currentDateTime = [[Util sharedUtil] getCurrentSystemDateString];
    self.labelNoItem.hidden = YES;
    if (self.segmentOption.selectedSegmentIndex == 0) { // Following
        
        [self loadFollowingContest];
    } else if (self.segmentOption.selectedSegmentIndex == 1) { // All
        [self loadAllContest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segment Delegate
- (IBAction)segmentValueChanged:(id)sender {
    if (self.segmentOption.selectedSegmentIndex == 0) { // Following
        if(![Infrastructure sharedClient].currentUser){
            // back to login screen
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
        }else{
            [self loadFollowingContest];
        }

    } else if (self.segmentOption.selectedSegmentIndex == 1) { // All
        [self loadAllContest];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrayContest && arrayContest.count > 0) {
        self.labelNoItem.hidden = YES;
        self.tableViewContest.hidden = NO;
        return [arrayContest count];
    }
    self.labelNoItem.hidden = NO;
    self.tableViewContest.hidden = YES;
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContestTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContestTableViewCellIdentifier"];
    }
    // load view
    UIImageView *imageViewLeft = (UIImageView*)[cell viewWithTag:1];
    UILabel *labelContestName = (UILabel*)[cell viewWithTag:2];
    UILabel *labelContestDetail = (UILabel*)[cell viewWithTag:3];
    UIImageView *imageViewRight = (UIImageView*)[cell viewWithTag:4];
    // fill data
    NSInteger reverseOrder = arrayContest.count - 1 - indexPath.row;
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:reverseOrder]];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewLeft];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewRight];
    // compare start & end to show available
    if ([contest.start_date caseInsensitiveCompare:currentDateTime] == NSOrderedAscending &&
        [contest.end_date caseInsensitiveCompare:currentDateTime] == NSOrderedDescending) {
        
        imageViewRight.hidden = NO;
    } else {
        imageViewRight.hidden = YES;
    }
    //
    [imageViewLeft setImage:[UIImage imageNamed:@"placeholder.png"]];
    if ([contest.picture_url_thumb rangeOfString:@"placeholder"].location == NSNotFound ) {
        [imageViewLeft setImageURL:[NSURL URLWithString:contest.picture_url_thumb]];
    }
    //
//    [imageViewRight setImage:[UIImage imageNamed:@"placeholder.png"]];
//    if ([contest.picture_url_thumb rangeOfString:@"placeholder"].location == NSNotFound ) {
//        [imageViewRight setImageURL:[NSURL URLWithString:contest.picture_url_thumb]];
//    }
    //
    labelContestName.text = contest.title;
    labelContestDetail.text = contest.brand_name;
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

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndexPath = indexPath;
    return indexPath;
}

#pragma mark - Load Data
- (void) loadAllContest {
    [SVProgressHUD showWithStatus:@"Loading"];
    arrayAll = [[NSMutableArray alloc] init];
    [self.serviceAPI getAllContestWithUserEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        arrayAll = responseObject;
        arrayContest = arrayAll;
        if (arrayContest.count <= 0) {
            self.labelNoItem.hidden = NO;
            self.tableViewContest.hidden = YES;
        } else {
            self.labelNoItem.hidden = YES;
            self.tableViewContest.hidden = NO;
        }
        [self.tableViewContest reloadData];
        [self filterContest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void) loadFollowingContest {
    [SVProgressHUD showWithStatus:@"Loading"];
    arrayFollowing = [[NSMutableArray alloc] init];
    [self.serviceAPI getContestByFollowingUserId:currentUser.userId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        arrayFollowing = responseObject;
        arrayContest = arrayFollowing;
        if (arrayContest.count <= 0) {
            self.labelNoItem.hidden = NO;
            self.tableViewContest.hidden = YES;
        } else {
            self.labelNoItem.hidden = YES;
            self.tableViewContest.hidden = NO;
        }
        [self.tableViewContest reloadData];
        [self filterContest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    EXPContestDetailViewController *contestDetailVC = segue.destinationViewController;
    NSInteger reverseOrder = arrayContest.count - 1 - selectedIndexPath.row;
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:reverseOrder]];
    contestDetailVC.contestId = contest.contestId;
    contestDetailVC.image_url = contest.picture_url;
    contestDetailVC.image_url_thumb = contest.picture_url_thumb;
    contestDetailVC.image_url_square = contest.picture_url_square;
    contestDetailVC.image_url_preview = contest.picture_url_preview;
}

#pragma mark - SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterContest];
}

- (void)filterContest {
    if ([self.searchBarContest.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length <= 0) {
        return;
    }
    NSLog(@"SearchBar:textDidChange with text [%@]", self.searchBarContest.text);
    [self.searchBarContest resignFirstResponder];
    //
    NSMutableArray *searchResult = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrayContest.count; i++) {
        Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:i]];
        if ([contest.title rangeOfString:self.searchBarContest.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [searchResult addObject:arrayContest[i]];
        }
    }
    arrayContest = searchResult;
    [self.tableViewContest reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // for cancel button, not for X clear button
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length <= 0) {
        if (self.segmentOption.selectedSegmentIndex == 0) { // Following
            
            arrayContest = arrayFollowing;
            [self.tableViewContest reloadData];
        } else { // All
            
            arrayContest = arrayAll;
            [self.tableViewContest reloadData];
        }
    }
}

#pragma mark - Helper
/**
 * dismiss keyboard
 */
- (void) dismissKeyboard {
    [self.searchBarContest resignFirstResponder];
    [self filterContest];
}

@end
