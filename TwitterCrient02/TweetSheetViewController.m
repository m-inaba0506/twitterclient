//
//  TweetSheetViewController.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//

#import "TweetSheetViewController.h"

@interface TweetSheetViewController ()

@end

@implementation TweetSheetViewController

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
    self.accountStore = [[ACAccountStore alloc] init];
    self.tweetTextView.text = self.name;
    // [_tweetTextView setText:[_tweetTextView.text stringByAppendingString:_name]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tweetAction:(id)sender {
    ACAccountType *twitterType =
    
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (responseData) {
            
            NSInteger statusCode = urlResponse.statusCode;
            
            if (statusCode >= 200 && statusCode < 300) {
                
                NSDictionary *postResponseData =
                
                [NSJSONSerialization JSONObjectWithData:responseData
                 
                                                options:NSJSONReadingMutableContainers
                 
                                                  error:NULL];
                
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
                
            }
            
            else {
                
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                
            }
            
        }
        
        else {
            
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                NSLog(@"Tweet Sheet has been dismissed.");
                
            }];
            
        });
        
    };
    
    
    
    NSString *tweetString = self.tweetTextView.text;
    
    
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    
    ^(BOOL granted, NSError *error) {
        
        if (granted) {
            
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          
                          @"/1.1/statuses/update.json"];
            
            NSDictionary *params = @{@"status" : tweetString};
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                  
                                                    requestMethod:SLRequestMethodPOST
                                  
                                                              URL:url
                                  
                                                       parameters:params];
            
            [request setAccount:[accounts lastObject]];
            
            [request performRequestWithHandler:requestHandler];
            
        }
        
        else {
            
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  
                  [error localizedDescription]);
            
        }
        
    };
    
    
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
     
                                               options:NULL
     
                                            completion:accountStoreHandler];
    
    [self.navigationController popViewControllerAnimated:YES];//前の画面に戻る
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    //viewが表示されたらすぐキーボード表示
    if ([_tweetTextView canBecomeFirstResponder])
    {
        [_tweetTextView becomeFirstResponder];
    }
    
}
@end
