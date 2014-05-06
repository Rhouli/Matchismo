//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/10/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (UIView *)makeCardView:(Card *)card {
    PlayingCardView *newView = [[PlayingCardView alloc] init];
    [self updateView:newView card:card];
    return newView;
}

- (void)updateView:(UIView *)view card:(Card *)card {
    PlayingCardView *pCardView = (PlayingCardView *) view;
    PlayingCard *pCard = (PlayingCard *) card;
    
    pCardView.rank = pCard.rank;
    pCardView.suit = pCard.suit;
    pCardView.faceUp = pCard.chosen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardNumber = 36;
    self.cardSize = CGSizeMake(100.0, 140.0);
    [self updateUI];
}

@end
