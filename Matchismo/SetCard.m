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
    NSMutableOrderedSet *symbols = [[NSMutableOrderedSet alloc] init];
    [symbols addObject:self.symbol];
    NSMutableOrderedSet *num = [[NSMutableOrderedSet alloc] init];
    [num addObject:self.number];
    NSMutableOrderedSet *colors = [[NSMutableOrderedSet alloc] init];
    [colors addObject:self.color];
    NSMutableOrderedSet *shades = [[NSMutableOrderedSet alloc] init];
    [shades addObject:self.shade];

    for(SetCard* otherCard in otherCards) {
        [symbols addObject:otherCard.symbol];
        [num addObject:otherCard.number];
        [colors addObject:otherCard.color];
        [shades addObject:otherCard.shade];
    }
    int numCards = [otherCards count]+1;
    if (([symbols count] == numCards || [symbols count] == 1) &&
        ([num count] == numCards || [num count] == 1) &&
        ([colors count] == numCards || [colors count] == 1) &&
        ([shades count] == numCards || [shades count] == 1)){
        return 4;
    }
    return 0;
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@, %@, %@, %@", self.symbol, self.color, self.shade, self.number];
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

- (NSString *)number
{
    return _number ? _number: @"?";
}

+ (NSArray *)validSymbols
{
    return @[@"■",@"●",@"▲"];
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"purple"];
}

+ (NSArray *)validShades
{
    return @[@"solid", @"striped", @"open"];
}

+ (NSArray *)validNum
{
    return @[@"1", @"2", @"3"];
}
@end
