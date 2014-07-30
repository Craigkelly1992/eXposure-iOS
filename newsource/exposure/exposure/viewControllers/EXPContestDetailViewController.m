//
//  EXPContestDetailViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPContestDetailViewController.h"
#import "ContestDetail.h"
#import "SubmissionList.h"
#import "Submission.h"
#import "UILabel+DynamicSizeMe.h"
#import "EXPBrandViewController.h"
#import "Post.h"
#import "EXPImageDetailViewController.h"

#define kDetailHeightMin 33
#define kDetailHeightMax 172
#define kSubmissionHeightMin 33
#define kFollowHeaderHeight 44
#define kCollectionCellSize 120

@interface EXPContestDetailViewController ()

@end

@implementation EXPContestDetailViewController {
    ContestDetail *currentContest;
    NSArray *arraySubmission;
    BOOL isDetailOpen;
    BOOL isSubmissionOpen;
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
    isDetailOpen = NO;
    isSubmissionOpen = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    // get contest detail
    [SVProgressHUD showWithStatus:@"Loading"];
    User *currentUser = [Infrastructure sharedClient].currentUser;
    [self.serviceAPI getContestWithContestId:self.contestId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        currentContest = [ContestDetail objectFromDictionary:responseObject];
        arraySubmission = currentContest.submissions.submissions;
        [self.collectionViewPost reloadData];
        // fill data
        self.labelBrandName.text = currentContest.brand.name;
        self.labelContestName.text = currentContest.contest.info.title;
        [self.labelContestName resizeToFit];
        self.title = currentContest.contest.info.title;
        //
        if ([currentContest.contest.info.picture_file_name rangeOfString:@"http"].location != NSNotFound ) {
            [self.imageViewContest setImageURL:[NSURL URLWithString:currentContest.contest.info.picture_file_name]];
        } else {
            [self.imageViewContest setImage:[UIImage imageNamed:@"sample.jpg"]];
        }
        //
        self.textViewDetail.text = currentContest.contest.info.description;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self updateScrollView];
}

-(void) updateScrollView {
    // for update tableview
    if (isSubmissionOpen) {
        self.constraintSubmissionHeight.constant = kFollowHeaderHeight + ([self.collectionViewPost numberOfItemsInSection:0]%3 + 1)*kCollectionCellSize;
    }
    // for main scroll view
    int newHeight = self.viewDetailContainer.frame.origin.y + self.constraintDetailHeight.constant + self.constraintSubmissionHeight.constant + kTabBarHeight;
    self.scrollViewContainer.contentSize = CGSizeMake(self.scrollViewContainer.frame.size.width, newHeight);
}

#pragma mark - Actions
- (IBAction)buttonEnterContestTap:(id)sender {
    
}

- (IBAction)buttonRuleTap:(id)sender {
    if (currentContest) {
        [[[UIAlertView alloc] initWithTitle:@"Rule" message:currentContest.contest.info.rules delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (IBAction)buttonIndicatorDetail:(id)sender {
    if (self.constraintDetailHeight.constant >= kDetailHeightMax) {
        self.constraintDetailHeight.constant = kDetailHeightMin;
        [self.buttonIndicatorDetail setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        isDetailOpen = NO;
    } else {
        self.constraintDetailHeight.constant = kDetailHeightMax;
        [self.buttonIndicatorDetail setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];;
        isDetailOpen = YES;
    }
    [self updateScrollView];
}

- (IBAction)buttonIndicatorSubmission:(id)sender {
    if (self.constraintSubmissionHeight.constant > kSubmissionHeightMin) {
        self.constraintSubmissionHeight.constant = kSubmissionHeightMin;
        isSubmissionOpen = NO;
        [self.buttonIndicatorSubmission setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    } else {
        isSubmissionOpen = YES;
        [self updateScrollView];
        [self.buttonIndicatorSubmission setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    }
}

#pragma mark - CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (arraySubmission) {
        return [arraySubmission count];
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubmissionCollectionViewCellIdentifier" forIndexPath:indexPath];
    // parse dictionary to Post object
    Submission *submission = [arraySubmission objectAtIndex:indexPath.row];
    // fill to cell
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    if (submission.image_file_name) {
        [imageView setImageURL:[NSURL URLWithString:submission.image_file_name]];
    } else {
        [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Submission *selectedPost = [Post objectFromDictionary:[arraySubmission objectAtIndex:indexPath.row]];
    EXPImageDetailViewController *postVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EXPImageDetailViewControllerIdentifier"];
    postVC.postId = selectedPost.submissionId;
    [self.navigationController pushViewController:postVC animated:YES];
}

#pragma mark - Segue Delegate
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (currentContest) {
        return YES;
    } else {
        return NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EXPBrandViewController *brandVC = (EXPBrandViewController*) segue.destinationViewController;
    brandVC.brandId = currentContest.contest.info.brand_id;
}

@end
