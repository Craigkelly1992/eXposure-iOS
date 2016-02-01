//
//  EXPContestsViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPContestsViewController.h"
#import "EXPContestViewController.h"
#import "Contest.h"
#import "EXPContestsCell.h"
#import "User.h"
#import "EXPLoginViewController.h"

@interface EXPContestsViewController (){
    NSArray *_tempData;
}

@end

@implementation EXPContestsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
            //  _tempData = [NSArray arrayWithObjects:@"coke",@"avengers",@"pepsi",@"Nikon", nil];
        [Contest contestsWithcompletion:^(NSArray *array, NSError* error){
            _tempData = [NSArray arrayWithArray:array];
            [self.tableView reloadData];
            
        }];
      [self.navigationController.navigationBar setTranslucent:NO];
    [self.view setBackgroundColor:[UIColor colorWithRed:149.0f/255.0f green:209.0f/255.0f blue:197.0f/255.0f alpha:1]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
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
    return _tempData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ContestCell";
    
    [tableView registerNib:[UINib nibWithNibName:@"EXPContestCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:simpleTableIdentifier];
    EXPContestsCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
   
    if (cell == nil) {
        cell = [[EXPContestsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Contest *contest = [_tempData objectAtIndex:indexPath.row];
    //cell.textLabel.text = contest.title;
    [cell updateWithContest:contest];
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    uint row = (uint)indexPath.row;
    Contest *contest = [_tempData objectAtIndex:row];
    EXPContestViewController *detailViewController = [[EXPContestViewController alloc] initWithContest:contest];
    
    detailViewController.title = contest.title;
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
