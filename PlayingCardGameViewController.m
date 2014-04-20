//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/10/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

#define FONT_SIZE 14
#define FONT_HELVETICA @"Helvetica-Light"
#define BLACK [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]
#define RED [UIColor colorWithRed:1 green:0 blue:0 alpha:1]

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card showContents:(BOOL)optional{
    NSString* string;
    if (optional)
        string = card.contents;
    else
        string = card.isChosen ? card.contents: @" ";

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont * labelFont = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    
    UIColor * labelColor;
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"♥♦"];
    NSRange range = [string rangeOfCharacterFromSet:cset];
    if (range.location == NSNotFound)
        labelColor = BLACK;
    else
        labelColor = RED;

    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:string
                                  attributes:@{
                                             NSParagraphStyleAttributeName:paragraphStyle,
                                             NSFontAttributeName : labelFont,
                                             NSForegroundColorAttributeName : labelColor }];
    return labelText;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"PlayingCardFront" : @"PlayingCardBack"];
}
@end
