//
//  SetCardView.m
//  Matchismo
//
//  Created by Ryan on 5/5/14.
//  Copyright (c) 2014 Ryan Houlihan. All rights reserved.
//

#import "SetCardView.h"

#define SYMBOL_W 0.03
#define SYMBOL_SEPERATION 0.3

#define OVAL_W 0.10
#define OVAL_H 0.3
#define SQUIGGLE_W 0.10
#define SQUIGGLE_H 0.25
#define DIAMOND_W 0.14
#define DIAMOND_H 0.4

#define STRIPE_SEPERATION 0.04
#define STRIPE_RELATIVE_ANGLE 8

@implementation SetCardView

// setup
- (void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

// public functions

- (void)setNumber:(NSUInteger)number {
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol {
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shade {
    _shade = shade;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen {
    _chosen = chosen;
    [self setNeedsDisplay];
}

// draw card box
- (void)drawRect:(CGRect)rect {
    UIBezierPath *cardRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                             cornerRadius:12.0];
    [cardRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    if (!self.chosen) {
        [[UIColor colorWithWhite:0.8 alpha:1.0] setStroke];
        cardRect.lineWidth /= 4.0;
    } else {
        [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4] setFill];
        cardRect.lineWidth *= 4.0;
    }
    
    [cardRect stroke];
    [self drawSymbols];
}

// drawing the different symbols
- (void)drawSymbols {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [[self coloring] setStroke];
    if (self.number == 1) {
        [self drawSymbol:center];
        return;
    } else {
        CGFloat dx = self.bounds.size.width * SYMBOL_SEPERATION;
        CGFloat xStart = center.x - dx;
        CGFloat xEnd = center.x + dx;
        if(self.number == 2) {
            [self drawSymbol:CGPointMake(xStart+dx/2, center.y)];
            [self drawSymbol:CGPointMake(xEnd-dx/2, center.y)];
            return;
        } else if(self.number == 3) {
            [self drawSymbol:center];
            [self drawSymbol:CGPointMake(xStart, center.y)];
            [self drawSymbol:CGPointMake(xEnd, center.y)];
            return;
        }
    }
}
- (void)drawSymbol:(CGPoint)point {
    if ([self.symbol isEqualToString:@"diamond"])
        [self drawDiamond:point];
    else if ([self.symbol isEqualToString:@"oval"])
        [self drawOval:point];
    else if ([self.symbol isEqualToString:@"squiggle"])
        [self drawSquiggle:point];
}
- (void)drawDiamond:(CGPoint)point {
    CGFloat dx = self.bounds.size.width  * DIAMOND_W/2.0;
    CGFloat dy = self.bounds.size.height * DIAMOND_H/2.0;
    
    CGFloat xStart = point.x - dx;
    CGFloat yStart = point.y - dy;
    CGFloat xEnd = point.x + dx;
    CGFloat yEnd = point.y + dy;
    
    CGPoint left = CGPointMake(xStart, point.y);
    CGPoint right = CGPointMake(xEnd, point.y);
    CGPoint top = CGPointMake(point.x, yEnd);
    CGPoint bottom = CGPointMake(point.x, yStart);
    
    UIBezierPath *diamond = [[UIBezierPath alloc] init];
    [diamond moveToPoint:left];
    [diamond addLineToPoint:top];
    [diamond addLineToPoint:right];
    [diamond addLineToPoint:bottom];
    [diamond closePath];
    
    diamond.lineWidth = self.bounds.size.width*SYMBOL_W;
    [self shading:diamond];
    [diamond stroke];
}

- (void)drawOval:(CGPoint)point {
    CGFloat dx = self.bounds.size.width  * OVAL_W/2.0;
    CGFloat dy = self.bounds.size.height * OVAL_H/2.0;
    
    CGFloat xStart = point.x - dx;
    CGFloat yStart = point.y - dy;
    
    UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:
                          CGRectMake(xStart, yStart, 2.0*dx, 2.0*dy)
                                                    cornerRadius:dx];
    oval.lineWidth = self.bounds.size.width*SYMBOL_W;
    [self shading:oval];
    [oval stroke];
}

- (void)drawSquiggle:(CGPoint)point {
    CGFloat dx = self.bounds.size.width  * SQUIGGLE_W/2.0;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_H/2.0;
    CGFloat dxSquiggle = dx*0.9;
    CGFloat dySquiggle = dy*0.6;
    
    CGFloat xStart = point.x - dx;
    CGFloat yStart = point.y - dy;
    CGFloat xEnd = point.x + dx;
    CGFloat yEnd = point.y + dy;
    
    CGPoint bottomLeft = CGPointMake(xStart, yStart);
    CGPoint topLeft = CGPointMake(xStart, yEnd);
    CGPoint bottomRight = CGPointMake(xEnd, yStart);
    CGPoint topRight = CGPointMake(xEnd, yEnd);
    
    UIBezierPath *squiggle = [[UIBezierPath alloc] init];
    [squiggle moveToPoint:bottomLeft];
    [squiggle addQuadCurveToPoint:bottomRight
                      controlPoint:CGPointMake(point.x - dxSquiggle,
                                               yStart - dySquiggle)];
    [squiggle addCurveToPoint:topRight
            controlPoint1:CGPointMake(xEnd + dxSquiggle,
                                      yStart + dySquiggle)
            controlPoint2:CGPointMake(xEnd - dxSquiggle,
                                      yEnd - dySquiggle)];
    [squiggle addQuadCurveToPoint:topLeft
                  controlPoint:CGPointMake(point.x + dxSquiggle,
                                           point.y + dySquiggle)];
    [squiggle addCurveToPoint:bottomLeft
            controlPoint1:CGPointMake(xStart - dxSquiggle,
                                      yEnd + dySquiggle)
            controlPoint2:CGPointMake(xStart - dxSquiggle,
                                      yStart + dySquiggle)];
    
    squiggle.lineWidth = self.bounds.size.width*SYMBOL_W;
    [self shading:squiggle];
    [squiggle stroke];
}

// drawing the color

- (UIColor *)coloring {
    if ([self.color isEqualToString:@"purple"])
        return [UIColor purpleColor];
    else if ([self.color isEqualToString:@"red"])
        return [UIColor redColor];
    else if ([self.color isEqualToString:@"green"])
        return [UIColor greenColor];
    return nil;
}
// drawing the shade

- (void)shading:(UIBezierPath *)path {
    if ([self.shade isEqualToString:@"open"]){
        [[UIColor clearColor] setFill];
    } else if ([self.shade isEqualToString:@"solid"]){
        [[self coloring] setFill];
        [path fill];
    } else if ([self.shade isEqualToString:@"striped"]) {
        CGContextSaveGState(UIGraphicsGetCurrentContext());
        [path addClip];
        
        UIBezierPath *stripe = [[UIBezierPath alloc] init];
        CGFloat dy = self.bounds.size.height * STRIPE_SEPERATION;
        CGPoint beginning = self.bounds.origin;
        beginning.y += dy * STRIPE_RELATIVE_ANGLE;
        CGPoint end = self.bounds.origin;
        end.x += self.bounds.size.width;
        
        for (int i = 0; i < 1/STRIPE_SEPERATION; i++){
            [stripe moveToPoint:beginning];
            [stripe addLineToPoint:end];
            beginning.y += dy;
            end.y += dy;
        }
        
        stripe.lineWidth = self.bounds.size.width / 2 * SYMBOL_W;
        [stripe stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}
@end
