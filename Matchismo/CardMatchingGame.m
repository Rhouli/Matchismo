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
@property (nonatomic, readwrite) NSInteger recentScore;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, readwrite) NSInteger matchNum;
@property (nonatomic, strong) NSArray *previousChosenCards;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int DEFAULT_MATCH_NUM = 2;

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)setMatchNum:(NSInteger)matchNum{
    _matchNum = matchNum;
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
    self.matchNum = DEFAULT_MATCH_NUM;
    return self;
}

// Starts a new game by re-dealing the cards and
// setting the score back to 0
- (void)newGame:(Deck *)deck {
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
    
    // set score back to 0
    self.score = 0;
}

- (void)newGame:(Deck *)deck usingMatchNum:(NSInteger)matchNum {
    [self newGame:deck];
    _matchNum = matchNum;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            NSMutableArray *tempArray = [self.previousChosenCards mutableCopy];
            [tempArray removeObject:card];
            self.previousChosenCards = [tempArray copy];
        } else {
            // count the number of chosen cards including the current card
            NSMutableArray *choosenCards = [NSMutableArray array];
            for (Card* otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched)
                    [choosenCards addObject:otherCard];
            }
            [choosenCards addObject:card];
            // iterate through each card and check if it matches with any of the
            // other cards
            self.recentScore = 0;
            self.previousChosenCards = choosenCards;
            if ([choosenCards count] == self.matchNum){
                self.recentScore = self.score;
                int matchScore = [[choosenCards firstObject] match:[choosenCards subarrayWithRange:NSMakeRange(1, [choosenCards count]-1)]];
                if (matchScore) {
                    self.score += matchScore*MATCH_BONUS;
                    for(Card* otherCard in choosenCards)
                        otherCard.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for(Card* otherCard in choosenCards){
                        otherCard.chosen = NO;
                    }
                }
                self.recentScore = self.score - self.recentScore;
            }
            card.chosen = YES;
            card.selected = YES;
            self.score -= COST_TO_CHOOSE;
        }
    }
}
@end
