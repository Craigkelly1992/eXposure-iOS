//
//  EXPPortfolioViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPortfolioViewController.h"

@interface EXPPortfolioViewController ()

@end

@implementation EXPPortfolioViewController

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
    // Do any additional setup after loading the view.
    self.title = @"Portfolio";
}

- (void)viewWillAppear:(BOOL)animated {
    // GUI
    self.imageViewProfile.layer.borderWidth = 1.5f;
    self.imageViewProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.buttonSetting setTitle:@"Settings" forState:UIControlStateNormal];
    // fill user's data
    if ([Infrastructure sharedClient].currentUser) {
        // has login yet
        User *user = [Infrastructure sharedClient].currentUser;
        self.labelUsername.text = user.username;
        [self.imageViewProfile setImageURL:[NSURL URLWithString:user.profile_picture_url]];
        [self.imageViewBackground setImageURL:[NSURL URLWithString:user.background_picture_url]];
        self.textViewDescription.text = user.description;
        // following, follower, submission count
        self.labelFollowerCount.text = [user.followers_count stringValue];
        self.labelFollowingCount.text = [user.follow_count stringValue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)buttonXPTap:(id)sender {
    
}
- (IBAction)buttonSettingTap:(id)sender {
    
}
- (IBAction)buttonFacebookTap:(id)sender {
    
}
- (IBAction)buttonInstagramTap:(id)sender {
    
}
- (IBAction)buttonContestTap:(id)sender {
    
}
- (IBAction)buttonFollowTap:(id)sender {
    
}
- (IBAction)buttonTwitterTap:(id)sender {
    
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.pagingView.frame.size.width;
    float xPos = self.pagingView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    self.pageControl.currentPage = (int)xPos/width;
}

@end
