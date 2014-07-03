//
//  EXPPortfolioFlowLayout.m
//  exposure
//
//  Created by stuart on 2014-05-23.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import "EXPPortfolioFlowLayout.h"

@implementation EXPPortfolioFlowLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(106, 106);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = 0.667f;
    
    return self;
}


@end
