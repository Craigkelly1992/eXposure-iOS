//
//  EXPPortfolioHeaderView.h
//  exposure
//
//  Created by stuart on 2014-05-23.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Brand.h"
@protocol PorfolioHeaderDelegate <NSObject>
@required
- (void) settingsPressed;
- (void) xpBtnPressed;
- (void) facebookPressed;
- (void) twitterPressed;
- (void) instagramPressed;
@end
// Protocol Definition ends here

@interface EXPPortfolioHeaderView : UICollectionReusableView<UIScrollViewDelegate> {
    // Delegate to respond back
    id <PorfolioHeaderDelegate> _delegate;

}

@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIImageView *backdropImage;
- (IBAction)followSettingsBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)twitterBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *pagingView;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *XPBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic,strong) id delegate;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (weak, nonatomic) IBOutlet UILabel *submissionCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
- (IBAction)xpBtn:(id)sender;
- (IBAction)settingsBtn:(id)sender;
- (IBAction)facebookBtn:(id)sender;
- (IBAction)instagramBtn:(id)sender;
- (IBAction)contestsBtn:(id)sender;
- (void)updateWithUser:(User *)user;
- (void)updateWithBrand:(Brand *)brand;

@end
