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

@interface EXPContestDetailViewController ()

@end

@implementation EXPContestDetailViewController {
    ContestDetail *currentContest;
    NSArray *arraySubmission;
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
            [self.imageViewContest setImage:[UIImage imageNamed:@"placeholder.png"]];
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

#pragma mark - Actions
- (IBAction)buttonEnterContestTap:(id)sender {
    
}

- (IBAction)buttonBrandTap:(id)sender {
    
}

- (IBAction)buttonRuleTap:(id)sender {
    if (currentContest) {
        [[[UIAlertView alloc] initWithTitle:@"Rule" message:currentContest.contest.info.rules delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (IBAction)buttonIndicatorDetail:(id)sender {
    if (self.constraintDetailHeight.constant == 172) {
        self.constraintDetailHeight.constant = 33;
        self.buttonIndicatorDetail.imageView.image = [UIImage imageNamed:@"arrow_down"];
    } else {
        self.constraintDetailHeight.constant = 172;
        self.buttonIndicatorDetail.imageView.image = [UIImage imageNamed:@"arrow_up"];
    }
}

- (IBAction)buttonIndicatorSubmission:(id)sender {
    if (self.constraintSubmissionHeight.constant == 264) {
        self.constraintSubmissionHeight.constant = 33;
        self.buttonIndicatorSubmission.imageView.image = [UIImage imageNamed:@"arrow_down"];
    } else {
        self.constraintSubmissionHeight.constant = 264;
        self.buttonIndicatorSubmission.imageView.image = [UIImage imageNamed:@"arrow_up"];
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

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
