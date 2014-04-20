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

@property (strong, nonatomic) NSMutableArray *gameHistory;

// abstract
- (Deck *)createDeck;
- (NSAttributedString *)titleForCard:(Card *)card showContents:(BOOL)optional;
- (void)updateUI;
- (UIImage *)backgroundImageForCard:(Card *)card;
@end
