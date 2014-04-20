//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/18/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

#define FONT_SIZE 20
#define FONT_HELVETICA @"Helvetica-Light"
#define BLACK [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1]
#define RED [UIColor colorWithRed:1 green:0 blue:0 alpha:1]

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController
- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card {
    NSString *string = card.contents;
    
    NSArray *contents = [string componentsSeparatedByString:@", "];
    
    NSString *symbol = [contents objectAtIndex:0];
    
    UIColor * labelColor;
    if ([[contents objectAtIndex:1] isEqualToString:@"red"]){
        labelColor = RED;
    }

    NSShadow *shadow = [[NSShadow alloc] init];
    if ([[contents objectAtIndex:2] isEqualToString:@"none"]){
        [shadow setShadowColor:BLACK];
        [shadow setShadowOffset:CGSizeMake (1.0, 0.0)];
        [shadow setShadowBlurRadius:1];
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont * labelFont = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:symbol
                                  attributes:@{
                                             NSParagraphStyleAttributeName:paragraphStyle,
                                             NSFontAttributeName : labelFont,
                                             NSForegroundColorAttributeName : labelColor,
                                             NSShadowAttributeName : shadow }];
    return labelText;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"SetCardSelected" : @"SetCard"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

@end
