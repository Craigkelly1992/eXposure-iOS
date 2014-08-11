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

@interface EXPPhotoStreamViewController ()

@end

@implementation EXPPhotoStreamViewController {
    NSMutableArray *arrayPost;
    Post *currentPost;
    User *currentUser;
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
    // add gesture for removing keyboard
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.viewBelow setUserInteractionEnabled:YES];
    [self.viewBelow addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.segmentOption.selectedSegmentIndex == 0) { // All user
        [self getAllPhotoStream];
    } else if (self.segmentOption.selectedSegmentIndex == 1) {
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
- (IBAction)segmentOptionValueChanged:(id)sender {
    if (self.segmentOption.selectedSegmentIndex == 0) { // All user
        [self getAllPhotoStream];
    } else if (self.segmentOption.selectedSegmentIndex == 1) {
        [self getFollowingPhotoStream];
    }
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

/**
 * dismiss keyboard
 */
- (void) dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"SearchBar:textDidChange with text [%@]", searchBar.text);
    [self.searchBar resignFirstResponder];
    // TODO
}

@end
