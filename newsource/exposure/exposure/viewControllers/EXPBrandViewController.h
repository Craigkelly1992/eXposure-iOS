//
//  EXPBrandViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPBrandViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

// IBOutlet
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBackgorund;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewHeader;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBrand;
@property (strong, nonatomic) IBOutlet UILabel *labelBrandName;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescription;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *buttonIndicatorContest;
@property (strong, nonatomic) IBOutlet UITableView *tableViewContest;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightContestView;
@property (strong, nonatomic) IBOutlet UILabel *labelSubmission;
@property (strong, nonatomic) IBOutlet UILabel *labelFollower;
@property (strong, nonatomic) IBOutlet UILabel *labelWinner;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewContest;
@property (strong, nonatomic) IBOutlet UIButton *buttonFollow;

// IBAction
- (IBAction)buttonFollowTap:(id)sender;
- (IBAction)buttonXPTap:(id)sender;
- (IBAction)buttonFacebookTap:(id)sender;
- (IBAction)buttonTwitterTap:(id)sender;
- (IBAction)buttonInstagramTap:(id)sender;


@end
