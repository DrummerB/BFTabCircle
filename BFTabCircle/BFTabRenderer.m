//
//  BFTabCircleRenderer.m
//  Demo
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabRenderer.h"

#define KAPPA 0.5522847498



@implementation BFTabRenderer

//  1 \--------/ 2
//     \      /
//      \    /
//     0 \--/ 3
+ (UIBezierPath *)bezierPathWithPoints:(CGPoint *)points circleCenter:(CGPoint)center {
	CGPoint controlPoint1, controlPoint2;
	UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
	[bezier3Path moveToPoint: points[0]];
	
	[bezier3Path addCurveToPoint:points[1] controlPoint1:points[1] controlPoint2:points[0]];
	
	controlPoint1 = [self controlPointForPoint:points[1] circleCenter:center orientation:BFCircleOrientationClockwise];
	controlPoint2 = [self controlPointForPoint:points[2] circleCenter:center orientation:BFCircleOrientationCounterClockwise];
	[bezier3Path addCurveToPoint:points[2] controlPoint1:controlPoint1 controlPoint2:controlPoint2];
	
	[bezier3Path addCurveToPoint:points[3] controlPoint1:points[3] controlPoint2:points[2]];

	controlPoint1 = [self controlPointForPoint:points[3] circleCenter:center orientation:BFCircleOrientationCounterClockwise];
	controlPoint2 = [self controlPointForPoint:points[0] circleCenter:center orientation:BFCircleOrientationClockwise];
	[bezier3Path addCurveToPoint:points[0] controlPoint1:controlPoint1 controlPoint2:controlPoint2];
	
	[bezier3Path closePath];
	return bezier3Path;
}

+ (CGPoint)controlPointForPoint:(CGPoint)point circleCenter:(CGPoint)center orientation:(BFCircleOrientation)orientation {
	CGPoint diff = CGPointMake(point.x - center.x, point.y - center.y);
	CGFloat tangentSlope = -diff.x / diff.y;
	CGFloat radius = sqrtf(diff.x*diff.x + diff.y*diff.y);
	CGFloat length = radius * KAPPA;
	CGFloat angle = atanf(tangentSlope);
	if (diff.y >= 0) orientation *= -1;
//	return point;
	return CGPointMake(point.x + orientation * length * cosf(angle),
					   point.y + orientation * length * sinf(angle));
}

+ (void)renderTabWithBezierPath:(UIBezierPath *)bezierPath {
	
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* innerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
	UIColor* fillColor = [UIColor colorWithRed: 0.76 green: 0.76 blue: 0.76 alpha: 1];
	UIColor* strokeColor = [UIColor colorWithRed: 0.92 green: 0.92 blue: 0.92 alpha: 1];
	
	//// Shadow Declarations
	UIColor* innerShadow = innerShadowColor;
	CGSize innerShadowOffset = CGSizeMake(0.1, -0.1);
	CGFloat innerShadowBlurRadius = 1.5;
	
	//// Bezier 3 Drawing
	[strokeColor setFill];
	[bezierPath fill];
	
	////// Bezier 3 Inner Shadow
	CGRect bezier3BorderRect = CGRectInset([bezierPath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
	bezier3BorderRect = CGRectOffset(bezier3BorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
	bezier3BorderRect = CGRectInset(CGRectUnion(bezier3BorderRect, [bezierPath bounds]), -1, -1);
	
	UIBezierPath* bezier3NegativePath = [UIBezierPath bezierPathWithRect: bezier3BorderRect];
	[bezier3NegativePath appendPath: bezierPath];
	bezier3NegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = innerShadowOffset.width + round(bezier3BorderRect.size.width);
		CGFloat yOffset = innerShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									innerShadowBlurRadius,
									innerShadow.CGColor);
		
		[bezierPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bezier3BorderRect.size.width), 0);
		[bezier3NegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[bezier3NegativePath fill];
	}
	CGContextRestoreGState(context);
	
	[fillColor setStroke];
	bezierPath.lineWidth = 1;
	[bezierPath stroke];
	
}

@end
