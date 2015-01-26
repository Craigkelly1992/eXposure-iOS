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
#import "Util.h"

#define kDetailHeightMin 35
#define kDetailHeightMax 172
#define kSubmissionHeightMin 35
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
    self.constraintDetailHeight.constant = kDetailHeightMin;
    isSubmissionOpen = YES;
//    self.constraintSubmissionHeight.constant = 200;
    // load image
    if (self.image_url) {
        [self.imageViewContest setImageURL:[NSURL URLWithString:self.image_url]];
    } else {
//        [self.imageViewContest setImage:[UIImage imageNamed:@"sample.jpg"]];
    }
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    // get contest detail
    [SVProgressHUD showWithStatus:@"Loading"];
    User *currentUser = [Infrastructure sharedClient].currentUser;
    [self.serviceAPI getContestWithContestId:self.contestId userEmail:currentUser.email userToken:currentUser.authentication_token success:^(id responseObject) {
        
        [SVProgressHUD dismiss];
        currentContest = [ContestDetail objectFromDictionary:responseObject];
        // fill data
        self.labelBrandName.text = currentContest.brand.name;
        self.labelContestName.text = currentContest.contest.info.title;
        [self.labelContestName resizeToFit];
        self.title = currentContest.contest.info.title;
        
        // compare start & end to show available
        if ([currentContest.contest.info.start_date caseInsensitiveCompare:currentContest.contest.info.current_date_server] == NSOrderedAscending &&
            [currentContest.contest.info.end_date caseInsensitiveCompare:currentContest.contest.info.current_date_server] == NSOrderedDescending) {
            self.imageViewAvailable.hidden = NO;
            self.buttonEnter.enabled = YES;
        } else {
            self.imageViewAvailable.hidden = YES;
            self.buttonEnter.enabled = NO;
        }
        //browse mode
        if(![[Infrastructure sharedClient] currentUser]){
                //browse mode
                self.buttonEnter.enabled = NO;
        }
        //
        NSString *detail = [NSString stringWithFormat:@"Prize: %@ \n\n %@", currentContest.contest.info.prizes, currentContest.contest.info.mDescription];
        self.textViewDetail.text = detail;
        
        //
        arraySubmission = currentContest.submissions.submissions;
        [self.collectionViewPost reloadData];
        [self updateScrollView];
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
        self.constraintSubmissionHeight.constant = kFollowHeaderHeight + (arraySubmission.count / 3 + arraySubmission.count % 3)*kCollectionCellSize;
    }
    // for main scroll view
    int newHeight = self.viewDetailContainer.frame.origin.y + self.viewDetailContainer.frame.size.height + self.constraintDetailHeight.constant + self.constraintSubmissionHeight.constant;
    self.scrollViewContainer.contentSize = CGSizeMake(self.scrollViewContainer.frame.size.width, newHeight);
}

#pragma mark - Actions
- (IBAction)buttonEnterContestTap:(id)sender {
    if ([Infrastructure sharedClient].currentUser) {
        EXPTabBarController *tabVC = (EXPTabBarController*)self.tabBarController;
        [tabVC createPostWithContest:currentContest.contest.info.contestId];
    } else {
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    }
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

- (IBAction)buttonPrizeTap:(id)sender {
    if (currentContest) {
        [[[UIAlertView alloc] initWithTitle:@"Prize" message:currentContest.contest.info.prizes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
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
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    if (submission.image_url_thumb) {
        [imageView setImageURL:[NSURL URLWithString:submission.image_url_thumb]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Submission *submission = [arraySubmission objectAtIndex:indexPath.row];
    EXPImageDetailViewController *postVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EXPImageDetailViewControllerIdentifier"];
    postVC.postId = submission.submissionId;
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
