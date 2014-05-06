//
//  PlayingCardView.h
//  SuperCard
//
//  Created by CS193p Instructor on 4/17/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;

// Built-in Gesture Handler
- (void)resizeFaceWithPinch:(UIPinchGestureRecognizer *)gesture;

@end
