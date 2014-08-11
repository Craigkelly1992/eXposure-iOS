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

@interface EXPContestsViewController ()

@end

@implementation EXPContestsViewController {
    NSArray *arrayContest;
    NSIndexPath *selectedIndexPath;
    User *currentUser;
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
    // get all contest
    currentUser = [Infrastructure sharedClient].currentUser;
    arrayContest = [[NSArray alloc] init];
    // add gesture for removing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.viewBelow setUserInteractionEnabled:YES];
    [self.viewBelow addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
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
        [self loadFollowingContest];
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
    if (arrayContest) {
        return [arrayContest count];
    }
    return [arrayContest count];
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
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:indexPath.row]];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewLeft];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewRight];
    //
    [imageViewLeft setImage:[UIImage imageNamed:@"placeholder.png"]];
    if ([contest.picture_url_thumb rangeOfString:@"placeholder"].location == NSNotFound ) {
        [imageViewLeft setImageURL:[NSURL URLWithString:contest.picture_url_thumb]];
    }
    //
    [imageViewRight setImage:[UIImage imageNamed:@"placeholder.png"]];
    if ([contest.picture_url_thumb rangeOfString:@"placeholder"].location == NSNotFound ) {
        [imageViewRight setImageURL:[NSURL URLWithString:contest.picture_url_thumb]];
    }
    //
    labelContestName.text = contest.title;
    labelContestDetail.text = contest.description;
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
    [self.serviceAPI getAllContestWithUserEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        arrayContest = responseObject;
        if (arrayContest.count <= 0) {
            self.labelNoItem.hidden = NO;
            self.tableViewContest.hidden = YES;
        } else {
            self.labelNoItem.hidden = YES;
            self.tableViewContest.hidden = NO;
        }
        [self.tableViewContest reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void) loadFollowingContest {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getContestByFollowingUserId:currentUser.userId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        arrayContest = responseObject;
        if (arrayContest.count <= 0) {
            self.labelNoItem.hidden = NO;
            self.tableViewContest.hidden = YES;
        } else {
            self.labelNoItem.hidden = YES;
            self.tableViewContest.hidden = NO;
        }
        [self.tableViewContest reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    EXPContestDetailViewController *contestDetailVC = segue.destinationViewController;
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:selectedIndexPath.row]];
    contestDetailVC.contestId = contest.contestId;
    contestDetailVC.image_url = contest.picture_url;
    contestDetailVC.image_url_thumb = contest.picture_url_thumb;
    contestDetailVC.image_url_square = contest.picture_url_square;
    contestDetailVC.image_url_preview = contest.picture_url_preview;
}

#pragma mark - SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    NSLog(@"Search for contests by brand [%@]", searchText);
}

#pragma mark - Helper
/**
 * dismiss keyboard
 */
- (void) dismissKeyboard {
    [self.searchBarContest resignFirstResponder];
}

@end
