//
//  EXPBrandViewController.h
//  exposure
//
//  Created by stuart on 2014-06-10.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@interface EXPBrandViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


-(id)initWithBrand:(Brand*)brand;
-(void)getProfileInfo;


@end
