//
//  EXPNotificationsViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPNotificationsViewController.h"
#import "Notification.h"
#import "EXPImageDetailViewController.h"
#import "EXPPrizeClaimViewController.h"

@interface EXPNotificationsViewController ()

@end

@implementation EXPNotificationsViewController {
    NSMutableArray *arrayNotification;
}

#pragma mark - Life cycle
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
    self.title = @"Notifications";
    //
    arrayNotification = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([Infrastructure sharedClient].currentUser) {
        User *user = [Infrastructure sharedClient].currentUser;
        [SVProgressHUD showWithStatus:@"Loading"];
        [self.serviceAPI getNotificationWithUserEmail:user.email userToken:user.authentication_token success:^(id responseObject) {
            
            [SVProgressHUD dismiss];
            arrayNotification = responseObject;
            [self.tableViewNotification reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD dismiss];
        }];

    } else {
        // back to login screen
        // TODO
    }
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
    return [arrayNotification count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationTableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationTableViewCellIdentifier"];
    }
    // convert to notification
    Notification *notification = [Notification objectFromDictionary:arrayNotification[indexPath.row]];
    //
    UIImageView *imageViewSender = (UIImageView*)[cell viewWithTag:1];
    UILabel *labelContest = (UILabel*)[cell viewWithTag:2];
    UILabel *labelContestSlogan = (UILabel*)[cell viewWithTag:3];
    UILabel *labelDetail = (UILabel*)[cell viewWithTag:5]; // for type user
    UIImageView *imageViewWinner = (UIImageView*)[cell viewWithTag:4];
    //
    if ([notification.sender_type rangeOfString:@"user"].location != NSNotFound) { // is winner
        labelContest.hidden = YES;
        labelContestSlogan.hidden = YES;
        labelDetail.hidden = NO;
        imageViewWinner.hidden = YES;
        labelDetail.text = notification.text;
    } else { // Winner
        labelContest.hidden = NO;
        labelContestSlogan.hidden = NO;
        labelDetail.hidden = YES;
        imageViewWinner.hidden = NO;
        labelContest.text = notification.sender_name;
        labelContestSlogan.text = notification.text;
        if ([notification.type rangeOfString:@"winner"].location != NSNotFound) { // is winner
            imageViewWinner.image = [UIImage imageNamed:@"badge_winner"];
        }
    }
    if ([notification.sender_picture rangeOfString:@"placeholder"].location != NSNotFound ) {
        [imageViewSender setImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [imageViewSender setImageURL:[NSURL URLWithString:notification.sender_picture]];
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
    Notification *notification = [Notification objectFromDictionary:arrayNotification[indexPath.row]];
    if ([notification.type rangeOfString:@"like"].location != NSNotFound) { // is like
        EXPImageDetailViewController *postVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EXPImageDetailViewControllerIdentifier"];
        postVC.postId = notification.post_id;
        [self.navigationController pushViewController:postVC animated:YES];
    
    } else if ([notification.type rangeOfString:@"winner"].location != NSNotFound) { // is winner
    
        EXPPrizeClaimViewController *winnerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EXPPrizeClaimViewControllerIdentifier"];
        
        [self.navigationController pushViewController:winnerVC animated:YES];
    }
}

@end
