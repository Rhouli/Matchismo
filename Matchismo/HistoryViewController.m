//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Ryan on 4/20/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "HistoryViewController.h"

#define FONT_SIZE 14
#define FONT_HELVETICA @"Helvetica-Light"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *gameHistoryTextField;
@end

@implementation HistoryViewController

- (void)setGameHistory:(NSArray *)gameHistory {
    _gameHistory = gameHistory;
    if (self.view.window) [self updateUI];
}

- (void)updateUI {
    UIFont *font = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    
    if ([[self.gameHistory firstObject] isKindOfClass:[NSAttributedString class]]) {
        NSMutableAttributedString *gameHist = [[NSMutableAttributedString alloc] init];
        int x = [self.gameHistory count];
        for (NSAttributedString *move in self.gameHistory) {
            // state which move we are showing
            [gameHist appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Move %2d: ", x--] attributes:@{ NSFontAttributeName:font}]];
            // add in move
            [gameHist appendAttributedString:move];
            // add new line
            [gameHist appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        }
        // Change font size to be consistant
        
        NSMutableAttributedString *res = [gameHist mutableCopy];
        
        [res beginEditing];
        __block BOOL found = NO;
        [res enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, res.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                [res removeAttribute:NSFontAttributeName range:range];
                [res addAttribute:NSFontAttributeName value:font range:range];
                found = YES;
            }
        }];
        if (!found) {
            // No font was found - do something else?
        }
        [res endEditing];
        gameHist = res;
        [self.gameHistoryTextField setEditable:NO];
        [self.gameHistoryTextField setAttributedText:gameHist];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

@end
