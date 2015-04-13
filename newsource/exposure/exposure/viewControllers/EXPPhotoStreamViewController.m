//
//  EXPPhotoStreamViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/22/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPhotoStreamViewController.h"
#import "Post.h"
#import "EXPImageDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "EXPLoginViewController.h"
#import "PPiFlatSegmentedControl.h"

#define VC_PORTFOLIO_ID @"EXPLoginViewControllerIdentifier"

@interface EXPPhotoStreamViewController ()

@end

@implementation EXPPhotoStreamViewController {
    NSMutableArray *arrayPost;
    Post *currentPost;
    User *currentUser;
    PPiFlatSegmentedControl *segmented;
}

#pragma mark - life cycle
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
    arrayPost = [[NSMutableArray alloc] init];
    // get current user
    currentUser = [Infrastructure sharedClient].currentUser;
    //
    self.labelNoItem.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /////
    NSArray *items = @[[[PPiFlatSegmentItem alloc] initWithTitle:@"Following" andIcon:nil],
                       [[PPiFlatSegmentItem alloc] initWithTitle:@"All" andIcon:nil]];
    segmented=[[PPiFlatSegmentedControl alloc] initWithFrame:self.segmentOption.frame items:items
                                                iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
                                                    
                                                    [self segmentValueChanged:segmentIndex];
                                                    
                                                } iconSeparation:0.0f];
    segmented.color=[UIColor colorWithRed:4.0f/255.0 green:45.0f/255.0 blue:104.0f/255.0 alpha:1];
    segmented.borderWidth=0;
    segmented.borderColor=[UIColor darkGrayColor];
    segmented.selectedColor=[UIColor colorWithRed:237.0f/255.0 green:189.0f/255.0 blue:42.0f/255.0 alpha:1];
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:11],
                               NSForegroundColorAttributeName:[UIColor whiteColor]};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:11],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.view addSubview:segmented];
    
    if(![Infrastructure sharedClient].currentUser){
        [segmented setSelected:YES segmentAtIndex:1];
    }
    
    //
    if ([segmented isSelectedSegmentAtIndex:0]) { // All User
        
        [self getAllPhotoStream];
    } else if ([segmented isSelectedSegmentAtIndex:1]) { // Following
        [self getFollowingPhotoStream];
    }
}

#pragma mark - Segment
- (void)segmentValueChanged:(NSUInteger) segmentIndex {
    
    if (segmentIndex == 0) { // All User
        if(![Infrastructure sharedClient].currentUser){
            // back to login screen
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
        }else{
            [self getAllPhotoStream];
        }
        
    } else if (segmentIndex == 1) { // All
        [self getFollowingPhotoStream];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView datasource & delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (arrayPost) {
        return [arrayPost count];
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoStreamCollectionViewCellIdentifier" forIndexPath:indexPath];
    // parse dictionary to Post object
    Post *post = [Post objectFromDictionary:[arrayPost objectAtIndex:indexPath.row]];
    // fill to cell
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    // default image, waiting for loading from url
    [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    if ([post.image_url_thumb rangeOfString:@"placeholder"].location == NSNotFound) {
        [imageView setImageURL:[NSURL URLWithString:post.image_url_thumb]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    currentPost = [Post objectFromDictionary:[arrayPost objectAtIndex:indexPath.row]];
    EXPImageDetailViewController *postVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EXPImageDetailViewControllerIdentifier"];
    postVC.postId = currentPost.postId;
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - Actions
// we don't use this anymore, replaced by PPiFlatSegmentedControl
- (IBAction)segmentOptionValueChanged:(id)sender {
//    if (self.segmentOption.selectedSegmentIndex == 0) { // All user
//        [self getAllPhotoStream];
//    } else if (self.segmentOption.selectedSegmentIndex == 1) {
//        if(![Infrastructure sharedClient].currentUser){
//            // back to login screen
//            [self.tabBarController.navigationController popViewControllerAnimated:YES];
//        }else{
//            [self getFollowingPhotoStream];
//        }
//    }
}

#pragma mark - Helper
/**
 * Get PhotoStream : By Following
 */
- (void) getFollowingPhotoStream {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getPostStreamWithUserEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        arrayPost = responseObject;
        [self.collectionViewPost reloadData];
        if (arrayPost.count <= 0) {
            self.labelNoItem.hidden = NO;
            self.collectionViewPost.hidden = YES;
        } else {
            self.labelNoItem.hidden = YES;
            self.collectionViewPost.hidden = NO;
        }
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Can\'t retrieve data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
}

/**
 * Get PhotoStream : By All User
 */
- (void) getAllPhotoStream {
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getAllPostWithSuccess:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        NSLog(@"%@", responseObject);
        arrayPost = responseObject;
        [self.collectionViewPost reloadData];
        if (arrayPost.count <= 0) {
            self.labelNoItem.hidden = NO;
            self.collectionViewPost.hidden = YES;
        } else {
            self.labelNoItem.hidden = YES;
            self.collectionViewPost.hidden = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Can\'t retrieve data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
}

@end
