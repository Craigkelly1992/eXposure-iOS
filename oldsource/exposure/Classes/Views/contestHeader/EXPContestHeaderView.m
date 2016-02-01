//
//  EXPContestHeaderView.m
//  exposure
//
//  Created by stuart on 2014-05-27.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPContestHeaderView.h"
#import "EXPBrandViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation EXPContestHeaderView {
    Contest *_contest;
    CGRect _detailViewRect;
}

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
-(void)setupHeader:(Contest *)contest{
    _contest = contest;
    [_contestImage setImageWithURL:[NSURL URLWithString:contest.picture]];
    _brandLabel.text = contest.brand_name;
    _detailViewRect = _detailView.frame;
    [_detailsTouchView setUserInteractionEnabled:TRUE];
    [_detailsTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveDetailView)]];
    _descriptionText.text = _contest.contest_description;
    
    
}

-(void)moveDetailView{
    __block EXPContestHeaderView *weakSelf = self;
    if(_detailViewRect.origin.y == _detailView.frame.origin.y){
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.detailView.center = CGPointMake(weakSelf.detailView.center.x, weakSelf.detailView.center.y - 140);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.detailView.center = CGPointMake(weakSelf.detailView.center.x, weakSelf.detailView.center.y + 140);
        }];
    }
}

- (IBAction)enterContest:(id)sender {
    [_delegate enterContestPressed];
}
- (IBAction)brandPage:(id)sender {
    [_delegate goToBrandPressed];
    
}

- (IBAction)contestRules:(id)sender {
}



@end
