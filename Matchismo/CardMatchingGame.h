//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ryan on 4/9/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)newGame:(Deck *)deck;
- (void)newGame:(Deck *)deck usingMatchNum:(NSInteger)matchNum;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)setMatchNum:(NSInteger)matchNum;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger recentScore;
@property (nonatomic, readonly) NSArray *previousChosenCards;
@end
