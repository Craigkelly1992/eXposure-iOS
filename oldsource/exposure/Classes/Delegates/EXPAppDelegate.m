//
//  EXPAppDelegate.m
//  exposure
//
//  Created by stuart on 5/21/14
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPAppDelegate.h"
#import "EXPLoginViewController.h"
#import <PonyDebugger/PonyDebugger.h>
#import "User.h"
#import "EXPTabBarController.h"

@implementation EXPAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStack];
    
    [self setupUI];
    
    User *user = [User currentUser];
    if (user.token != nil) {
        EXPTabBarController *tc = [[EXPTabBarController alloc]initWithUser:user];
        self.window.rootViewController = tc;
    } else {
        UINavigationController *controller = [[UINavigationController alloc]initWithRootViewController:[[EXPLoginViewController alloc]init]];
        controller.navigationBar.translucent = NO;
        controller.navigationBarHidden = TRUE;
        self.window.rootViewController = controller;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Let the API know that we're registered to receive push notifications
    if (deviceToken.length) {
        NSString *newToken = deviceToken.description;
        newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"New token: %@",newToken);
        [[User currentUser] registerDeviceWithToken:newToken completion:nil];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Do something with the push
    // NSString *pushType = [userInfo objectForKey:@"type"];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
    EXPTabBarController *controller = (EXPTabBarController*)[[UIApplication sharedApplication] keyWindow].rootViewController;
    UITabBarItem *tab =  (UITabBarItem *)[controller.tabBar.items objectAtIndex:3];
    tab.badgeValue = [NSString stringWithFormat:@"%d",[UIApplication sharedApplication].applicationIconBadgeNumber];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // Reset badge number to 0 every time we get a notification when we're already in the app
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - UI
- (void) setupUI {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = [UIColor whiteColor];
    self.window.frame = CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height);
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:69.0f/255.0f green:178.0f/255.0f blue:157.0f/255.0f alpha:1.0]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                                           }];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:236.0f/255.0f green:189.0f/255.0f blue:59.0f/255.0f alpha:1.0], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor blueColor], NSForegroundColorAttributeName,
                                                             nil] forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor whiteColor], NSForegroundColorAttributeName,
                                                             nil] forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor whiteColor], NSForegroundColorAttributeName,
                                                             nil] forState:UIControlStateNormal];
    
    UIFont *font = [UIFont systemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [[UISegmentedControl appearance] setTitleTextAttributes:attributes
                                                   forState:UIControlStateNormal];
}

@end
