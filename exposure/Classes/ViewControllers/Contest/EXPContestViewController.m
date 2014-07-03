//
//  EXPContestViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPContestViewController.h"
#import "EXPContestHeaderView.h"
#import "EXPImageDetailViewController.h"
#import "EXPPortfolioCell.h"
#import "EXPPortfolioFlowLayout.h"
#import "CLImageEditor.h"
#import "EXPNewPostViewController.h"
#import "EXPBrandViewController.h"
#import "Post.h"
#import "CoreData+MagicalRecord.h"
#import "EXPPortfolioHeaderView.h"
#import "EXPLoginViewController.h"

@interface EXPContestViewController ()<ContestHeaderDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate, NSFetchedResultsControllerDelegate> {
    Contest *_contest;
    NSFetchedResultsController *_fetcher;
}

@end

@implementation EXPContestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithContest:(Contest *)contest {
    self = [super init];
    if(self){
        _contest = contest;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([User currentUser] == nil){
        EXPLoginViewController *vc = [[EXPLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    } else {

    _fetcher = [Post MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"contest_id contains %@",[User currentUser].user_id] sortedBy:@"contest_id" ascending:YES delegate:self];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EXPPortfolioCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"contestCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EXPContestHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"contestHeaderView"];
    
    
    EXPPortfolioFlowLayout *flowLayout = [[EXPPortfolioFlowLayout alloc]init];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 267)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"THIS IS THE CONTEST ID %@",_contest.contest_id );
    [Post postsByContestID:_contest.contest_id completion:^(NSError *error){
        if(!error){
            [self.collectionView reloadData];
        }
    }];
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
    EXPPortfolioCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"contestCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EXPPortfolioCell alloc]init];
    }
    unsigned int row = (unsigned int)indexPath.row;
    Post *post = [_fetcher.fetchedObjects objectAtIndex:row];
    NSLog(@"%@",post.image_url);
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
        EXPContestHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:
                                          UICollectionElementKindSectionHeader withReuseIdentifier:@"contestHeaderView" forIndexPath:indexPath];
        
        header.delegate = self;
        [header setupHeader:_contest];
        return header;
    }
    return nil;
}

#pragma mark - header delegate
-(void)enterContestPressed {
    [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil]showInView:self.view];
}

-(void)goToBrandPressed {
    
    [Brand brandWithID:_contest.brand_id completion:^(Brand *brand, NSError *error){
        if(!error){
            EXPBrandViewController *vc = [[EXPBrandViewController alloc]initWithBrand:brand];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.delegate = self;
   
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        case 1:
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    CLImageToolInfo *tonalTool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
    tonalTool.available = NO;
    
    CLImageToolInfo *adjustmentTool = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:NO];
    adjustmentTool.available = NO;
    
    CLImageToolInfo *effectTool = [editor.toolInfo subToolInfoWithToolName:@"CLEffectTool" recursive:NO];
    effectTool.available = NO;
    
    CLImageToolInfo *blurTool = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:NO];
    blurTool.available = NO;

    NSArray *array = [editor.toolInfo subtools];
    for (CLImageToolInfo *tool in array) {
        NSLog(@"%@",tool.toolName);
    }
    [picker pushViewController:editor animated:YES];
    
}

#pragma mark - image editor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    NSLog(@"CONTEST ID LOL %@", _contest.contest_id);
    EXPNewPostViewController *vc = [[EXPNewPostViewController alloc]initWithImage:image attributes:@{@"contest_id": _contest.contest_id}];
    
    [self.navigationController pushViewController:vc animated:YES];
    [editor dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - nsfetchedresultscontroller delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView reloadData];
}
@end
