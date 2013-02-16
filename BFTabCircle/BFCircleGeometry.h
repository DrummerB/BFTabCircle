//
//  BFCircleGeometry.h
//  Demo
//
//  Created by Balázs Faludi on 16.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BFCircleGeometry : NSObject

+ (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(CGFloat)radius atAngle:(CGFloat)angle;
+ (CGFloat)angleOfPoint:(CGPoint)point onCircleWithCenter:(CGPoint)center;

@end
