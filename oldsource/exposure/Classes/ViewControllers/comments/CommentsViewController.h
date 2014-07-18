//
//  CommentsViewController.h
//  exposure
//
//  Created by stuart on 2014-06-12.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface CommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)postBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *postBar;
@property (nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *postbtn;

@end
