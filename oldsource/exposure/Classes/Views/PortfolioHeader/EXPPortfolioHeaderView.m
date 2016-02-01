//
//  EXPPortfolioHeaderView.m
//  exposure
//
//  Created by stuart on 2014-05-23.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPPortfolioHeaderView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>
@implementation EXPPortfolioHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     
        
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)xpBtn:(id)sender {
    [_delegate xpBtnPressed];
}

- (IBAction)settingsBtn:(id)sender {
    [_delegate settingsPressed];
}

- (IBAction)facebookBtn:(id)sender {
    [_delegate facebookPressed];
}

- (IBAction)instagramBtn:(id)sender {
    [_delegate instagramPressed];
}

- (IBAction)contestsBtn:(id)sender {
}
- (IBAction)twitterBtn:(id)sender {
    [_delegate twitterPressed];
}

-(void)updateWithUser:(User *)user {
    if(user == [User currentUser]){
        [_followBtn setTitle:@"Settings" forState:UIControlStateNormal];
    }
    NSLog(@"USER NAME %@ AND BACKDROP IMAGE: %@", user.userName, user.backdropImage);
    _followerCount.text = user.followerCount.stringValue;
    _followingCount.text = user.followingCount.stringValue;
    _submissionCount.text = [NSString stringWithFormat:@"%d",user.postCountValue];
    _profilePicture.layer.borderWidth = 1.5f;
    _profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [_profilePicture setImageWithURL:[NSURL URLWithString:user.profileImage]];
    _usernameLabel.text = user.userName;
    [_backdropImage setImageWithURL:[NSURL URLWithString:user.backdropImage]];
    _descriptionView.text = user.user_description;
    _pagingView.delegate = self;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 2;
    
}

-(void)updateWithBrand:(Brand *)brand {
//    _followerCount.text = brand.followerCount.stringValue;
  //  _followingCount.text = brand.followingCount.stringValue;
    //_submissionCount.text = [NSString stringWithFormat:@"%d",brand.postCountValue];
  //  _profilePicture.layer.borderWidth = 1.5f;
   // _profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
 //   [_profilePicture setImageWithURL:[NSURL URLWithString:user.profileImage]];
    _usernameLabel.text = brand.name;
    [_backdropImage setImageWithURL:[NSURL URLWithString:brand.profileImageURL]];
    _descriptionView.text = brand.brand_description;
    _pagingView.delegate = self;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 2;
    _XPBtn.hidden = true;

    
}
- (IBAction)followSettingsBtn:(id)sender {
    if ([_followBtn.titleLabel.text isEqualToString:@"Settings"]) {
        [_delegate settingsPressed];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   CGFloat width = _pagingView.frame.size.width;
    float xPos = _pagingView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    _pageControl.currentPage = (int)xPos/width;
}
@end
