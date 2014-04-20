//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/4/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

#define FONT_SIZE 16
#define FONT_HELVETICA @"Helvetica-Light"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *changeMatchNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *displayGameInfo;
@property NSInteger previousScore;
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

- (NSMutableArray *)gameHistory {
    if(!_gameHistory) _gameHistory = [[NSMutableArray alloc] init];
    return _gameHistory;
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
    self.displayGameInfo.text = @"";
    self.gameHistory = nil;
    // enable match selector
    _changeMatchNumberButton.userInteractionEnabled = YES;
}

// change the match number to form 2->3 or 3->2 and then restart the game
// and update the UI
- (IBAction)changeMatchNumber:(id)sender {
    // Figure out which button is selected
    NSString *text = [(UISegmentedControl*)sender titleForSegmentAtIndex: [sender selectedSegmentIndex]];
    
    // Match the selected button to its corresponding matchNumber
    int matchNumber = [text integerValue];
    [self.game setMatchNum:matchNumber];
}

- (void)updateUI {
    self.displayGameInfo.attributedText = [self titleForGameInfo:self.game.score];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // update buttons
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons
                               indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [cardButton setAttributedTitle:[self titleForCard:card showContents:NO] forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
    }
    // add display to history
    if (![self.displayGameInfo.text isEqualToString:@""])
        [self.gameHistory addObject:self.displayGameInfo.attributedText];
    self.previousScore = self.game.score;
}

// find output of the last move. Prints out nothing if we have no selection
- (NSAttributedString *)titleForGameInfo:(NSInteger) score {
    NSMutableOrderedSet *cards = [NSMutableOrderedSet orderedSet];
    int matchNumber = [[(UISegmentedControl*)self.changeMatchNumberButton
                        titleForSegmentAtIndex:[self.changeMatchNumberButton selectedSegmentIndex]] integerValue];
    
    // Check for active cards
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons
                               indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        // if card is selected add it. If it is not chosen unselect it
        if (card.selected){
            [cards addObject:card];
            if (!card.chosen)
                card.selected = NO;
        }
    }
    // User has unselected a card so remove card from output
    if([cards count] < matchNumber){
        NSMutableArray *toBeRemoved = [NSMutableArray array];
        for (Card* card in cards){
            if(!card.chosen){
                [toBeRemoved addObject:card];
            }
        }
        [cards removeObjectsInArray:toBeRemoved];
    }
    
    UIFont *font = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    // add all cards names to attributedString
    NSMutableAttributedString *outputString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSFontAttributeName:font}];
    if ([cards count] <= matchNumber && [cards count] >= 1){
        for(Card* card in cards){
            [outputString appendAttributedString:[self titleForCard:card showContents:YES]];
            [outputString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{ NSFontAttributeName:font}]];
            
            if ([cards count] == matchNumber && [[cards firstObject] isMatched])
                card.selected = NO;
        }
    }
    // If we have a match print there was a match
    if ([cards count] == matchNumber && [[cards firstObject] isMatched]) {
        [outputString appendAttributedString:[[NSAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"are a match! %d points awarded!",score-self.previousScore] attributes:@{ NSFontAttributeName:font}]];
    // if we have a mismatch print there was a mismatch
    } else if ([cards count] == matchNumber){
        [outputString appendAttributedString:[[NSAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"don't match! %d point penalty!", abs(score-self.previousScore)] attributes:@{ NSFontAttributeName:font}]];
    // if too few cards are selected output only the selected cards
    } else if ([cards count] < matchNumber && [cards count] >= 1){
        if([cards count] == 1){
            [outputString appendAttributedString:[[NSAttributedString alloc] initWithString:@"is selected." attributes:@{ NSFontAttributeName:font}]];
        }
        else {
            [outputString appendAttributedString:[[NSAttributedString alloc] initWithString:@"are selected." attributes:@{ NSFontAttributeName:font}]];
        }
    }
    return (NSAttributedString*) outputString;
}

- (NSAttributedString *)titleForCard:(Card *)card showContents:(BOOL)optional {
    return nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            [segue.destinationViewController setGameHistory:self.gameHistory];
        }
    }
}
@end
