//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Ryan on 4/20/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *gameHistoryTextField;
@end

@implementation HistoryViewController

- (void)setGameHistory:(NSArray *)gameHistory {
    _gameHistory = gameHistory;
    if (self.view.window) [self updateUI];
}

- (void)updateUI {
    if ([[self.gameHistory firstObject] isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *gameHist = [[NSMutableAttributedString alloc] init];
        int x = [self.gameHistory count];
        for (NSAttributedString *move in self.gameHistory) {
            // state which move we are showing
            [gameHist appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Move %2d: ", x--]]];
            // add in move
            [gameHist appendAttributedString:move];
            // add new line
            [gameHist appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
        [self.gameHistoryTextField setEditable:NO];
        [self.gameHistoryTextField setAttributedText:gameHist];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

@end
