//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Ryan on 4/4/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "HistoryViewController.h"

@interface CardGameViewController : UIViewController
@property (nonatomic) NSUInteger cardNumber;
@property (nonatomic) CGSize cardSize;
@property (nonatomic) BOOL removeCardWhenMatched;
@property (nonatomic) NSUInteger matchNumber;

// abstract
- (Deck *)createDeck;
- (void)updateUI;
@end
