//
//  TimeLineCell.h
//  TwitterCrient02
//
//  Created by inaba masaya on 13/05/15.
//  Copyright (c) 2013年 inaba masaya. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell


@property (nonatomic, strong) UILabel *tweetTextLabel;

@property (nonatomic, strong) UILabel *nameLabel;

//@property (nonatomic, strong) UILabel *nameLabel2;

@property (nonatomic, strong) UIImageView *imageView;

//@property (nonatomic, strong) UIImageView *favimage;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic) int tweetTextLabelHeight;

@end