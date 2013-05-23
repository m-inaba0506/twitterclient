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
    
    
    // ツールバーの作成
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackTranslucent; // スタイルを設定
    [toolBar sizeToFit];
    
    // フレキシブルスペースの作成（Doneボタンを右端に配置したいため）
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    // syasinボタンの作成
    UIBarButtonItem *syasin = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(syasin:)];
    // syasindeleteボタンの作成
    UIBarButtonItem *syasindelete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(syasindelete:)];
    UIBarButtonItem *fixspacer = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
    fixspacer.width = 20.0;
    
    
    // ボタンをToolbarに設定
    NSArray *items = [NSArray arrayWithObjects:spacer,syasin,fixspacer,syasindelete, nil];
    [toolBar setItems:items animated:YES];
    
    // ToolbarをUITextFieldのinputAccessoryViewに設定
    _tweetTextView.inputAccessoryView = toolBar;
    
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
            
            NSURL *url;
            //NSLog(@"_image = %@", _image);
            if(_imageSelect){
                url = [NSURL URLWithString:@"https://api.twitter.com"@"/1.1/statuses/update_with_media.json"];
                NSLog(@"画像つき");
            }else{
                url = [NSURL URLWithString:@"https://api.twitter.com"@"/1.1/statuses/update.json"];
                NSLog(@"画像なし");
            }
            NSDictionary *params = @{@"status" : tweetString};
            
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                  
                                                    requestMethod:SLRequestMethodPOST
                                  
                                                              URL:url
                                  
                                                       parameters:params];
           ////////
            NSData *imageData = UIImagePNGRepresentation(_image);
            
            [request addMultipartData:imageData
             
                             withName:@"media[]"
             
                                 type:@"image/png"
             
                             filename:@"image.png"];
            ///////
            
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

-(void)syasindelete:(id)sender{
    
   for (UIView *view in [self.view subviews]) {
        [_imageSelect removeFromSuperview];
    }
      self.imageSelect.hidden = YES;
    _image = [UIImage imageNamed:@"blank.png"];
    UIImageView *imageSelect = [[UIImageView alloc] initWithImage:_image];
    imageSelect.frame = CGRectMake(265, 5, 48, 48);
    [self.view addSubview:imageSelect];
}

-(void)syasin:(id)sender{

    
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"写真を選択"
                            delegate:self
                            cancelButtonTitle:@"キャンセル"
                            destructiveButtonTitle:nil
                            otherButtonTitles:@"フォトライブラリー", @"カメラ", @"カメラロール", nil];
    [sheet showInView:self.view];
}
// アクションシートのデリゲートメソッド（アクションシートのボタンが押された時の処理）
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType sourceType;
    UIImagePickerController *ipc;
    
    switch (buttonIndex) {
        case 0:
            // フォトライブラリーを表示
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"フォトライブラリーを表示できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            ipc = [[UIImagePickerController alloc] init];
            [ipc setSourceType:sourceType];
            [ipc setDelegate:self];
            [self presentViewController:ipc animated:YES completion: nil];
            break;
            
        case 1:
            // カメラを起動
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"カメラを起動できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            ipc = [[UIImagePickerController alloc] init];
            [ipc setSourceType:sourceType];
            [ipc setDelegate:self];
            [self presentViewController:ipc animated:YES completion: nil];
            break;
            
        case 2:
            // カメラロールを表示
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"カメラロールを表示できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            ipc = [[UIImagePickerController alloc] init];
            [ipc setSourceType:sourceType];
            [ipc setDelegate:self];
            [self presentViewController:ipc animated:YES completion: nil];
            break;
            
        default:
            break;
    }
}

// アクションシートのデリゲートメソッド（画像を選択したあとの処理）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _userimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _image = _userimage;
    UIImageView *imageSelect = [[UIImageView alloc] initWithImage:_userimage];
    imageSelect.frame = CGRectMake(265, 5, 48, 48);
    [self.view addSubview:imageSelect];
    imageSelect.layer.masksToBounds = YES;                    //imageViewの角丸
    imageSelect.layer.cornerRadius = 7.0;                     //imageViewの角丸

    
    if ([picker respondsToSelector:@selector(presentingViewController)]) {
        [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
