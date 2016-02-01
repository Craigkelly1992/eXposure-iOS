//
//  EXPStreamViewController.h
//  exposure
//
//  Created by stuart on 2014-05-22.
//  Copyright (c) 2014 exposure. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPStreamViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate, UISearchDisplayDelegate> {
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
