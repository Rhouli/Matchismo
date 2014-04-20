//
//  SetCard.m
//  Matchismo
//
//  Created by Ryan on 4/18/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int)match:(NSArray *)otherCards {
    int score = 0;
    NSMutableArray *otherCardsM = [otherCards mutableCopy];
    for(SetCard* otherCard in otherCardsM) {
        if ([otherCard.symbol isEqual:self.symbol]) {
            score += 1;
        }
        otherCard.selected = YES;
    }
    return score*4;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.symbol, self.color, self.shade];
}

@synthesize symbol = _symbol, shade = _shade, color = _color;

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) _symbol = symbol;
}

- (NSString *)symbol
{
    return _symbol ? _symbol: @"?";
}


- (void)setShade:(NSString *)shade
{
    if ([[SetCard validShades] containsObject:shade]) _shade = shade;
}

- (NSString *)shade
{
    return _shade ? _shade: @"?";
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) _color = color;
}

- (NSString *)color
{
    return _color ? _color: @"?";
}

+ (NSArray *)validSymbols
{
    return @[@"■",@"●",@"▲"];
}

+ (NSArray *)validColors
{
    return @[@"red"];
}

+ (NSArray *)validShades
{
    return @[@"none"];
}

+ (int)maxNumber
{
    return 81/3;
}
@end
