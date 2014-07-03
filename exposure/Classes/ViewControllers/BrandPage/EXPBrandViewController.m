//
//  EXPBrandViewController.m
//  exposure
//
//  Created by stuart on 2014-06-10.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPBrandViewController.h"
#import "CoreData+MagicalRecord.h"
#import "EXPPortfolioCell.h"
#import "EXPPortfolioFlowLayout.h"
#import "EXPPortfolioHeaderView.h"
#import "EXPImageDetailViewController.h"
#import "User.h"

@interface EXPBrandViewController ()<NSFetchedResultsControllerDelegate> {
    Brand *_brand;
    NSFetchedResultsController *_fetcher;
}

@end

@implementation EXPBrandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithBrand:(Brand *)brand {
    self = [super init];
    if(self){
        _brand = brand;
        
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EXPPortfolioCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"PortfolioCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EXPPortfolioHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"EXPPortfolioHeaderView"];
    
    
    EXPPortfolioFlowLayout *flowLayout = [[EXPPortfolioFlowLayout alloc]init];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 271)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    User *_user = [User currentUser];
  _fetcher = [Post MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"user_id == %@",_user.user_id] sortedBy:@"user_id" ascending:YES delegate:self];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
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
    //NSLog(@"portfolioView image ID %@",post.image_url);
    cell.alpha = 0;
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
        [header updateWithBrand:_brand];
        return header;
    }
    return nil;
}

#pragma mark - portfolio header delegate

-(void)settingsPressed{
   
}


#pragma mark - nsfetchedresultscontroller delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"HEY HEY THERE");
    [self.collectionView reloadData];
}



@end
