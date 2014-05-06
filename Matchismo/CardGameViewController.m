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
@property (strong, nonatomic) IBOutlet UIDynamicAnimator *stackCards;
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
    [_game setMatchNum:self.matchNumber];
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
    self.stackCards = nil;
    [self updateUI];
}

- (void)updateUI {
    // see if a view exists for a given card and if not add a view
    for (NSUInteger indexOfCard = 0; indexOfCard < (int) self.game.dealtCardNum; indexOfCard++){
        Card *card = [self.game cardAtIndex:indexOfCard];
        UIView *currentCardView;
        NSUInteger indexOfView = [self.activeCards indexOfObjectPassingTest:^BOOL(id obj, NSUInteger index, BOOL *done) {
            UIView* tmpView = (UIView*) obj;
            if(tmpView.tag != indexOfCard)
                return NO;
            return YES;
        }];
        if (indexOfView == NSIntegerMax){
            if(!card.matched){
                currentCardView = [self makeCardView:card];
                [currentCardView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(touchCard:)]];
                [self.activeCards addObject:currentCardView];
                indexOfView = [self.activeCards indexOfObject:currentCardView];
                [self.cardGridView addSubview:currentCardView];
                currentCardView.tag = indexOfCard;
            }
        } else {
                currentCardView = self.activeCards[indexOfView];
                if (card.matched){
                    if (self.removeCardWhenMatched){
                        [self.activeCards removeObject:currentCardView];
                        [UIView animateWithDuration:1.3
                                              delay:0.3
                                            options:UIViewAnimationOptionTransitionCrossDissolve
                                         animations:^{
                                             currentCardView.alpha = 0.0;
                                         } completion:^(BOOL finished){
                                             [currentCardView removeFromSuperview];
                                         }];
                    } else {
                        currentCardView.alpha = 0.6;
                    }
                } else {
                    [self updateView:currentCardView card:card];
                }
            }
        }
    
    // once all active cards are found place them in the grid
    self.cardGrid.minimumNumberOfCells = [self.activeCards count];
    
    for(NSUInteger i = 0; i < [self.activeCards count]; i++){
        NSUInteger row = i / self.cardGrid.columnCount;
        NSUInteger column = i % self.cardGrid.columnCount;
        CGRect currentFrame = [self.cardGrid frameOfCellAtRow:row
                                                    inColumn:column];
        currentFrame = CGRectInset(currentFrame, currentFrame.size.width*SPACING, currentFrame.size.height*SPACING);
        [UIView animateWithDuration:1.3
                              delay:0.3
                            options:UIViewAnimationOptionTransitionCurlUp
                         animations:^{
                             UIView *tmp = (UIView *)self.activeCards[i];
                             tmp.frame = currentFrame; }
                         completion:NULL];
    }
    
    // update score
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (UIView *)makeCardView:(Card *)card {
    UIView *view = [[UIView alloc] init];
    [self updateView:view card:card];
    return view;
}

- (void)touchCard:(UITapGestureRecognizer *)tap {
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        Card *card = [self.game cardAtIndex:tap.view.tag];
        if (!card.matched && !self.stackCards) {
            [self.game chooseCardAtIndex:tap.view.tag];
            
            [UIView transitionWithView:tap.view
                              duration:0.4
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                [self updateView:tap.view card:card];
                            }
                            completion:^(BOOL finished){
                                card.chosen = !card.chosen;
                                [self.game chooseCardAtIndex:tap.view.tag];
                                [self updateUI];
                            }];
        }
    }
    self.stackCards = nil;
    [self updateUI];
}
- (IBAction)dealThreeNewCards:(UIButton *)sender {
    for (int i = 0; i < 3; i++)
        [self.game drawCard];
    if ([self.game emptyDeck])
        sender.enabled = NO;
    self.stackCards = nil;
    [self updateUI];
}

- (IBAction)createCardStack:(UIPinchGestureRecognizer *)pinch {
    if ((pinch.state == UIGestureRecognizerStateChanged)){
        if (!self.stackCards) {
            self.stackCards= [[UIDynamicAnimator alloc] initWithReferenceView:self.cardGridView];
            for (UIView* view in self.activeCards) {
                [self.stackCards addBehavior:[[UISnapBehavior alloc]
                                              initWithItem:view
                                              snapToPoint:self.cardGridView.center]];
            }
        }
    }
}

- (IBAction)moveStack:(UIPanGestureRecognizer *)pan {
    CGPoint panLocation = [pan locationInView:self.cardGridView];
    if (self.stackCards) {
        for (UIView *currentView in self.activeCards) {
            if (pan.state == UIGestureRecognizerStateBegan)
                [self.stackCards addBehavior:[[UIAttachmentBehavior alloc] initWithItem:currentView
                                                                       attachedToAnchor:panLocation]];
            else if (pan.state == UIGestureRecognizerStateEnded)
                [self.stackCards addBehavior:[[UISnapBehavior alloc] initWithItem:currentView
                                                                      snapToPoint:panLocation]];
        }
        for (UIDynamicBehavior *dynamicBehavior in self.stackCards.behaviors){
            if (pan.state == UIGestureRecognizerStateBegan) {
                if ([dynamicBehavior isKindOfClass:[UISnapBehavior class]])
                    [self.stackCards removeBehavior:dynamicBehavior];
            } else if (pan.state == UIGestureRecognizerStateChanged) {
                if ([dynamicBehavior isKindOfClass:[UIAttachmentBehavior class]])
                    ((UIAttachmentBehavior *)dynamicBehavior).anchorPoint = panLocation;
            } else if (pan.state == UIGestureRecognizerStateEnded) {
                if ([dynamicBehavior isKindOfClass:[UIAttachmentBehavior class]])
                    [self.stackCards removeBehavior:dynamicBehavior];
            }
        }
    }
}

- (void)updateView:(UIView *)view card:(Card*)card{
    //do nothing
}

// if phone changes orientation set grid size to card grid view size
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.cardGrid.size = self.cardGridView.bounds.size;
    [self updateUI];
}

-(void)willRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.cardGrid.size = self.cardGridView.bounds.size;
    [self updateUI];
}



- (BOOL)shouldAutomaticallyForwardRotationMethods { return YES;}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.matchNumber = 2;
    
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

- (void)viewWillAppear {
    self.cardGrid.size = self.cardGridView.bounds.size;
    [self updateUI];
}
@end
