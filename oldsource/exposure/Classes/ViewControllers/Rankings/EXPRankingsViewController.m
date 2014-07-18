//
//  EXPRankingsViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPRankingsViewController.h"
#import "CoreData+MagicalRecord.h"
#import "EXPRankingsViewCell.h"
#import "EXPPortfolioViewController.h"
#import "User.h"

@interface EXPRankingsViewController () {
    NSFetchedResultsController *_fetcher;
    UISegmentedControl *segment;
    
}
@property (nonatomic) NSArray *users;

@end

@implementation EXPRankingsViewController

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
    segment = [[UISegmentedControl alloc]initWithItems:@[@"All Users", @"Following"]];
     segment.frame = CGRectMake(100, 10, 130, 25);
    segment.selectedSegmentIndex = 0;
    _navBar.delegate = self;
    _navBar.topItem.title = @"World Rankings";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.navigationController.navigationBar setTranslucent:NO];
   _tableView.sectionHeaderHeight = 50;
    [self.view setBackgroundColor:[UIColor colorWithRed:149.0f/255.0f green:209.0f/255.0f blue:197.0f/255.0f alpha:1]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    __block EXPRankingsViewController *weakself = self;
    
    
    [User userGlobalRankingsWithCompletion:^(NSMutableArray *array, NSError *error){
        if(!error){
          weakself.users  = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSNumber *first = [(User*)a ranking];
                NSNumber *second = [(User*)b ranking];
                return [first compare:second];
          }];
         [self.tableView reloadData];
            
        }
    }];
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - tableview delegate calls

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if(self.users == nil) return 0;
    NSLog(@"%d",self.users.count);
    return (int)self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     [tableView registerNib:[UINib nibWithNibName:@"EXPRankingsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    EXPRankingsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[EXPRankingsViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    User *user = [self.users objectAtIndex:indexPath.row];
    NSLog(@"viewcontorllersayswhat: %@", user.userName);
    [cell updateCellWithUser:[self.users objectAtIndex:indexPath.row]];
    cell.rankLabel.text = [NSString stringWithFormat:@"%d", (indexPath.row + 1)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    EXPPortfolioViewController *detailViewController = [[EXPPortfolioViewController alloc] initWithUser:[self.users objectAtIndex:indexPath.row]];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
//    return 100;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 75)];
    /* Create custom view to display section header... */
    [segment setBackgroundImage:[UIImage imageNamed:@"btn_blue_small"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    segment.backgroundColor = [UIColor blueColor];
    [segment setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    // segment.layer.cornerRadius = 4;
    [segment addTarget:self action:@selector(segmentChanged) forControlEvents:UIControlEventValueChanged];
    [view addSubview:segment];
    [view setBackgroundColor:[UIColor colorWithRed:149.0f/255.0f green:209.0f/255.0f blue:197.0f/255.0f alpha:1]];
    return view;
}

-(void)segmentChanged {
    NSLog(@"HERE IS THE SEGMENT VALUE %d", segment.selectedSegmentIndex);
    
    __block EXPRankingsViewController *weakself = self;
    if(segment.selectedSegmentIndex == 0){
        [User userGlobalRankingsWithCompletion:^(NSMutableArray *array, NSError *error){
            if(!error){
                weakself.users  = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSNumber *first = [(User*)a ranking];
                    NSNumber *second = [(User*)b ranking];
                    return [first compare:second];
                }];
                [self.tableView reloadData];
                
            }
        }];

    } else if(segment.selectedSegmentIndex == 1){
        NSLog(@"TROLOLOLOLOOL");
        [User userFollowingRankingsWithCompletion:^(NSMutableArray *array, NSError *error){
            if(!error){
                if(!error){
                    weakself.users  = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                        NSNumber *first = [(User*)a ranking];
                        NSNumber *second = [(User*)b ranking];
                        return [first compare:second];
                    }];
                    [self.tableView reloadData];
                }
            }
        }];
    }
}


#pragma mark - navbar delegate calls
-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
