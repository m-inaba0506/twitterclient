//
//  MyUIApplication.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/21.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import "MyUIApplication.h"

@implementation MyUIApplication

- (BOOL)openURL:(NSURL *)url

{
    if (!url) {
        return NO;
    }
    
    self.myOpenURL = url;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                
                                                         bundle:[NSBundle mainBundle]];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UINavigationController *navigationController = appDelegate.navigationController;
    
    
    WebViewController *webViewController =
    
    [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    
    
    
    webViewController.openURL = self.myOpenURL;
    
    webViewController.title = @"Web View";
    
    [navigationController pushViewController:webViewController animated:YES];
    
    
    
    self.myOpenURL = nil;
    
    
    
    return YES;
    
}
@end