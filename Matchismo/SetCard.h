//
//  SetCard.h
//  Matchismo
//
//  Created by Ryan on 4/18/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shade;

+ (NSArray *)validSymbols;
+ (NSArray *)validColors;
+ (NSArray *)validShades;
+ (int)maxNumber;

@end
