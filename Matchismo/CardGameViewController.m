//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/4/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *changeMatchNumberButton;
@end

@implementation CardGameViewController

@synthesize cardButtons;

- (CardMatchingGame *)game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck {
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    // enable match selector
    _changeMatchNumberButton.userInteractionEnabled = NO;
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

// restart the game and update the UI
- (IBAction)ResetGame:(UIButton *)sender {
    // Create a new game
    [self.game newGame:[self createDeck]];
    [self updateUI];
    
    // enable match selector
    _changeMatchNumberButton.userInteractionEnabled = YES;
}

// change the match number to form 2->3 or 3->2 and then restart the game
// and update the UI
- (IBAction)changeMatchNumber:(id)sender {
    // Figure out which button is selected
    UISegmentedControl *segmentedControl = (UISegmentedControl*) sender;
    NSString *text = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    
    // Match the selected button to its corresponding matchNumber
    int matchNumber = [text integerValue];
    [self.game setMatchNum:matchNumber];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons
                               indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents: @"";
}
- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}
@end
