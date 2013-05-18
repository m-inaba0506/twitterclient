//
//  ReplyTweetSheetViewController.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TweetSheetViewController.h"
#import "ReplyTweetSheetViewController.h"


@interface ReplyTweetSheetViewController : UIViewController
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
- (IBAction)tweetAction:(id)sender;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *in_reply_to_status_id;
@property (nonatomic, copy) NSString *identifier;
@end
