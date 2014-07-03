//
//  EXPNotificationsViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPNotificationsViewController.h"
#import "EXPNotificationsCell.h"
#import "User.h"
#import "EXPLoginViewController.h"
#import "EXPTabBarController.h"

@interface EXPNotificationsViewController ()

@end

@implementation EXPNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([User currentUser] == nil){
        EXPLoginViewController *vc = [[EXPLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        //GET NOTIFICATIONS
         [self.navigationController.navigationBar setTranslucent:NO];
        //IF NO NOTIFICATIONS
        UILabel *noNotifications = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        noNotifications.text = @"No Notifications!";
        noNotifications.textColor = [UIColor colorWithWhite:0.4f alpha:1];
        [noNotifications setTextAlignment:NSTextAlignmentCenter];
        noNotifications.center = CGPointMake(noNotifications.center.x, self.view.center.y/2.0f);
        
        [self.view addSubview:noNotifications];
        
        
    }
    
    
      [self.view setBackgroundColor:[UIColor colorWithRed:149.0f/255.0f green:209.0f/255.0f blue:197.0f/255.0f alpha:1]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //update the notification badge
    
    EXPTabBarController *controller = (EXPTabBarController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    UITabBarItem *tab =  (UITabBarItem *)[controller.tabBar.items objectAtIndex:3];
    tab.badgeValue = [NSString stringWithFormat:@"%d",0];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NotificationCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"EXPNotificationsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:simpleTableIdentifier];
    EXPNotificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        cell = [[EXPNotificationsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
   // cell.textLabel.text = @"lolol";
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
