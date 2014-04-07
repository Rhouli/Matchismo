//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/4/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;

@end

@implementation CardGameViewController

@synthesize cardButtons;

- (Deck *)deck {
    if(!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}
- (IBAction)dealButton:(id)sender {
    _deck = [self createDeck];
    self.flipCount = 0;
    for(UIButton *button in self.cardButtons){
        [button setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
    }
}

/*- (void)setMatchLabel:(int)flipCount {
    NSMutableArray *cardTitles = [[NSMutableArray alloc] initWithCapacity:[cardButtons count]];
    for(UIButton *button in self.cardButtons){
        [cardTitles addObject:button.currentTitle];
    }
    for (int i = 0; i < [cardTitles count]-1; i++){
        for(int j = i; j < [cardTitles count]; j++){
            if (cardTitles[i][0] == cardTitles[j][0]){
                self.matchLabel.text = [NSString stringWithFormat:@"Ranks Match"];
            } else if (cardTitles[i][1] == cardTitles[j][1]){
                self.matchLabel.text = [NSString stringWithFormat:@"Suits Match"];
            }
        }
    }
}*/

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    if (self.flipCount == 52){
        self.flipsLabel.text = [NSString stringWithFormat:@"Deck is empty. Please re-deal."];

    }
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if ([sender.currentTitle length]){
        [sender setBackgroundImage:[UIImage imageNamed:@"cardback"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    } else {
        Card *randomCard = [self.deck drawRandomCard];
        if (randomCard) {
            [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"]
                          forState:UIControlStateNormal];
            [sender setTitle:randomCard.contents forState:UIControlStateNormal];
            self.flipCount++;
        }
    }
}

@end
