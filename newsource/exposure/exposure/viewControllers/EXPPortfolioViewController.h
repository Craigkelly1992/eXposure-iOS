//
//  EXPPortfolioViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPPortfolioViewController : EXPBaseViewController <UIScrollViewDelegate,
                            UICollectionViewDataSource, UICollectionViewDelegate,
                            UITableViewDataSource, UITableViewDelegate>

//
@property (weak, nonatomic) NSNumber *profileId;
// Outlets
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pagingView;
@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;
@property (weak, nonatomic) IBOutlet UIButton *buttonXP;
@property (weak, nonatomic) IBOutlet UIButton *buttonFollow;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfile;
@property (weak, nonatomic) IBOutlet UIButton *buttonSetting;
@property (weak, nonatomic) IBOutlet UILabel *labelSubmissionCount;
@property (weak, nonatomic) IBOutlet UILabel *labelFollowerCount;
@property (weak, nonatomic) IBOutlet UILabel *labelFollowingCount;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPost;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) IBOutlet UIView *viewContainter;
@property (strong, nonatomic) IBOutlet UITableView *tableViewContest;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightContest;
@property (strong, nonatomic) IBOutlet UIButton *buttonIndicatorContest;
@property (strong, nonatomic) IBOutlet UIView *viewFollowContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightFollowContainer;
@property (strong, nonatomic) IBOutlet UIView *viewContestContainer;
@property (strong, nonatomic) IBOutlet UIView *viewFollower;
@property (strong, nonatomic) IBOutlet UIView *viewFollowing;

#pragma mark - Actions
- (IBAction)buttonXPTap:(id)sender;
- (IBAction)buttonFacebookTap:(id)sender;
- (IBAction)buttonInstagramTap:(id)sender;
- (IBAction)buttonContestTap:(id)sender;
- (IBAction)buttonTwitterTap:(id)sender;
- (IBAction)buttonIndicatorContestTap:(id)sender;

@end
