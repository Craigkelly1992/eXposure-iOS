//
//  EXPContestHeaderView.h
//  exposure
//
//  Created by stuart on 2014-05-27.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contest.h"
@protocol ContestHeaderDelegate <NSObject>
@required
- (void) enterContestPressed;
- (void) goToBrandPressed;
@end


@interface EXPContestHeaderView : UICollectionReusableView <UIActionSheetDelegate> {
    id <ContestHeaderDelegate> _delegate;
}

@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *detailsTouchView;
@property (nonatomic,strong) id delegate;
@property (weak, nonatomic) IBOutlet UIButton *enterContestBtn;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *contestOpennessLabel;
@property (weak, nonatomic) IBOutlet UILabel *contestNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contestImage;
@property (weak, nonatomic) IBOutlet UILabel *howToEnterLabel;
@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *brandPageBtn;
@property (weak, nonatomic) IBOutlet UIButton *rulesBtn;
@property (weak, nonatomic) IBOutlet UIView *detailView;


- (IBAction)enterContest:(id)sender;
- (IBAction)brandPage:(id)sender;
- (IBAction)contestRules:(id)sender;
- (void)setupHeader:(Contest *)contest;


@end
