//
//  EXPPhotoStreamViewController.h
//  exposure
//
//  Created by Binh Nguyen on 7/22/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXPBaseViewController.h"

@interface EXPPhotoStreamViewController : EXPBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPost;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOption;
@property (strong, nonatomic) IBOutlet UILabel *labelNoItem;
@property (strong, nonatomic) IBOutlet UIView *viewBelow;

// Actions
- (IBAction)segmentOptionValueChanged:(id)sender;

@end
