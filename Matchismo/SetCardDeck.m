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

static const int DECKSIZE = 81;

- (instancetype)init
{
    self = [super init];
    
    if(self){
        for (NSAttributedString *symbol in [SetCard validSymbols]) {
            for (NSUInteger rank = 1; rank <= DECKSIZE/[[SetCard validSymbols] count]; rank++){
                SetCard *card = [[SetCard alloc] init];
                card.symbol = symbol;
                [self addCard:card];
            }
        }
    }
    return self;
}

@end
