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
                            UICollectionViewDataSource, UICollectionViewDelegate>

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

- (IBAction)buttonXPTap:(id)sender;
- (IBAction)buttonSettingTap:(id)sender;
- (IBAction)buttonFacebookTap:(id)sender;
- (IBAction)buttonInstagramTap:(id)sender;
- (IBAction)buttonContestTap:(id)sender;
- (IBAction)buttonFollowTap:(id)sender;
- (IBAction)buttonTwitterTap:(id)sender;

@end
