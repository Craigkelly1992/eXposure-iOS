//
//  EXPTermOfUseViewController.m
//  exposure
//
//  Created by Binh Nguyen on 6/30/15.
//  Copyright (c) 2015 looper. All rights reserved.
//

#import "EXPTermOfUseViewController.h"

@interface EXPTermOfUseViewController ()

@end

@implementation EXPTermOfUseViewController {
    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Terms of Use";
    
    // Do any additional setup after loading the view.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    webView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [webView setDelegate:self];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"eXposure_Terms_of_Use"
                                                         ofType:@"docx"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.scalesPageToFit = YES;
    
    [self.view addSubview:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *document = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerText"];
    NSLog(@"%@",document);
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"eXposure_Terms_of_Use.docx"];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
//    {
////        NSString *path=[[NSBundle mainBundle] pathForResource:@"business_sample.docx" ofType:nil];
//        NSString *myPathInfo = [[NSBundle mainBundle] pathForResource:@"eXposure_Terms_of_Use" ofType:@"docx"];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager copyItemAtPath:myPathInfo toPath:myPathDocs error:NULL];
//    }
//    
//    //Load from File
//    NSString *myString = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
//    self.labelTermOfUse.text = myString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
