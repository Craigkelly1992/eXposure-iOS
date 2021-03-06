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
#import "PPiFlatSegmentedControl.h"

@interface EXPContestsViewController ()

@end

@implementation EXPContestsViewController {
    NSMutableArray *arrayAll;
    NSMutableArray *arrayFollowing;
    NSArray *arrayContest;
    NSIndexPath *selectedIndexPath;
    User *currentUser;
    NSString *currentDateTime;
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
    self.title = @"Contests";
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
    self.labelNoItem.hidden = YES;
    
    /////
    NSArray *items = @[[[PPiFlatSegmentItem alloc] initWithTitle:@"Following" andIcon:nil],
                       [[PPiFlatSegmentItem alloc] initWithTitle:@"All" andIcon:nil]];
    segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(99, 64, 123, 29) items:items
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
    
    if(![Infrastructure sharedClient].currentUser){
        [segmented setSelected:YES segmentAtIndex:1];
    }
    
    //
    if ([segmented isSelectedSegmentAtIndex:0]) { // Following
        
        [self loadFollowingContest];
    } else if ([segmented isSelectedSegmentAtIndex:1]) { // All
        [self loadAllContest];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segment
- (void)segmentValueChanged:(NSUInteger) segmentIndex {
    
    if (segmentIndex == 0) { // Following
        if(![Infrastructure sharedClient].currentUser){
            // back to login screen
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
        }else{
            [self loadFollowingContest];
        }

    } else if (segmentIndex == 1) { // All
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
    UIImageView *imageViewRight = (UIImageView*)[cell viewWithTag:4];
    UILabel *labelContestName = (UILabel*)[cell viewWithTag:2];
    UILabel *labelContestDetail = (UILabel*)[cell viewWithTag:3];
    // fill data
//    NSInteger reverseOrder = arrayContest.count - 1 - indexPath.row;
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:indexPath.row]];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewLeft];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageViewRight];
    // compare start & end to show available
    currentDateTime = [[Util sharedUtil] getCurrentSystemDateString];
    if (
        //[contest.start_date caseInsensitiveCompare:currentDateTime] == NSOrderedAscending &&
        [contest.start_date caseInsensitiveCompare:currentDateTime] == NSOrderedDescending) { // start date > current date === future contest
        
        imageViewRight.hidden = YES;
    } else {
        imageViewRight.hidden = NO;
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
    [self.serviceAPI getAllContestWithUserEmail:currentUser.email
                                      userToken:currentUser.authentication_token
                                         userId:currentUser.userId
                                        success:^(id responseObject) {
        
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
//    NSInteger reverseOrder = arrayContest.count - 1 - selectedIndexPath.row;
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:selectedIndexPath.row]];
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
        if ([segmented isSelectedSegmentAtIndex:0]) { // Following
            
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
