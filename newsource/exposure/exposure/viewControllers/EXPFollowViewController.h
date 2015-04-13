//
//  EXPFollowViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/24/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPFollowViewController : EXPBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

//
@property (strong, nonatomic) NSNumber *userId;
@property (nonatomic) BOOL isFollowing;
//
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOption;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewUser;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UILabel *labelNoItem;

@end
