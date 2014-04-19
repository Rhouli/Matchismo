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
    }
    if ( score == [otherCards count])
        return score*4;
    return 0;
}

- (NSString *)contents
{
    return nil;
}
+ (NSArray *)validSymbols
{
    return @[@"■",@"●",@"▲"];
}


@end
