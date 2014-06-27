//
//  GradientBackgroundView.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 27/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "GradientBackgroundView.h"

@implementation GradientBackgroundView

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColor = [UIColor colorWithRed: 0.09 green: 0.6 blue: 0.784 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithRed: 0.046 green: 0.287 blue: 0.375 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)gradientColor.CGColor,
                               (id)[UIColor colorWithRed: 0.079 green: 0.516 blue: 0.675 alpha: 1].CGColor,
                               (id)gradientColor2.CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.61, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    //// Abstracted Attributes
    CGRect rectangleRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(rectangleRect.size.width / 2, -0), CGPointMake(rectangleRect.size.width / 2, rectangleRect.size.height), 0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
