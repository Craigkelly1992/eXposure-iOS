//
//  EXPImageDetailViewController.m
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPImageDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "User.h"
#import "Contest.h"
#import "EXPPortfolioViewController.h"
#import "EXPLoginViewController.h"
#import "CommentsViewController.h"
@interface EXPImageDetailViewController (){
    //
    //User *_user;
}
@property (nonatomic) User * user;
@property (nonatomic) Post *post;
@end

@implementation EXPImageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithPost:(Post *)post{
    self = [super init];
    if(self){
        _post = post;
        NSLog(@"THIS IS HTE USER ID %@", post.user_id);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    [_postImage setImageWithURL:[NSURL URLWithString:_post.image_url]];
  __block EXPImageDetailViewController *weakSelf = self;
    //NSLog(@" %@");
    [User userWithID:_post.user_id completion:^(User *user, NSError *error){
        [weakSelf.profileImage setImageWithURL:[NSURL URLWithString:user.profileImage]];
         weakSelf.user = user;
         weakSelf.nameLabel.text = user.userName;
        weakSelf.captionLabel.text = @"";
    }];
 //   _contestLabel.text = _post.
    _likesLabel.text = _post.like_count.stringValue;
    _commentsLabel.text = _post.comment_count.stringValue;
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareBtn:(id)sender {
    NSArray *activityItems = nil;
    
    if (_postImage.image != nil) {
        activityItems = @[_captionLabel.text, _postImage];
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];
    }
    
    
    
}

- (IBAction)commentBtn:(id)sender {
    if([User currentUser] == nil){
        EXPLoginViewController *vc = [[EXPLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        CommentsViewController *vc = [[CommentsViewController alloc]init];
        vc.post = _post;
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}

- (IBAction)likeBtn:(id)sender {
    if([User currentUser] == nil){
        EXPLoginViewController *vc = [[EXPLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        __block  EXPImageDetailViewController *weakSelf = self;
        [_post likePostWithCompletion:^(NSError *error){
            if (error) {
                NSLog(@"an error has occurred");
            } else {
                //get post likes again.
                NSLog(@"huzzahhh!");
                weakSelf.likesLabel.text = [NSString stringWithFormat:@"%d",(weakSelf.post.like_countValue + 1)];
            }
            
        }];
    }
 
}

- (IBAction)profileBtn:(id)sender {
    EXPPortfolioViewController *vc = [[EXPPortfolioViewController alloc]initWithUser:_user];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
