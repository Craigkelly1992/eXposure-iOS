//
//  EXPContestDetailViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"
#import "Contest.h"
#import "EXPTabBarController.h"

@interface EXPContestDetailViewController : EXPBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

//
@property(nonatomic, strong) NSNumber *contestId;

// 2014-08-11, transfer image url to this screen, because can't get with get contest by id
@property (nonatomic, copy) NSString * image_url;
@property (nonatomic, copy) NSString * image_url_square;
@property (nonatomic, copy) NSString * image_url_preview;
@property (nonatomic, copy) NSString * image_url_thumb;

//
@property (weak, nonatomic) IBOutlet UILabel *labelBrandName;
@property (weak, nonatomic) IBOutlet UILabel *labelContestName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContest;
@property (weak, nonatomic) IBOutlet UIButton *buttonIndicatorDetail;
@property (weak, nonatomic) IBOutlet UITextView *textViewDetail;
@property (weak, nonatomic) IBOutlet UIButton *buttonIndicatorSubmission;
@property (weak, nonatomic) IBOutlet UIButton *buttonEnter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintDetailHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintSubmissionHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPost;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContainer;
@property (strong, nonatomic) IBOutlet UIView *viewDetailContainer;


// Actions
- (IBAction)buttonEnterContestTap:(id)sender;
- (IBAction)buttonRuleTap:(id)sender;
- (IBAction)buttonIndicatorDetail:(id)sender;
- (IBAction)buttonIndicatorSubmission:(id)sender;

@end
