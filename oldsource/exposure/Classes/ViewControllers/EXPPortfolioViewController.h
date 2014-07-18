//
//  EXPPortfolioViewController.h
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface EXPPortfolioViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


-(id)initWithUser:(User*)user;
-(void)getProfileInfo;
@end
