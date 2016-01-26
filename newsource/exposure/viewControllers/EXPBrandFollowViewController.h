//
//  EXPBrandFollowViewController.h
//  exposure
//
//  Created by Binh Nguyen on 9/10/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPBrandFollowViewController : EXPBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic) BOOL isFollower; // followers or winners
@property (strong, nonatomic) NSArray *arrayWinner;
@property (strong, nonatomic) NSArray *arrayFollower;
@property (strong, nonatomic) NSString *brandName;
//
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOption;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewUser;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UILabel *labelNoItem;

@end
