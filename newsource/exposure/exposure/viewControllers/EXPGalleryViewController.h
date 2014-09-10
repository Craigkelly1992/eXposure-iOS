//
//  EXPGalleryViewController.h
//  exposure
//
//  Created by Binh Nguyen on 8/1/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageEditor.h"
#import "EXPBaseViewController.h"

#define kGALLERY_FACEBOOK  1
#define kGALLERY_INSTAGRAM 2
#define kGALLERY_TWITTER   3
#define kGALLERY_PROFILE   4

@interface EXPGalleryViewController : EXPBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, CLImageEditorDelegate>

//
@property (nonatomic) int type;
@property (nonatomic) NSNumber *contestId;

//
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewGallery;

@end
