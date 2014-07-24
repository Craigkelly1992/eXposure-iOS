//
//  EXPTabBarController.m
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPTabBarController.h"
#import "EXPLoginViewController.h"
#import <DAKeyboardControl/DAKeyboardControl.h>
#import "EXPPhotoStreamViewController.h"
#import "EXPPortfolioViewController.h"
#import "EXPRankingsViewController.h"
#import "EXPNotificationsViewController.h"
#import "EXPSignUpViewController.h"
#import "EXPHowItWorksViewController.h"
#import "EXPContestsViewController.h"
//#import "CLImageEditor.h"
#import "EXPNewPostViewController.h"
#import "EXPLoginViewController.h"

// View Controler Identifer
#define VC_PHOTOSTREAM_ID @"EXPPhotoStreamViewControllerIdentifier"
#define VC_CONTEST_ID @"EXPContestsViewControllerIdentifier"
#define VC_NOTIFICATION_ID @"EXPNotificationsViewControllerIdentifier"
#define VC_PORTFOLIO_ID @"EXPPortfolioViewControllerIdentifier"

@interface EXPTabBarController ()

@end

@implementation EXPTabBarController

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
    self.viewControllers = [self createTabBarViewControllers];
    [self customTabbarItem];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = [UIColor colorWithRed:0.0f green:0.17647059f blue:0.4f alpha:1];
}

// Create ViewControllers for Tab Bar
-(NSArray *)createTabBarViewControllers {
    
    // create view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // #1
    EXPPhotoStreamViewController *photoStreamVC = [storyboard instantiateViewControllerWithIdentifier:VC_PHOTOSTREAM_ID];
    UINavigationController *photoStreamNavigationVC = [[UINavigationController alloc]initWithRootViewController:photoStreamVC];
    photoStreamVC.title = @"Photo Stream";
    // #2
    EXPContestsViewController *contestVC = [storyboard instantiateViewControllerWithIdentifier:VC_CONTEST_ID];
    UINavigationController *contestNavigationVC = [[UINavigationController alloc]initWithRootViewController:contestVC];
    contestVC.title = @"Contest";
    // #3
    // Camera Button
    // #4
    EXPNotificationsViewController *notificationVC = [storyboard instantiateViewControllerWithIdentifier:VC_NOTIFICATION_ID];
    UINavigationController *notificationNavigationVC = [[UINavigationController alloc]initWithRootViewController:notificationVC];
    notificationVC.title = @"Notification";
    // #5
    EXPPortfolioViewController *portfolioVC = [storyboard instantiateViewControllerWithIdentifier:VC_PORTFOLIO_ID];
    UINavigationController *portfolioNavigationVC = [[UINavigationController alloc]initWithRootViewController:portfolioVC];
    portfolioVC.title = @"Portfolio";
    // list
    return [NSArray arrayWithObjects:
            photoStreamNavigationVC,
            contestNavigationVC,
            [[UIViewController alloc]init],
            notificationNavigationVC,
            portfolioNavigationVC, nil];
}

#pragma mark - custom tabbar item
- (void) customTabbarItem {
    
    // create another tab
    UITabBarItem *tabPhotoStream = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabContest = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabNotification = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabPortfolio = [self.tabBar.items objectAtIndex:4];
    
    // #1 : PhotoStream
    tabPhotoStream.image =  [[UIImage imageNamed:@"tab_photo_stream_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabPhotoStream.selectedImage =  [[UIImage imageNamed:@"tab_photo_stream_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // #2 : Contest
    tabContest.image = [[UIImage imageNamed:@"tab_contests_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabContest.selectedImage = [[UIImage imageNamed:@"tab_contests_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // #3 : Camera
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tab_camera_normal"] highlightImage:[UIImage imageNamed:@"tab_camera_active"]];
    
    // #4 : Notification
    tabNotification.image = [[UIImage imageNamed:@"tab_notifications_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabNotification.selectedImage = [[UIImage imageNamed:@"tab_notifications_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // #5 : Portfolio
    tabPortfolio.image = [[UIImage imageNamed:@"tab_portfolio_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabPortfolio.selectedImage = [[UIImage imageNamed:@"tab_portfolio_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - Central Button Camera
// Add button Camera
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, 25, 19);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(didPressCamera) forControlEvents:UIControlEventTouchUpInside];
    //button.center = CGPointMake(self.tabBar.center.x, button.center.y);
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = CGPointMake(self.tabBar.center.x, self.tabBar.center.y - 6);//self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0f - 3;
        button.center = center;
    }
    UILabel *cameraLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.text = @"Camera";
    cameraLabel.font = [UIFont systemFontOfSize:10.5];
    cameraLabel.textColor = [UIColor whiteColor];
    cameraLabel.center = CGPointMake(button.center.x, button.center.y + 23.5);
    
    [self.view addSubview:button];
    [self.view addSubview:cameraLabel];
}

-(void)didPressCamera {
    if(![[Infrastructure sharedClient] currentUser]){
        // anonymous
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        // has login
        [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil]showInView:self.view];
    }
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        case 1:
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
}

#pragma mark - image editor delegate


#pragma mark - life cycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
