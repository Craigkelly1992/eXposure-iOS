//
//  EXPGalleryViewController.h
//  exposure
//
//  Created by Binh Nguyen on 8/1/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"

#define kGALLERY_FACEBOOK  1
#define kGALLERY_INSTAGRAM 2
#define kGALLERY_TWITTER   3

@interface EXPGalleryViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, CLImageEditorDelegate>

//
@property (nonatomic) int type;
//
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewGallery;

@end
