//
//  SetCardView.h
//  Matchismo
//
//  Created by Ryan on 5/5/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shade;

@property (nonatomic) BOOL chosen;
@end
