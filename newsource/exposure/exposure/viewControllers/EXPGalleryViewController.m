//
//  EXPGalleryViewController.m
//  exposure
//
//  Created by Binh Nguyen on 8/1/14.
//  Copyright (c) 2014 looper. All rights reserved.
//

#import "EXPGalleryViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "InstagramKit.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface EXPGalleryViewController ()

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation EXPGalleryViewController {
    NSMutableArray *arrayThumbnail;
    NSMutableArray *arrayOrigin;
    BOOL gotoEditMode;
}

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
    if (self.type == kGALLERY_FACEBOOK) {
        self.title = @"Facebook";
    } else if (self.type == kGALLERY_INSTAGRAM) {
        self.title = @"Instagram";
    } else if (self.type == kGALLERY_TWITTER) {
        self.title = @"Twitter";
    }
    // Twitter
    self.accountStore = [[ACAccountStore alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    //
    arrayOrigin = [[NSMutableArray alloc] init];
    arrayThumbnail = [[NSMutableArray alloc] init];
    // reset
    gotoEditMode = NO;
    //
    if (self.type == kGALLERY_FACEBOOK) {
        [self loadFromFacebook];
        
    } else if (self.type == kGALLERY_INSTAGRAM) {
        [self loadFromInstagram];
        
    } else if (self.type == kGALLERY_TWITTER) {
        [self loadFromTwitter];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (gotoEditMode) {
        self.navigationController.navigationBarHidden = NO;
    } else {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Social
/**
 * Load collection from Facebook
 */
- (void) loadFromFacebook {
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithAllowLoginUI: YES];
    }
    /* make the API call */
    [SVProgressHUD showWithStatus:@"Loading"];
    [FBRequestConnection startWithGraphPath:@"/me/photos"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              if (!error) {
                                  NSArray *array = [result objectForKey:@"data"];
                                  for (int i = 0; i < array.count; i++) {
                                      [arrayThumbnail addObject:[array[i] objectForKey:@"picture"]];
                                      [arrayOrigin addObject:[array[i] objectForKey:@"source"]];
                                  }
                                  NSLog(@"Facebook Thumbnail: %@", arrayThumbnail);
                                  NSLog(@"Facebook Origin: %@", arrayOrigin);
                                  [self.collectionViewGallery reloadData];
                              } else {
                                  [[[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"We got an error %@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                              }
                              [SVProgressHUD dismiss];
                          }];
}

/**
 * Load collection from Instagram
 */
-(void)loadFromInstagram {
    [SVProgressHUD showWithStatus:@"Loading"];
    if ([InstagramEngine sharedEngine].accessToken) {
        [[InstagramEngine sharedEngine] getSelfFeedWithSuccess:^(NSArray *arrayMedia, InstagramPaginationInfo *paginationInfo) {
            
            [SVProgressHUD dismiss];
            NSLog(@"Instagram Data: %@", arrayMedia);
            for (int i = 0; i < arrayMedia.count; i++) {
                InstagramMedia *media = arrayMedia[i];
                [arrayThumbnail addObject:[media.thumbnailURL absoluteString]];
                [arrayOrigin addObject:[media.standardResolutionImageURL absoluteString]];
            }
            [self.collectionViewGallery reloadData];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Failure: %@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }];
    } else {
        //
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please signup with an Instagram account in Profile Setting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

/**
 * Load collection from Twitter
 */

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController
            isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)loadFromTwitter {
    
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 ACAccount *account = [twitterAccounts lastObject];
                 if (!account) {
                     [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please singin with an twitter account on Settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                 }
                 
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/user_timeline.json"];
                 NSDictionary *params = @{@"screen_name" : account.username,
                                          @"include_rts" : @"0",
                                          @"trim_user" : @"1",
                                          @"count" : @"1000"};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:account];
                 
                 //  Step 3:  Execute the request
                 [SVProgressHUD showWithStatus:@"Loading"];
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error) {
                      
                      //
                      [SVProgressHUD dismiss];
                      //
                      if (error) {
                          NSLog(@"Error: %@", error);
                          
                          [[[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Error: %@", error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                      } else {
                          NSLog(@"Response Data: %@", [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil]);
                          if (responseData) {
                              if (urlResponse.statusCode >= 200 &&
                                  urlResponse.statusCode < 300) {
                                  
                                  NSError *jsonError;
                                  NSDictionary *timelineData =
                                  [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:NSJSONReadingAllowFragments error:&jsonError];
                                  if (timelineData) {
                                      // get image url
                                      NSArray *arrayImage = [timelineData valueForKeyPath:@"extended_entities.media.media_url"];
                                      for (int i = 0; i < arrayImage.count; i++) {
                                          if (arrayImage[i] != [NSNull null]) {
                                              NSString *string = arrayImage[i][0];
                                              NSString *imgeUrlString = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                              [arrayThumbnail addObject:[NSString stringWithFormat:@"%@:thumb", imgeUrlString]];
                                              [arrayOrigin addObject:[NSString stringWithFormat:@"%@:medium", imgeUrlString]];
                                          }
                                      }
                                      NSLog(@"Image url: %@", arrayOrigin);
                                      [self.collectionViewGallery reloadData];
                                  }
                                  else {
                                      // Our JSON deserialization went awry
                                      NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                  }
                              }
                              else {
                                  // The server did not respond ... were we rate-limited?
                                  NSLog(@"The response status code is %ld",
                                        (long)urlResponse.statusCode);
                              }
                          }
                      }
                  }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
                 [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please allow this app access twitter account on Setting application" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
             }
         }];
    }
}


#pragma mark - CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [arrayOrigin count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EXPGalleryCollectionViewCellIdentifier" forIndexPath:indexPath];
    //
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    [imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    [imageView setImageURL:[NSURL URLWithString:arrayThumbnail[indexPath.row]]];
    //
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *imageURL = [NSURL URLWithString:arrayOrigin[indexPath.row]];
    
    // Loading bigger image
    [SVProgressHUD showWithStatus:@"Loading origin image"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            // Update the UI
            UIImage *image = [UIImage imageWithData:imageData];
            CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
            editor.delegate = self;
            CLImageToolInfo *tonalTool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
            tonalTool.available = NO;
            
            CLImageToolInfo *adjustmentTool = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:NO];
            adjustmentTool.available = NO;
            
            CLImageToolInfo *effectTool = [editor.toolInfo subToolInfoWithToolName:@"CLEffectTool" recursive:NO];
            effectTool.available = NO;
            
            CLImageToolInfo *blurTool = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:NO];
            blurTool.available = NO;
            
            NSArray *array = [editor.toolInfo subtools];
            for (CLImageToolInfo *tool in array) {
                NSLog(@"%@",tool.toolName);
            }
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:editor animated:YES];
            // show navigation bar again
            gotoEditMode = YES;
        });
    });
}

#pragma mark - image editor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    // disable edit controller
    
    //
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:@"Success"];
}

@end
