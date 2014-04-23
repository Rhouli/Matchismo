//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/4/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

#define FONT_SIZE 14
#define FONT_HELVETICA @"Helvetica-Light"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *changeMatchNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *displayGameInfo;
@end

@implementation CardGameViewController

@synthesize cardButtons;

- (CardMatchingGame *)game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    [_game setMatchNum:[[self.changeMatchNumberButton titleForSegmentAtIndex:[self.changeMatchNumberButton selectedSegmentIndex]] integerValue]];
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
    //Create a new game
    [self.game newGame:[self createDeck]];
    [self updateUI];
    self.displayGameInfo.text = @"";
    self.gameHistory = nil;
    // enable match selector
    _changeMatchNumberButton.userInteractionEnabled = YES;
    self.game = nil;
}

// change the match number to form 2->3 or 3->2 and then restart the game
// and update the UI
- (void)changeMatchNumber:(UISegmentedControl*)sender {
    // Match the selected button to its corresponding matchNumber
    [self.game setMatchNum:[[sender titleForSegmentAtIndex:[sender selectedSegmentIndex]] integerValue]];
}

- (void)updateUI {
    // update buttons
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons
                               indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        [cardButton setAttributedTitle:[self titleForCard:card showContents:NO] forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
    }
    // update score and display previous move
    self.displayGameInfo.attributedText = [self titleForGameInfo:self.game.score];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // add display to history
    if (![self.displayGameInfo.text isEqualToString:@""])
        [self.gameHistory addObject:self.displayGameInfo.attributedText];
}

// find output of the last move. Prints out nothing if we have no selection
- (NSAttributedString *)titleForGameInfo:(NSInteger) score {
    UIFont *font = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];

    NSMutableAttributedString *outputString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSFontAttributeName:font}];

    if ([self.game.previousChosenCards count] > 0){
        // add all cards names to attributedString
        for(Card* card in self.game.previousChosenCards){
            [outputString appendAttributedString:[self titleForCard:card showContents:YES]];
            [outputString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{ NSFontAttributeName:font}]];
        }
        // If we have a match print there was a match
        if (self.game.recentScore > 0)
            [outputString appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"are a match! %d points awarded!",self.game.recentScore] attributes:@{ NSFontAttributeName:font}]];
        // if we have a mismatch print there was a mismatch
        else if (self.game.recentScore < 0){
            [outputString appendAttributedString:[[NSAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"don't match! %d point penalty!", abs(self.game.recentScore)] attributes:@{ NSFontAttributeName:font}]];
            // if too few cards are selected output only the selected cards
        } else {
            if([self.game.previousChosenCards count] == 1){
                [outputString appendAttributedString:[[NSAttributedString alloc] initWithString:@"is selected." attributes:@{ NSFontAttributeName:font}]];
            }
            else {
                [outputString appendAttributedString:[[NSAttributedString alloc] initWithString:@"are selected." attributes:@{ NSFontAttributeName:font}]];
            }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *selected0 = [UIImage imageNamed:@"PlayingCardTabIconSelected"];
    UIImage *unselected0 = [UIImage imageNamed:@"PlayingCardTabIcon"];
    
    UIImage *selected1 = [UIImage imageNamed:@"SetCardTabIconSelected"];
    UIImage *unselected1 = [UIImage imageNamed:@"SetCardTabIcon"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    
    [item0 setFinishedSelectedImage:selected0 withFinishedUnselectedImage:unselected0];
    [item1 setFinishedSelectedImage:selected1 withFinishedUnselectedImage:unselected1];
}

@end
