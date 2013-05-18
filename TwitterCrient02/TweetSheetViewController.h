//
//  TweetSheetViewController.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TweetSheetViewController : UIViewController
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
- (IBAction)tweetAction:(id)sender;
@property (nonatomic, copy) NSString *name;
@end
