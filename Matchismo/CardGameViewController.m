//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/4/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"

#define SPACING 0.04

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardGridView;
@property (strong, nonatomic) NSMutableArray *activeCards;
@property (weak, nonatomic) IBOutlet UIButton *threeNewCardsButton;
@property (strong, nonatomic) Grid *cardGrid;
@end

@implementation CardGameViewController

- (NSMutableArray *)activeCards {
    if(!_activeCards)
        _activeCards = [NSMutableArray arrayWithCapacity:self.cardNumber];
    return _activeCards;
        
}

- (CardMatchingGame *)game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardNumber
                                                         usingDeck:[self createDeck]];
    [_game setMatchNum:3];
    return _game;
}

- (Deck *)createDeck {
    return nil;
}

- (Grid *)cardGrid {
    if(!_cardGrid) {
        _cardGrid = [[Grid alloc] init];
        _cardGrid.size = self.cardGridView.frame.size;
        _cardGrid.minimumNumberOfCells = self.cardNumber;
        _cardGrid.maxCellWidth = self.cardSize.width;
        _cardGrid.maxCellHeight = self.cardSize.height;
        _cardGrid.cellAspectRatio = _cardGrid.maxCellWidth/_cardGrid.maxCellHeight;
    }
    
    return _cardGrid;
}
// restart the game and update the UI
- (IBAction)ResetGame:(UIButton *)sender {
    //Create a new game
    self.game = nil;
    for (UIView *card in self.activeCards) [card removeFromSuperview];
    self.activeCards = nil;
    self.threeNewCardsButton.enabled = YES;
    [self updateUI];
}

- (void)updateUI {
    // see if a view exists for a given card and if not add a view
    for (NSUInteger indexOfCard = 0; indexOfCard < (int) self.game.dealtCardNum; indexOfCard++){
        Card *card = [self.game cardAtIndex:indexOfCard];
        NSUInteger indexOfView = [self.activeCards indexOfObjectPassingTest:^BOOL(id obj, NSUInteger index, BOOL *done) {
            if(((UIView *) obj).tag == indexOfCard)
                return YES;
            return NO;
        }];
        UIView *currentCardView;
        if (indexOfView == NSNotFound){
            if(!card.matched){
                currentCardView = [self makeCardView:card];
                currentCardView.tag = indexOfCard;
                [currentCardView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(touchCard:)]];
                [self.activeCards addObject:currentCardView];
                indexOfView = [self.activeCards indexOfObject:currentCardView];
                [self.cardGridView addSubview:currentCardView];
                
            }
            else {
                currentCardView = self.activeCards[indexOfView];
                if (card.matched){
                    [currentCardView removeFromSuperview];
                    [self.activeCards removeObject:currentCardView];
                } else {
                    [self updateView:currentCardView card:card];
                }
            }
        }
    }
    self.cardGrid.minimumNumberOfCells = [self.activeCards count];
    for(NSUInteger i = 0; i < [self.activeCards count]; i++){
        CGRect currentFrame = [self.cardGrid frameOfCellAtRow:i / self.cardGrid.columnCount
                                                     inColumn:i % self.cardGrid.columnCount];
        currentFrame = CGRectInset(currentFrame, currentFrame.size.width*SPACING, currentFrame.size.height*SPACING);
        ((UIView *)self.activeCards[i]).frame = currentFrame;
    }
    
    // update grid when adding new cards
    
    
    // update score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (UIView *)makeCardView:(Card *)card {
    UIView *view = [[UIView alloc] init];
    [self updateView:view card:card];
    return view;
}

- (void)updateView:(UIView *)view card:(Card*)card {
    //view.backgroundColor = [UIColor blueColor];
}

- (void)touchCard:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self.game chooseCardAtIndex:tap.view.tag];
        Card *card = [self.game cardAtIndex:tap.view.tag];
       [UIView transitionWithView:tap.view
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                            [self updateView:tap.view card:card];
                       }
                        completion:^(BOOL finished){
                            card.chosen = !card.chosen;
                            [self.game chooseCardAtIndex:tap.view.tag];
                            [self updateUI];
                        }];
        [self updateUI];
    }
}
- (IBAction)dealThreeNewCards:(UIButton *)sender {
    for (int i = 0; i < 3; i++)
        [self.game drawCard];
    if ([self.game emptyDeck])
        sender.enabled = NO;
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.removeCardWhenMatched = NO;

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
