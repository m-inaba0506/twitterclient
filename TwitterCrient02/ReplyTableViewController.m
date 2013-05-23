//
//  ReplyTableViewController.m
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//
#import "ReplyTableViewController.h"

@interface ReplyTableViewController ()

@end

@implementation ReplyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    [super viewDidLoad];
    
    self.mainQueue = dispatch_get_main_queue();
    
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    self.accountStore = [[ACAccountStore alloc] init]; // アカウントストアの初期化
    
    // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"]; // この行はテーブルビューセルの再利用で必要（iOS6以降)
    [self.tableView registerClass:[TimeLineCell class] forCellReuseIdentifier:@"TimeLineCell"];
    [self aaa];
    
    
    //更新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(startDownload)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    //ここまで
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!self.timelineData) { // このif節は超重要！
        return 1;
    } else {
        return [self.timelineData count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iOS6以降のセル再利用のパターン
    
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLineCell" forIndexPath:indexPath];
    
    
    
    // Configure the cell...
    
    /*if (self.timelineData) {
     
     cell.tweetTextLabel.text = self.httpErrorMessage;
     
     cell.tweetTextLabelHeight = 24;
     
     } else*/ if (!self.timelineData) {
         
         cell.tweetTextLabel.text = @"Loading...";
         
         cell.tweetTextLabelHeight = 200;
         
     } else {
         
         NSString *name = [[[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];
         
         NSString *text = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
         
         
         
         CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:16]
                             
                             constrainedToSize:CGSizeMake(300, 1000)
                             
                                 lineBreakMode:NSLineBreakByWordWrapping];
         
         cell.tweetTextLabelHeight = labelSize.height;
         
         cell.tweetTextLabel.text = text;
         
         cell.nameLabel.text = name;
         
         
         
         cell.imageView.image = [UIImage imageNamed:@"blank.png"];
         
         
         
         UIApplication *application = [UIApplication sharedApplication];
         
         application.networkActivityIndicatorVisible = YES;
         
         
         
         dispatch_async(self.imageQueue, ^{
             
             NSString *url = [[[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"profile_image_url"];
             
             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
             
             dispatch_async(self.mainQueue, ^{
                 
                 UIApplication *application = [UIApplication sharedApplication];
                 
                 application.networkActivityIndicatorVisible = NO;
                 
                 UIImage *image = [[UIImage alloc] initWithData:data];
                 
                 cell.imageView.image = image;
                 
                 [cell setNeedsLayout];
                 
             });
             
         });
         
     }
    //  cell.imageView.contentMode = UIViewContentModeScaleAspectFit;//画像サイズに合わせてimageViewを貼り付ける
    cell.imageView.layer.masksToBounds = YES;                    //imageViewの角丸
    cell.imageView.layer.cornerRadius = 7.0;                     //imageViewの角丸
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSString *content = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16]
                           constrainedToSize:CGSizeMake(300, 1000)
                               lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 35;
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    // Navigation logic may go here. Create and push another view controller.
    
    TimeLineCell *cell = (TimeLineCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    detailViewController.name = cell.nameLabel.text;
    
    detailViewController.text = cell.tweetTextLabel.text;
    
    detailViewController.image = cell.imageView.image;
    
    detailViewController.identifier = self.identifier;
    
    detailViewController.idStr = [[self.timelineData objectAtIndex:indexPath.row] objectForKey:@"id_str"];
    
    // ...
    detailViewController.hidesBottomBarWhenPushed = YES;
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}



- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    [super viewDidLoad];
    
    //  Step 1:  Obtain access to the user's Twitter accounts
    
    ACAccountType *twitterType =
    
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
     
                                               options:NULL
     
                                            completion:^(BOOL granted, NSError *error) {
                                                
                                                if (granted) {
                                                    
                                                    //  Step 2:  Create a request
                                                    
                                                    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    
                                                    
                                                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"@"/1.1/statuses/home_timeline.json"];
                                                    
                                                    NSDictionary *params = @{@"count" : @"20",
                                                                             
                                                                             @"trim_user" : @"0",
                                                                             
                                                                             @"include_entities" : @"0"};
                                                    
                                                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                          
                                                                                            requestMethod:SLRequestMethodGET
                                                                          
                                                                                                      URL:url
                                                                          
                                                                                               parameters:params];
                                                    
                                                    
                                                    
                                                    //  Attach an account to the request
                                                    
                                                    [request setAccount:[twitterAccounts lastObject]];
                                                    
                                                    
                                                    
                                                    //  Step 3:  Execute the request
                                                    
                                                    [request performRequestWithHandler:^(NSData *responseData,
                                                                                         
                                                                                         NSHTTPURLResponse *urlResponse,
                                                                                         
                                                                                         NSError *error) { // ここからは別スレッド（キュー）
                                                        
                                                        if (responseData) {
                                                            
                                                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                                                
                                                                NSError *jsonError;
                                                                
                                                                self.timelineData =
                                                                
                                                                [NSJSONSerialization JSONObjectWithData:responseData
                                                                 
                                                                                                options:NSJSONReadingAllowFragments
                                                                 
                                                                                                  error:&jsonError];
                                                                
                                                                if (self.timelineData) {
                                                                    
                                                                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                                                                    dispatch_async(dispatch_get_main_queue(), ^{ // UI処理はメインキューで
                                                                        [self.tableView reloadData];
                                                                    });
                                                                }
                                                                else {
                                                                    // Our JSON deserialization went awry
                                                                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                                                }
                                                            }
                                                            else {
                                                                // The server did not respond successfully... were we rate-limited?
                                                                NSLog(@"The response status code is %d", urlResponse.statusCode);
                                                            }
                                                        }
                                                    }];
                                                }
                                                else {
                                                    // Access was not granted, or an error occurred
                                                    NSLog(@"%@", [error localizedDescription]);
                                                }
                                            }];
    self.tableView.dataSource = self;
    
}
-(void)startDownload{
    [self aaa];
    [self.refreshControl endRefreshing];
    
}
-(void)aaa
{
    
    ACAccountType *twitterType =
    
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
     
                                               options:NULL
     
                                            completion:^(BOOL granted, NSError *error) {
                                                
                                                if (granted) {
                                                    
                                                    //  Step 2:  Create a request
                                                    
                                                    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterType];
                                                    
                                                    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                                                                  
                                                                  @"/1.1/statuses/mentions_timeline.json"];
                                                    
                                                    NSDictionary *params = @{@"count" : @"20",
                                                                             
                                                                             @"trim_user" : @"0",
                                                                             
                                                                             @"include_entities" : @"0"};
                                                    
                                                    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                          
                                                                                            requestMethod:SLRequestMethodGET
                                                                          
                                                                                                      URL:url
                                                                          
                                                                                               parameters:params];
                                                    
                                                    
                                                    
                                                    //  Attach an account to the request
                                                    
                                                    [request setAccount:[twitterAccounts lastObject]];
                                                    
                                                    
                                                    
                                                    //  Step 3:  Execute the request
                                                    
                                                    [request performRequestWithHandler:^(NSData *responseData,
                                                                                         
                                                                                         NSHTTPURLResponse *urlResponse,
                                                                                         
                                                                                         NSError *error) { // ここからは別スレッド（キュー）
                                                        
                                                        if (responseData) {
                                                            
                                                            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                                                                
                                                                NSError *jsonError;
                                                                
                                                                self.timelineData =
                                                                
                                                                [NSJSONSerialization JSONObjectWithData:responseData
                                                                 
                                                                                                options:NSJSONReadingAllowFragments
                                                                 
                                                                                                  error:&jsonError];
                                                                
                                                                if (self.timelineData) {
                                                                    
                                                                    NSLog(@"Timeline Response: %@\n", self.timelineData);
                                                                    dispatch_async(dispatch_get_main_queue(), ^{ // UI処理はメインキューで
                                                                        [self.tableView reloadData];
                                                                    });
                                                                }
                                                                else {
                                                                    // Our JSON deserialization went awry
                                                                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                                                                }
                                                            }
                                                            else {
                                                                // The server did not respond successfully... were we rate-limited?
                                                                NSLog(@"The response status code is %d", urlResponse.statusCode);
                                                            }
                                                        }
                                                    }];
                                                }
                                                else {
                                                    // Access was not granted, or an error occurred
                                                    NSLog(@"%@", [error localizedDescription]);
                                                }
                                            }];
    self.tableView.dataSource = self;
}
@end