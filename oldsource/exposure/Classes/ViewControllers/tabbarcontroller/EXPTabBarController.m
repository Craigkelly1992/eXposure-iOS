//
//  EXPTabBarController.m
//  exposure
//
//  Created by stuart on 2014-05-26.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPTabBarController.h"
#import "EXPLoginViewController.h"
#import <DAKeyboardControl/DAKeyboardControl.h>
#import "EXPStreamViewController.h"
#import "EXPPortfolioViewController.h"
#import "EXPRankingsViewController.h"
#import "EXPNotificationsViewController.h"
#import "EXPSignUpViewController.h"
#import "EXPHowItWorksViewController.h"
#import "EXPContestsViewController.h"
#import "CLImageEditor.h"
#import "EXPNewPostViewController.h"
#import "EXPLoginViewController.h"

@interface EXPTabBarController ()<CLImageEditorDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    User *_user;
}

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

-(id)initWithUser:(User *)user{
    self = [super init];
    if(self) {
       
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = [self createTabBarViewControllers];
 
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tab_camera_normal"] highlightImage:[UIImage imageNamed:@"tab_camera_active"]];
    // Do any additional setup after loading the view.
    
   
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *item4 = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *item5 = [self.tabBar.items objectAtIndex:4];
    // here you need to use the icon with the color you want, as it will be rendered as it is
    item.image =  [[UIImage imageNamed:@"tab_photo_stream_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"tab_contests_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"tab_notifications_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.image = [[UIImage imageNamed:@"tab_portfolio_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // this icon is used for selected tab and it will get tinted as defined in self.tabBar.tintColor
    item.selectedImage =  [[UIImage imageNamed:@"tab_photo_stream_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"tab_contests_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"tab_notifications_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.selectedImage = [[UIImage imageNamed:@"tab_portfolio_active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    [self.navigationController.navigationBar setTranslucent:NO];
    self.tabBar.translucent = NO;
    self.tabBar.barTintColor = [UIColor colorWithRed:0.0f green:0.17647059f blue:0.4f alpha:1];
}


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
    if([User currentUser] == nil){
        EXPLoginViewController *vc = [[EXPLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    } else {

     [[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil]showInView:self.view];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)createTabBarViewControllers {
    EXPStreamViewController *vc = [[EXPStreamViewController alloc]init];
 
    EXPPortfolioViewController *portfolio = [[EXPPortfolioViewController alloc]initWithUser:[User currentUser]];

    EXPNotificationsViewController *notifications = [[EXPNotificationsViewController alloc]init];
    EXPContestsViewController *contests = [[EXPContestsViewController alloc]init];
    
    UINavigationController *streamNav = [[UINavigationController alloc]initWithRootViewController:vc];
    UINavigationController *notificationnav = [[UINavigationController alloc]initWithRootViewController:notifications];
    UINavigationController *portfolioNav = [[UINavigationController alloc]initWithRootViewController:portfolio];
    
    UINavigationController *contestsNav = [[UINavigationController alloc]initWithRootViewController:contests];
    
    notifications.title = @"Notifications";
    portfolio.title = @"Portfolio";
    vc.title = @"Photo Stream";
    
    contests.title = @"Contests";
    return [NSArray arrayWithObjects:streamNav, contestsNav, [[UIViewController alloc]init], notificationnav, portfolioNav, nil];
}

-(NSArray *)createTabBarItems {
   
        UIViewController *controller = [self.viewControllers objectAtIndex:0];
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:controller.title image:[UIImage imageNamed:@"tab_photo_stream_normal"] selectedImage:[UIImage imageNamed:@"tab_photo_stream_active"]];
    
    return [NSArray arrayWithObject:item];
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
    NSLog(@"oh hey sup there");
 //   EXPNewPostViewController *vc = [[EXPNewPostViewController alloc]initWithImage:image attributes:@{@"contest_id": @""}];
    NSDictionary *dict = @{@"image": image};
    [self setSelectedIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kNewPost" object:nil userInfo:dict];
    [editor dismissViewControllerAnimated:YES completion:nil];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
