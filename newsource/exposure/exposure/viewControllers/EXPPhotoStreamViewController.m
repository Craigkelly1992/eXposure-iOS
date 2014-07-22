//
//  EXPPhotoStreamViewController.m
//  exposure
//
//  Created by Binh Nguyen on 7/22/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPPhotoStreamViewController.h"
#import "Post.h"

@interface EXPPhotoStreamViewController ()

@end

@implementation EXPPhotoStreamViewController {
    NSMutableArray *arrayPost;
}

#pragma mark - life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayPost = [[NSMutableArray alloc] init];
    // get array of posts from server
    [SVProgressHUD showWithStatus:@"Loading"];
    [self.serviceAPI getAllPostWithSuccess:^(id responseObject) {
        NSLog(@"%@", responseObject);
        arrayPost = responseObject;
        [self.collectionViewPost reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Can\'t retrieve data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView datasource & delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (arrayPost) {
        return [arrayPost count];
    } else {
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoStreamCollectionViewCellIdentifier" forIndexPath:indexPath];
    // parse dictionary to Post object
    Post *post = [Post objectFromDictionary:[arrayPost objectAtIndex:indexPath.row]];
    // fill to cell
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    [imageView setImageURL:[NSURL URLWithString:post.image_url]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
