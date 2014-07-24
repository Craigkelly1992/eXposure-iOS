//
//  EXPPortfolioViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPortfolioViewController.h"
#import "EXPPortFolioSettingsViewController.h"
#import "Post.h"

@interface EXPPortfolioViewController ()

@end

@implementation EXPPortfolioViewController {
    NSArray *arrayPost;
}

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
    self.title = @"Portfolio";
    // GUI
    self.imageViewProfile.layer.borderWidth = 1.5f;
    self.imageViewProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.buttonSetting setTitle:@"Settings" forState:UIControlStateNormal];
    // post
    arrayPost = [[NSArray alloc] init];
    // fill user's data
    if ([Infrastructure sharedClient].currentUser) {
        // has login yet
        User *user = [Infrastructure sharedClient].currentUser;
        self.labelUsername.text = user.username;
        [self.imageViewProfile setImageURL:[NSURL URLWithString:user.profile_picture_url]];
        [self.imageViewBackground setImageURL:[NSURL URLWithString:user.background_picture_url]];
        self.textViewDescription.text = user.description;
        // following, follower, submission count
        self.labelFollowerCount.text = [user.followers_count stringValue];
        self.labelFollowingCount.text = [user.follow_count stringValue];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    // synchronize from server
    if ([Infrastructure sharedClient].currentUser) {
        User *currentUser = [Infrastructure sharedClient].currentUser;
        [SVProgressHUD showWithStatus:@"Loading"];
        [self.serviceAPI getPostByUserId:currentUser.userId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
            
            NSLog(@"%@", responseObject);
            arrayPost = responseObject;
            [self.collectionViewPost reloadData];
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Can\'t retrieve data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)buttonXPTap:(id)sender {
    
}
- (IBAction)buttonSettingTap:(id)sender {
    EXPPortFolioSettingsViewController *portfolioSettingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EXPPortFolioSettingsViewControllerIdentifier"];
    [self.navigationController pushViewController:portfolioSettingVC animated:YES];
}
- (IBAction)buttonFacebookTap:(id)sender {
    
}
- (IBAction)buttonInstagramTap:(id)sender {
    
}
- (IBAction)buttonContestTap:(id)sender {
    
}
- (IBAction)buttonFollowTap:(id)sender {
    
}
- (IBAction)buttonTwitterTap:(id)sender {
    
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.pagingView.frame.size.width;
    float xPos = self.pagingView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    self.pageControl.currentPage = (int)xPos/width;
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortfolioPostViewCellIdentifier" forIndexPath:indexPath];
    // parse dictionary to Post object
    Post *post = [Post objectFromDictionary:[arrayPost objectAtIndex:indexPath.row]];
    // fill to cell
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    if ([post.image_url rangeOfString:@"placeholder"].location != NSNotFound ) {
        [imageView setImageURL:[NSURL URLWithString:post.image_url]];
    } else {
        [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
