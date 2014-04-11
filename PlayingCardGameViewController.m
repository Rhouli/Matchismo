//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/10/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

@end
