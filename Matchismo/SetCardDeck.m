//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Ryan on 4/18/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if(self){
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSString *color in [SetCard validColors]){
                for (NSString *shade in [SetCard validShades]){
                    for (NSString *num in [SetCard validNum]){
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.color = color;
                        card.shade = shade;
                        card.number = num;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
