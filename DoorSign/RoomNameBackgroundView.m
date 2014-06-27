//
//  RoomNameBackgroundView.m
//  DoorSign
//
//  Created by Patrick Quinn-Graham on 27/06/2014.
//  Copyright (c) 2014 Patrick Quinn-Graham. All rights reserved.
//

#import "RoomNameBackgroundView.h"

@implementation RoomNameBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* gradientColor =  [UIColor colorWithWhite:1.0 alpha:0.6];//[UIColor colorWithRed: 1 green: 0.992 blue: 0.992 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithWhite:1.0 alpha:0.5];//[UIColor colorWithRed: 0.959 green: 0.949 blue: 0.949 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.037 green: 0.245 blue: 0.321 alpha: 1];//[UIColor colorWithRed: 0.848 green: 0.848 blue: 0.848 alpha: 1];
    
    //// Gradient Declarations
    NSArray* lightGreyGradientColors = [NSArray arrayWithObjects:
                                        (id)gradientColor.CGColor,
                                        (id)gradientColor2.CGColor, nil];
    CGFloat lightGreyGradientLocations[] = {0, 1};
    CGGradientRef lightGreyGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)lightGreyGradientColors, lightGreyGradientLocations);
    
    //// Abstracted Attributes
    CGRect rectangleRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, lightGreyGradient, CGPointMake(rectangleRect.size.width / 2, -0), CGPointMake(rectangleRect.size.width / 2, rectangleRect.size.height), 0);
    CGContextRestoreGState(context);
    [color2 setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];
    
    
    //// Cleanup
    CGGradientRelease(lightGreyGradient);
    CGColorSpaceRelease(colorSpace);
    

}

@end
