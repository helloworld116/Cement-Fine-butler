//
//  BackgroundLayer.m
//  Demo
//
//  Created by 文正光 on 13-11-25.
//  Copyright (c) 2013年 Fengboyun. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer
//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.9 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.7 alpha:1.0];
    UIColor *colorFour = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.4 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.02];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.99];
    NSNumber *stopFour = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:0.75];
    UIColor *colorTwo = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:0.85];
    UIColor *colorThree = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:0.95];
    UIColor *colorFour = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:0.90];
    UIColor *colorFive = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:0.85];
    UIColor *colorSix = [UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:0.80];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, colorFive.CGColor,colorSix.CGColor,nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.2];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.4];
    NSNumber *stopFour = [NSNumber numberWithFloat:0.6];
    NSNumber *stopFive = [NSNumber numberWithFloat:0.8];
    NSNumber *stopSix = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo,stopThree,stopFour,stopFive,stopSix,nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}
@end
