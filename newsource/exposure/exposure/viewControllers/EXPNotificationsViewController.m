//
//  EXPNotificationsViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPNotificationsViewController.h"
#import "Notification.h"

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
    UILabel *labelSender = (UILabel*)[cell viewWithTag:2];
    UILabel *labelDetail = (UILabel*)[cell viewWithTag:3];
    UIImageView *imageViewWinner = (UIImageView*)[cell viewWithTag:4];
    //
    if ([notification.sender_picture rangeOfString:@"placeholder"].location != NSNotFound ) {
        [imageViewSender setImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [imageViewSender setImageURL:[NSURL URLWithString:notification.sender_picture]];
    }
    labelSender.text = notification.sender_name;
    labelDetail.text = notification.text;
    if ([notification.type rangeOfString:@"winner"].location != NSNotFound) { // is winner
        imageViewWinner.image = [UIImage imageNamed:@"badge_winner"];
    } else {
        imageViewWinner.image = nil;
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

@end
