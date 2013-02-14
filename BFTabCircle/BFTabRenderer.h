//
//  BFTabCircleRenderer.h
//  Demo
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BFCircleOrientation) {
	BFCircleOrientationClockwise = 1,
	BFCircleOrientationCounterClockwise = -1
};

@interface BFTabRenderer : NSObject
+ (CGPoint)controlPointForPoint:(CGPoint)point circleCenter:(CGPoint)center orientation:(BFCircleOrientation)orientation;
+ (UIBezierPath *)bezierPathWithPoints:(CGPoint *)points circleCenter:(CGPoint)center;
+ (void)renderTabWithBezierPath:(UIBezierPath *)bezierPath;

@end
