//
//  EXPPortfolioViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPPortfolioViewController.h"
#import "EXPImageDetailViewController.h"
#import "EXPPortfolioCell.h"
#import "EXPPortfolioFlowLayout.h"
#import "EXPPortfolioHeaderView.h"
#import "EXPPortFolioSettingsViewController.h"
#import "Post.h"
#import "CoreData+MagicalRecord.h"
#import "EXPRankingsViewController.h"
#import "EXPLoginViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface EXPPortfolioViewController ()<PorfolioHeaderDelegate, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetcher;
    User *_user;
    UINavigationController *navController;
}

@property (nonatomic) NSInteger page;
@end

@implementation EXPPortfolioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithUser:(User *)user {
    self = [super init];
    if(self){
        _user = user;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.page = 1;
   [self.navigationController.navigationBar setTranslucent:NO];
          [self getProfileInfo];
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EXPPortfolioCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"PortfolioCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EXPPortfolioHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPPortfolioHeaderView"];

    
    EXPPortfolioFlowLayout *flowLayout = [[EXPPortfolioFlowLayout alloc]init];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 271)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    
    
    __weak EXPPortfolioViewController *weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getLaterPosts];
    }];

    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)getProfileInfo{
//    if(_user.token != nil){
//        [Post userPostsWithCompletion:^(NSError *error){
//            
//            if(!error){
//                
//                [self.collectionView reloadData];
//                
//            }
//            
//        }];
//    } else {
//           }
    
    _fetcher = [Post MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"user_id == %@",_user.user_id] sortedBy:@"user_id" ascending:YES delegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [Post userPostsWithCompletion:^(NSError *error){
//        
//        if(!error){
//            
//            [self.collectionView reloadData];
//            NSLog(@"hello?");
//            
//        }
//        
//    }];
    [self getLaterPosts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionviewdatasource delegate methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"fetched objects count = %d",_fetcher.fetchedObjects.count);
    int count = (int)[_fetcher.fetchedObjects count];
    return count;
    
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
    NSLog(@"portfolioView image ID %@",post.image_url);
    [cell updateCellWithPost:post];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EXPImageDetailViewController *imageDetail = [[EXPImageDetailViewController alloc]initWithPost:[_fetcher.fetchedObjects objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:imageDetail animated:YES];
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        EXPPortfolioHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:
                                UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPPortfolioHeaderView" forIndexPath:indexPath];
        header.delegate = self;
        [header.pagingView setContentSize:CGSizeMake(header.frame.size.width*2, header.pagingView.frame.size.height)];
        [header updateWithUser:_user];
        return header;
    }
    return nil;
}

#pragma mark - portfolio header delegate

-(void)settingsPressed{
    
    EXPPortFolioSettingsViewController *vc = [[EXPPortFolioSettingsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)xpBtnPressed{
    EXPRankingsViewController *vc = [[EXPRankingsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)facebookPressed {
    UIViewController *vc = [[UIViewController alloc]init];
    UIWebView *wv = [[UIWebView alloc]initWithFrame:vc.view.frame];
    [vc.view addSubview:wv];
    navController = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelFacebook)];
    [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_user.facebook]]];
    [self presentViewController:navController animated:YES completion:nil];

}

-(void)twitterPressed{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@",_user.twitter]]];
}

-(void)instagramPressed{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?user=%@",_user.instagram]]];
}

-(void)cancelFacebook {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - nsfetchedresultscontroller delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"HEY HEY THERE");
    [self.collectionView reloadData];
}

#pragma mark - refresh methods
-(void)getLaterPosts{
    
    __weak EXPPortfolioViewController *weakSelf = self;
    [Post userPostsWithID:_user.user_id page:self.page completion:^(NSError *error){
        if(!error){
            weakSelf.page++;
            [self.collectionView.infiniteScrollingView stopAnimating];
            [self.collectionView reloadData];
            
        }
        
    }];

    
}

@end
