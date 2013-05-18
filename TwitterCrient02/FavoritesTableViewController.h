//
//  FavoritesTableViewController.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/18.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TimeLineCell.h"
#import "TweetSheetViewController.h"
#import "ReplyTweetSheetViewController.h"

@interface FavoritesTableViewController : UITableViewController/*<UIGestureRecognizerDelegate>*/<UIActionSheetDelegate>
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *timelineData;
@property dispatch_queue_t mainQueue;
@property dispatch_queue_t imageQueue;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifier;



@property (nonatomic, strong) NSArray *twitterAccounts;

@end