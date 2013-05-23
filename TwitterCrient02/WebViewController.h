//
//  WebViewController.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/21.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSURL *openURL;
- (IBAction)go:(id)sender;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *gobutton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backbutton;
@end
