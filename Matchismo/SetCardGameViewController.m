//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Ryan on 4/18/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

#define FONT_SIZE 14
#define FONT_HELVETICA @"Helvetica-Light"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController
- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)titleForCard:(Card *)card showContents:(BOOL)optional{
    NSString *string = card.contents;
    
    NSArray *contents = [string componentsSeparatedByString:@", "];
    
    // find card shade
    float alphaNum = 1;
    NSNumber *strokeWidth = 0;
    if ([[contents objectAtIndex:2] isEqualToString:@"solid"]){
        strokeWidth = [NSNumber numberWithFloat:-5.0];
    } else if ([[contents objectAtIndex:2] isEqualToString:@"striped"]){
        strokeWidth = [NSNumber numberWithFloat:-5.0];
        alphaNum = 0.35;
    } else if ([[contents objectAtIndex:2] isEqualToString:@"open"]){
        strokeWidth = [NSNumber numberWithFloat:5.0];
    }
    
    // find card color
    UIColor * labelColor;
    if ([[contents objectAtIndex:1] isEqualToString:@"red"]){
        labelColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:alphaNum];;
    } else if ([[contents objectAtIndex:1] isEqualToString:@"green"]){
        labelColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:alphaNum];;
    } else if ([[contents objectAtIndex:1] isEqualToString:@"purple"]){
        labelColor = [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:alphaNum];;
    }
    
    // find card symbol number
    NSMutableString *symbol = [[NSMutableString alloc] init];
    switch([[contents objectAtIndex:3] integerValue]){
        case 1:
            [symbol appendString:[contents objectAtIndex:0]];
        case 2:
            [symbol appendString:[contents objectAtIndex:0]];
        case 3:
            [symbol appendString:[contents objectAtIndex:0]];
        default:
            break;
    }
    
    // create card
    NSLog(@"%d %@", [[contents objectAtIndex:3] integerValue], symbol);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont * labelFont = [UIFont fontWithName:FONT_HELVETICA size:FONT_SIZE];
    
    NSAttributedString *labelText = [[NSAttributedString alloc] initWithString:symbol
                                  attributes:@{
                                             NSParagraphStyleAttributeName:paragraphStyle,
                                             NSFontAttributeName : labelFont,
                                             NSForegroundColorAttributeName : labelColor,
                                             NSStrokeWidthAttributeName : strokeWidth}];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:@"History"]) {
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            [segue.destinationViewController setGameHistory:self.gameHistory];
        }
    }
}
@end
