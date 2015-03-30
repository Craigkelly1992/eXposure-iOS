//
//  CLFilterTool.m
//
//  Created by sho yakushiji on 2013/10/19.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import "CLFilterTool.h"

#import "CLFilterBase.h"


@implementation CLFilterTool
{
    UIImage *_originalImage;
    
    UIScrollView *_menuScroll;
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLFilterBase class]];
}

+ (NSString*)defaultTitle
{
    return [CLImageEditorTheme localizedString:@"CLFilterTool_DefaultTitle" withDefault:@"Filter"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    [self setFilterMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cleanup
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}

#pragma mark- 

- (void)setFilterMenu
{
    CGFloat W = 70;
    CGFloat x = 0;
    
    //get values
    NSString *totalXp = [Infrastructure sharedClient].total_xp;
    int totalXpVal = [totalXp intValue];
    int numberFilterUnlocked = 0;

    if(totalXpVal<=9){
        numberFilterUnlocked = 4;
    }else{
        if(totalXpVal<=19){
            numberFilterUnlocked = 5;
        }else{
            if(totalXpVal<=39){
                numberFilterUnlocked = 6;
            }else{
                if(totalXpVal<=69){
                    numberFilterUnlocked = 7;
                }else{
                    if(totalXpVal<=109){
                        numberFilterUnlocked = 8;
                    }else{
                        if(totalXpVal == 110){
                            numberFilterUnlocked = 9;
                        }else{
                            numberFilterUnlocked = 14;
                        }
                    }
                }
            }
        }
    }
    
    
    //process the iconimage
    UIImage *iconThumbnail = [_originalImage aspectFill:CGSizeMake(50, 50)];
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, _menuScroll.height) target:self action:@selector(tappedFilterPanel:) toolInfo:info];
        
        [_menuScroll addSubview:view];
        
        x += W;

        if(view.iconImage==nil){
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                UIImage *iconImage = [self filteredImage:iconThumbnail withToolInfo:info];
                [view performSelectorOnMainThread:@selector(setIconImage:) withObject:iconImage waitUntilDone:YES];

            });
            if(numberFilterUnlocked<=0)
            {
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    //create the image
                    view.userInteractionEnabled = false;
                    UIImage *imageKey  = [UIImage imageNamed:@"key.png"];
                    CGSize newSize = CGSizeMake(300, 300);
                    UIGraphicsBeginImageContext( newSize );
                    
                    [view.iconImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                    [imageKey drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
                    //create the new image
                    view.iconImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                });
            }else{
                numberFilterUnlocked--;
            }
        }

    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

- (void)tappedFilterPanel:(UITapGestureRecognizer*)sender
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    UIView *view = sender.view;
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage withToolInfo:view.toolInfo];
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}
- (UIImage*)filteredImage:(UIImage*)image withToolInfo:(CLImageToolInfo*)info
{
    @autoreleasepool {
        Class filterClass = NSClassFromString(info.toolName);
        if([(Class)filterClass conformsToProtocol:@protocol(CLFilterBaseProtocol)]){
            return [filterClass applyFilter:image];
        }
        return nil;
    }
}

@end
