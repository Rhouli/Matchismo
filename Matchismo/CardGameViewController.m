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
@property (weak, nonatomic) IBOutlet UILabel *displayGameInfo;
@property (strong, nonatomic) NSMutableArray *cardIgnore;
@property (strong, nonatomic) NSMutableArray *gameHistory;
@property (weak, nonatomic) IBOutlet UISlider *slider;
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

- (NSMutableArray *)cardIgnore {
    if(!_cardIgnore) _cardIgnore = [[NSMutableArray alloc] init];
    return _cardIgnore;
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
    self.displayGameInfo.textAlignment = NSTextAlignmentCenter;
    self.displayGameInfo.text = [self titleForGameInfo:self.game.score];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    int firstRound = 0;

    // update buttons
    for (UIButton *cardButton in self.cardButtons) {
        if(cardButton.titleLabel.text == nil)
            firstRound++;
        int cardButtonIndex = [self.cardButtons
                               indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];

        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        NSLog(@"%@", [self titleForCard:card]);
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    // add display to history
    if (![self.displayGameInfo.text isEqualToString:@""]){
        [self.gameHistory addObject:self.displayGameInfo.text];
        [self changeSliderRange];
    }
    if (firstRound == [self.cardButtons count])
        self.displayGameInfo.text = [self titleForGameInfo:self.game.score];
    self.previousScore = self.game.score;
}

// find output of the last move. Prints out nothing if we have no selection
- (NSString *)titleForGameInfo:(NSInteger) score {
    NSMutableOrderedSet *cards = [NSMutableOrderedSet orderedSet];
    int matchNumber = [[(UISegmentedControl*)self.changeMatchNumberButton titleForSegmentAtIndex: [self.changeMatchNumberButton selectedSegmentIndex]] integerValue];
    
    // Check for active cards
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons
                               indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        // if card was recentley chosen and was not previously matched select it
        if (card.chosen && ![self.cardIgnore containsObject:card] ){
            [cards addObject:card];
        // if there was a mismatch select the unselected cards that didnt match
        } else if (!card.matched && ![cardButton.titleLabel.text isEqual:@" "]){
            [cards addObject:card];
        }
    }
    
    // User has unselected a card so remove card from output
    if([cards count] < matchNumber){
        NSMutableArray *toBeRemoved = [NSMutableArray array];
        for (Card* card in cards){
            if(!card.chosen)
                [toBeRemoved addObject:card];
        }
        [cards removeObjectsInArray:toBeRemoved];
    }
    
    NSString* outputString = @"";
    // If we have a match print there was a match
    if ([cards count] == matchNumber && [[cards firstObject] isMatched]) {
        outputString = [NSString stringWithFormat:@"Matched "];
        for(Card* card in cards) {
            outputString = [outputString stringByAppendingString:[card.contents stringByAppendingString:@" "]];
            [self.cardIgnore addObject:(card)];
        }
        outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"for %d points!",score-self.previousScore ]];
    // if we have a mismatch print there was a mismatch
    } else if ([cards count] == matchNumber){
        for(Card* card in cards)
            outputString = [outputString stringByAppendingString:[card.contents stringByAppendingString:@" "]];
        outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"don't match! %d point penalty!", abs(score-self.previousScore)]];
    // if too few cards are selected output only the selected cards
    } else if ([cards count] < matchNumber && [cards count] >= 1){
        for(Card* card in cards)
            outputString = [outputString stringByAppendingString:[card.contents stringByAppendingString:@" "]];
        if([cards count] == 1)
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"is selected"]];
        else
            outputString = [outputString stringByAppendingString:[NSString stringWithFormat:@"are selected"]];
    }
    return outputString;
}

- (void)viewHistory:(id)sender {
    int sliderVal = lroundf([self.slider value]);
    if([self.gameHistory count]){
        if(sliderVal+1 < [self.gameHistory count]){
            [self.displayGameInfo setText:[self.gameHistory objectAtIndex:sliderVal]];
            [self.displayGameInfo setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.3]];
        } else
            [self.displayGameInfo setBackgroundColor:(UIColor.clearColor)];
    }
}

- (void)changeSliderRange {
    int maxVal = [self.gameHistory count] -1;
    [self.slider setMaximumValue:maxVal] ;
    [self.slider setValue:maxVal animated:YES];
}


- (NSString *)titleForCard:(Card *)card {
    return card.isChosen ? card.contents: @" ";
}
- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}
@end
