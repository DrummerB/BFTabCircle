//
//  BFTabCircleRenderer.m
//  Demo
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabCircleRenderer.h"

#define KAPPA 0.5522847498



@implementation BFTabCircleRenderer

//  1 \--------/ 2
//     \      /
//      \    /
//     0 \--/ 3
+ (UIBezierPath *)bezierPathWithPoints:(CGPoint *)points circleCenter:(CGPoint)center {
	
	UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
	[bezier3Path moveToPoint: points[0]]; 
	[bezier3Path addCurveToPoint: points[1] controlPoint1: CGPointMake(96.36, 33.44)
				   controlPoint2: points[0]];
	[bezier3Path addCurveToPoint: points[2] controlPoint1: CGPointMake(138.63, 9.34)
				   controlPoint2: CGPointMake(181.39, 14.98)];
	[bezier3Path addCurveToPoint: points[3] controlPoint1: CGPointMake(193.4, 74.23)
				   controlPoint2: CGPointMake(214.01, 33.4)];
	[bezier3Path addCurveToPoint: points[0] controlPoint1: CGPointMake(159.67, 109.57)
				   controlPoint2: CGPointMake(155.35, 108.03)];
	[bezier3Path closePath];
}

+ (CGPoint)controlPointForPoint:(CGPoint)point circleCenter:(CGPoint)center orientation:(BFCircleOrientation)orientation {
	CGPoint diff = CGPointMake(point.x - center.x, point.y - center.y);
	CGFloat tangentSlope = -diff.x / diff.y;
	CGFloat radius = sqrtf(diff.x*diff.x + diff.y*diff.y);
	CGFloat length = radius * KAPPA;
	CGFloat angle = atanf(tangentSlope);
	if (diff.y > 0) orientation *= -1;
	return CGPointMake(point.x + orientation * length * cosf(angle),
					   point.y + orientation * length * sinf(angle));
}

+ (void)renderTabWithPoints:(CGPoint *)points {
	
	
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
	UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
	[bezier3Path moveToPoint: CGPointMake(140.5, 113.5)];
	[bezier3Path addCurveToPoint: CGPointMake(95.5, 32.5) controlPoint1: CGPointMake(96.36, 33.44)
				   controlPoint2: CGPointMake(140.43, 112.83)];
	[bezier3Path addCurveToPoint: CGPointMake(215.5, 32.5) controlPoint1: CGPointMake(138.63, 9.34)
				   controlPoint2: CGPointMake(181.39, 14.98)];
	[bezier3Path addCurveToPoint: CGPointMake(170.5, 113.5) controlPoint1: CGPointMake(193.4, 74.23)
				   controlPoint2: CGPointMake(214.01, 33.4)];
	[bezier3Path addCurveToPoint: CGPointMake(140.5, 113.5) controlPoint1: CGPointMake(159.67, 109.57)
				   controlPoint2: CGPointMake(155.35, 108.03)];
	[bezier3Path closePath];
	[strokeColor setFill];
	[bezier3Path fill];
	
	////// Bezier 3 Inner Shadow
	CGRect bezier3BorderRect = CGRectInset([bezier3Path bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
	bezier3BorderRect = CGRectOffset(bezier3BorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
	bezier3BorderRect = CGRectInset(CGRectUnion(bezier3BorderRect, [bezier3Path bounds]), -1, -1);
	
	UIBezierPath* bezier3NegativePath = [UIBezierPath bezierPathWithRect: bezier3BorderRect];
	[bezier3NegativePath appendPath: bezier3Path];
	bezier3NegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = innerShadowOffset.width + round(bezier3BorderRect.size.width);
		CGFloat yOffset = innerShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									innerShadowBlurRadius,
									innerShadow.CGColor);
		
		[bezier3Path addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bezier3BorderRect.size.width), 0);
		[bezier3NegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[bezier3NegativePath fill];
	}
	CGContextRestoreGState(context);
	
	[fillColor setStroke];
	bezier3Path.lineWidth = 1;
	[bezier3Path stroke];
	
	

}

@end
