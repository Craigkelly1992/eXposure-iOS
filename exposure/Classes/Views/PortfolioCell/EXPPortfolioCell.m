//
//  EXPPortfolioCell.m
//  exposure
//
//  Created by stuart on 2014-05-23.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPPortfolioCell.h"
#import "UIImageView+AFNetworking.h"

@implementation EXPPortfolioCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateCellWithPost:(Post *)post{
    if ([post.image_url isEqualToString:@"/photos/placeholder.png"]) {
        self.cellImage.image = nil;
    } else {
        self.alpha = 0;
        [self.cellImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:post.image_url]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            self.alpha = 0.0;
            self.cellImage.image = image;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.alpha = 1.0;
                             }];
        }failure:nil];
    }
}

-(void)prepareForReuse{
    self.cellImage.image = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
