//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ryan on 4/9/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
    self = [super init]; // super's designated initializer
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
         }
    }
    return self;
}

-(void)newGame:(Deck *)deck {
    int count = [self.cards count];
    NSMutableArray *discardItems = [NSMutableArray array];
    // remove cards in cards array
    for (Card *card in self.cards)
        [discardItems addObject:card];
    [self.cards removeObjectsInArray:discardItems];
    
    // add new cards to the cards array
    for (int i = 0; i < count; i++) {
        Card *card = [deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        } else {
            break;
        }
    }
    self.score = 0;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // match against other chosen cards
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.score += matchScore*MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                    }
                    break; // can only choose 2 cards for now
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}
@end
