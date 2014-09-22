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
#import "EXPGalleryViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "EXPNewPostViewController.h"
#import <Social/Social.h>

// View Controler Identifer
#define VC_PHOTOSTREAM_ID @"EXPPhotoStreamViewControllerIdentifier"
#define VC_CONTEST_ID @"EXPContestsViewControllerIdentifier"
#define VC_NOTIFICATION_ID @"EXPNotificationsViewControllerIdentifier"
#define VC_PORTFOLIO_ID @"EXPPortfolioViewControllerIdentifier"

@interface EXPTabBarController ()

@end

@implementation EXPTabBarController {
    NSNumber *contestId;
}

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
    self.selectedIndex = 4;
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
    UITabBarItem *tabCamera = [self.tabBar.items objectAtIndex:2];
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
    tabCamera.enabled = NO; // user can't click on tab item, because we need them click on Camera button
    
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
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    } else {
        // has login
        contestId = nil;
        [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", @"Facebook", @"Instagram", @"Twitter", nil]showInView:self.view];
    }
}

-(void)createPostWithContest:(NSNumber*) _contestId {
    if(![[Infrastructure sharedClient] currentUser]){
        // anonymous
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    } else {
        // has login
        contestId = _contestId;
        [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", @"Facebook", @"Instagram", @"Twitter", @"Profile", nil]showInView:self.view];
    }
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.delegate = self;
    
    switch (buttonIndex) {
        case 0: // Camera
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:controller animated:YES completion:nil];
            break;
            
        case 1: // Library
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:controller animated:YES completion:nil];
            break;
        
        case 2: // Facebook
            [self openFacebookGallery];
            break;
            
        case 3: // Instagram
            [self openInstagramGallery];
            break;
            
        case 4: // Twitter
            [self openTwitterGallery];
            break;
            
        case 5: // Profile
            [self openProfileGallery];
            break;
            
        default:
            break;
    }
}

- (void) openFacebookGallery {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EXPGalleryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"EXPGalleryViewControllerIdentifier"];
    //
    viewController.type = kGALLERY_FACEBOOK;
    //
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) openInstagramGallery {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EXPGalleryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"EXPGalleryViewControllerIdentifier"];
    //
    viewController.type = kGALLERY_INSTAGRAM;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) openTwitterGallery {
    if ([SLComposeViewController
         isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterAccountType =
        [accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 EXPGalleryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"EXPGalleryViewControllerIdentifier"];
                 //
                 viewController.type = kGALLERY_TWITTER;
                 [self.navigationController pushViewController:viewController animated:YES];
             } else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
                 [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please allow this app access twitter account on Setting application" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
             }
         }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"You didn\'t set up any Twitter account, please sign in at least 1 on device Settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

- (void) openProfileGallery {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EXPGalleryViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"EXPGalleryViewControllerIdentifier"];
    viewController.contestId = contestId;
    //
    viewController.type = kGALLERY_PROFILE;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    CLImageToolInfo *tonalTool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
    tonalTool.available = NO;
    
    CLImageToolInfo *adjustmentTool = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:NO];
    adjustmentTool.available = NO;
    
    CLImageToolInfo *effectTool = [editor.toolInfo subToolInfoWithToolName:@"CLEffectTool" recursive:NO];
    effectTool.available = NO;
    
    CLImageToolInfo *blurTool = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:NO];
    blurTool.available = NO;
    
    NSArray *array = [editor.toolInfo subtools];
    for (CLImageToolInfo *tool in array) {
        NSLog(@"%@",tool.toolName);
    }
    [picker pushViewController:editor animated:YES];
    
}

#pragma mark - image editor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    //
    [editor dismissViewControllerAnimated:YES completion:nil];
    //
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EXPNewPostViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"EXPNewPostViewControllerIdentifier"];
    //
    viewController.imagePost = image;
    viewController.contestId = contestId;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - life cycle
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
