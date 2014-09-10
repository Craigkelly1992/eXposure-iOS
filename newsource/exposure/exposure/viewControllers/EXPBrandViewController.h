//
//  EXPBrandViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPBrandViewController : EXPBaseViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

//
@property(nonatomic, strong) NSNumber *brandId;

// IBOutlet
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewHeader;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *buttonIndicatorContest;
@property (strong, nonatomic) IBOutlet UITableView *tableViewContest;
@property (strong, nonatomic) IBOutlet UILabel *labelSubmission;
@property (strong, nonatomic) IBOutlet UILabel *labelFollower;
@property (strong, nonatomic) IBOutlet UILabel *labelWinner;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPost;
@property (strong, nonatomic) IBOutlet UIButton *buttonFollow;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintContestListHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintFollowViewHeight;
@property (strong, nonatomic) IBOutlet UIView *viewContestContainer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollviewContainer;
@property (strong, nonatomic) IBOutlet UIView *viewFollowerContainer;
@property (strong, nonatomic) IBOutlet UIView *viewWinnerContainer;

// IBAction
- (IBAction)buttonXPTap:(id)sender;
- (IBAction)buttonFacebookTap:(id)sender;
- (IBAction)buttonTwitterTap:(id)sender;
- (IBAction)buttonInstagramTap:(id)sender;
- (IBAction)buttonContestIndicatorTap:(id)sender;


@end
