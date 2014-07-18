//
//  EXPPortfolioCell.h
//  exposure
//
//  Created by stuart on 2014-05-23.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface EXPPortfolioCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

-(void)updateCellWithPost:(Post *)post;
@end
