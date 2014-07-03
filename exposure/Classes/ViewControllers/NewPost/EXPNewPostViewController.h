//
//  EXPNewPostViewController.h
//  exposure
//
//  Created by stuart on 2014-05-29.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPNewPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *postText;
@property (weak, nonatomic) IBOutlet UIView *postBar;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
- (IBAction)postBtn:(id)sender;
- (id)initWithImage:(UIImage *)image attributes:(NSDictionary *)dict;


@end
