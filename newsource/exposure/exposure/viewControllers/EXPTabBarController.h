//
//  EXPTabBarController.h
//  exposure
//
//  Created by Binh Nguyen on 7/17/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPTabBarController : UITabBarController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(NSArray *)createTabBarViewControllers;
    
@end
