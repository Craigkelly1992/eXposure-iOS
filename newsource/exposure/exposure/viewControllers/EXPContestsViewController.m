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
    NSNumber *contestId;
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
    User *currentUser = [Infrastructure sharedClient].currentUser;
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getAllContestWithUserEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        arrayContest = responseObject;
        [self.tableViewContest reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segment Delegate
- (IBAction)segmentValueChanged:(id)sender {
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
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:indexPath.row]];
    if ([contest.picture_file_name rangeOfString:@"http"].location != NSNotFound ) {
        [imageViewLeft setImageURL:[NSURL URLWithString:contest.picture_file_name]];
    } else {
        [imageViewLeft setImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    //
    if ([contest.picture_file_name rangeOfString:@"http"].location != NSNotFound ) {
        [imageViewRight setImageURL:[NSURL URLWithString:contest.picture_file_name]];
    } else {
        [imageViewRight setImage:[UIImage imageNamed:@"placeholder.png"]];
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
    Contest *contest = [Contest objectFromDictionary:[arrayContest objectAtIndex:indexPath.row]];
    contestId = contest.contestId;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EXPContestDetailViewController *contestDetailVC = segue.destinationViewController;
    contestDetailVC.contestId = contestId;
}

@end
