//
//  EXPStreamViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPStreamViewController.h"
#import "EXPStreamCell.h"
#import "EXPImageDetailViewController.h"
#import "EXPPortfolioHeaderView.h"
#import "EXPPortfolioFlowLayout.h"
#import "EXPPortfolioCell.h"
#import "CoreData+MagicalRecord.h"
#import <QuartzCore/QuartzCore.h>
#import "EXPNewPostViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>


#define kKeyboardOffset 100
@interface EXPStreamViewController () <UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetcher;
}
@property (nonatomic)NSInteger page;
@end

@implementation EXPStreamViewController

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
    self.page = 1;
    _fetcher = [Post MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"stream == true"] sortedBy:@"user_id" ascending:YES delegate:self];
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"EXPPortfolioCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"PortfolioCell"];
   
    [self.collectionView registerClass:[EXPPortfolioHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPPortfolioHeaderView"];
    [self.navigationController.navigationBar setTranslucent:NO];

    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    EXPPortfolioFlowLayout *flowLayout = [[EXPPortfolioFlowLayout alloc]init];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 100)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    searchBar.barTintColor = [UIColor colorWithRed:27.0f/255.0f green:67.0f/255.0f blue:103.0f/255.0f alpha:1];
   // searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"All", @"Following", nil];
    
    //searchBar.showsScopeBar = YES;
    searchBar.placeholder = @"Search For Users";
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newPostPressed:) name:@"kNewPost" object:nil];
    [self setupGestureToDismissKeyboard];
    
    __weak EXPStreamViewController *weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getLaterPosts];
    }];
    
    self.navigationController.navigationItem.backBarButtonItem.title = @"Back";
   
}

-(void)viewWillAppear:(BOOL)animated{
    [self getLaterPosts];
}

-(void)newPostPressed:(NSNotification *)notification{
    UIImage *image = [[notification userInfo] valueForKey:@"image"];
    EXPNewPostViewController *vc = [[EXPNewPostViewController alloc]initWithImage:image attributes:@{@"contest_id": @""}];
    
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)setupGestureToDismissKeyboard {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionviewdatasource delegate methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSString *searchTerm = self.searches[section];
    return (int)_fetcher.fetchedObjects.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EXPPortfolioCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PortfolioCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EXPPortfolioCell alloc]init];
    }
    unsigned int row = (unsigned int)indexPath.row;
    Post *post = [_fetcher.fetchedObjects objectAtIndex:row];
    cell.alpha = 0;
    [cell updateCellWithPost:post];
    
    return cell;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"HEY THIS HAS BEEN HIT");
    EXPImageDetailViewController *imageDetail = [[EXPImageDetailViewController alloc]initWithPost:[_fetcher.fetchedObjects objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:imageDetail animated:YES];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        EXPPortfolioHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:
                                          UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPPortfolioHeaderView" forIndexPath:indexPath];
        [header addSubview:searchBar];
      
        
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"All Users", @"Following"]];
        segment.frame = CGRectMake(100, 50, 130, 25);
        [segment setBackgroundImage:[UIImage imageNamed:@"btn_blue_small"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [segment setBackgroundImage:[UIImage imageNamed:@"btn_yellow_small"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [header addSubview:segment];
        if (_fetcher.fetchedObjects.count == 0) {
            segment.selectedSegmentIndex = 1;
            NSLog(@"lolool");
        }
        return header;
    }
    return nil;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if([searchBar isFirstResponder]){
        NSLog(@"LOLOL");
        return YES;
    }
    return NO;
}

#pragma mark - nsfetchedresultscontroller delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  
    [self.collectionView reloadData];
}


#pragma mark - refresh methods

-(void)getLaterPosts{
    __weak  EXPStreamViewController *weakSelf = self;
    if([User currentUser] == nil){
        NSLog(@"OH HAI THERE");
        [Post userAnonymousStreamPostsWithCompletion:^(NSError *error){
            if(!error){
                [self.collectionView reloadData];
                [self.collectionView.infiniteScrollingView stopAnimating];
                
            }
        }];
    } else {
        
        [Post userStreamPostsWithPage:self.page Completion:^(NSError *error){
            if(!error){
                if (_fetcher.fetchedObjects.count == 0) {
                    [Post userAnonymousStreamPostsWithCompletion:^(NSError *error){
                        if(!error){
                            [self.collectionView reloadData];
                        }
                    }];

                }
                [self.collectionView reloadData];
                weakSelf.page++;
                 [self.collectionView.infiniteScrollingView stopAnimating];
            }
        }];
    }
[self.collectionView.infiniteScrollingView stopAnimating];
}

@end
