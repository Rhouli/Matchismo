//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/18/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"
#import "SetCard.h"

@interface SetCardGameViewController ()
@end

@implementation SetCardGameViewController

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (UIView *)makeCardView:(Card *)card {
    SetCardView *newView = [[SetCardView alloc] init];
    [self updateView:newView card:card];
    return newView;
}

- (void)updateView:(UIView *)view card:(Card *)card {
    SetCardView *sCardView = (SetCardView *) view;
    SetCard *sCard = (SetCard *) card;
    
    sCardView.symbol = sCard.symbol;
    sCardView.number = [sCard.number intValue];
    sCardView.color = sCard.color;
    sCardView.shade = sCard.shade;
    sCardView.chosen = sCard.chosen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.matchNumber = 3;
    self.removeCardWhenMatched = YES;
    self.cardNumber = 12;
    self.cardSize = CGSizeMake(100.0, 100.0);
    [self updateUI];
}

@end
