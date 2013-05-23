//
//  WebViewController.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/21.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

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
    _webView.scalesPageToFit = YES;
	_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    

    //進む戻るのボタンを無効化
    _gobutton.enabled = NO;
	_backbutton.enabled = NO;
    
    
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:self.openURL];
    
    [self.webView loadRequest:myRequest];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {//ページのロードが開始
    
    [self.activityIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {//ページのロードが終了
    
    [self.activityIndicator stopAnimating];
   
    // ページの「進む」および「戻る」が可能かチェックし、各ボタンの有効／無効を指定する。
	_backbutton.enabled = [webView canGoBack];
	_gobutton.enabled = [webView canGoForward];
    
}

- (void)webView:(UIWebView*)webView

    didFailLoadWithError:(NSError*)error {
    
    [self.activityIndicator stopAnimating];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender {
    [_webView goForward];//1ページ戻る
}

- (IBAction)back:(id)sender {
    [_webView goBack];//1ページ進む
}
@end
