//
//  DetailViewController.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TweetSheetViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"


@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextView *nameView;
- (IBAction)retweetAction:(id)sender;
- (IBAction)favorite:(id)sender;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UILabel *fav;
@property (nonatomic, strong) NSArray *timelineData;

@property (nonatomic, strong) ACAccountStore *accountStore;
- (IBAction)replyAction:(id)sender;

@end
