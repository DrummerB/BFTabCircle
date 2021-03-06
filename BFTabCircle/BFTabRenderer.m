//
//  BFTabCircleRenderer.m
//  Demo
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabRenderer.h"
#import "BFTabCircleItem.h"
#import "BFTabCircleItemRenderInfo.h"
#import "UIImage+BFTabCircle.h"

#define KAPPA 0.5522847498



@implementation BFTabRenderer

//  1 \--------/ 2
//     \      /
//      \    /
//     0 \--/ 3
+ (UIBezierPath *)bezierPathWithPoints:(CGPoint *)points circleCenter:(CGPoint)center {
	CGPoint controlPoints[2];
	UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
	[bezier3Path moveToPoint: points[0]];
	
	[bezier3Path addCurveToPoint:points[1] controlPoint1:points[1] controlPoint2:points[0]];
	
	[self controlPoints:controlPoints forPoint:points[1] andPoint:points[2] center:center];
	[bezier3Path addCurveToPoint:points[2] controlPoint1:controlPoints[0] controlPoint2:controlPoints[1]];
	
	[bezier3Path addCurveToPoint:points[3] controlPoint1:points[3] controlPoint2:points[2]];

	[self controlPoints:controlPoints forPoint:points[0] andPoint:points[3] center:center];
	[bezier3Path addCurveToPoint:points[0] controlPoint1:controlPoints[1] controlPoint2:controlPoints[0]];
	
	[bezier3Path closePath];
	return bezier3Path;
}

+ (void)controlPoints:(CGPoint *)controlPoints forPoint:(CGPoint)leftPoint andPoint:(CGPoint)rightPoint center:(CGPoint)center {
	// Calculate the multiplier to use to get the length of the control point distance.
	CGFloat l = sqrt(powf(leftPoint.x - center.x, 2) + powf(leftPoint.y - center.y, 2));
	CGFloat r = sqrt(powf(rightPoint.x - center.x, 2) + powf(rightPoint.y - center.y, 2));
	CGFloat t = sqrt(powf(rightPoint.x - leftPoint.x, 2) + powf(rightPoint.y - leftPoint.y, 2));
	CGFloat sliceAngle = acosf((l*l+r*r-t*t)/(2.0f*l*r));
	CGFloat multiplier = KAPPA * sliceAngle / (M_PI / 2.0f);
	controlPoints[0] = [self controlPointForPoint:leftPoint center:center multiplier:multiplier orientation:BFCircleOrientationClockwise];
	controlPoints[1] = [self controlPointForPoint:rightPoint center:center multiplier:multiplier orientation:BFCircleOrientationCounterClockwise];
}

+ (CGPoint)controlPointForPoint:(CGPoint)point center:(CGPoint)center multiplier:(CGFloat)multiplier orientation:(BFCircleOrientation)orientation {
	CGPoint diff = CGPointMake(point.x - center.x, point.y - center.y);
	CGFloat tangentSlope = -diff.x / diff.y;
	CGFloat radius = sqrtf(diff.x*diff.x + diff.y*diff.y);
	CGFloat length = radius * multiplier;
	CGFloat angle = atanf(tangentSlope);
	if (diff.y >= 0) orientation *= -1;
	return CGPointMake(point.x + orientation * length * cosf(angle),
					   point.y + orientation * length * sinf(angle));
}

// Renders the given item using the specified render info.
+ (void)renderTabItem:(BFTabCircleItem *)item withInfo:(BFTabCircleItemRenderInfo *)info {
	
	BOOL highlighted = info.state == BFTabStateHighlighted;
	BOOL selected = info.state == BFTabStateSelected;
	
	UIBezierPath *bezierPath = info.bezierPath;
	
//	if (moveToOrigin) {
//		CGRect bounds = [bezierPath bounds];
//		[bezierPath applyTransform:CGAffineTransformMakeTranslation(-bounds.origin.x, -bounds.origin.y)];
//	}

	//// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* innerShadowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
	UIColor* strokeColor = [UIColor colorWithRed: 0.76 green: 0.76 blue: 0.76 alpha: 1];
	UIColor* fillColor = [UIColor colorWithRed: 0.7 green: 0.7 blue: 0.7 alpha: 1];
	UIColor* gradientColor = [UIColor colorWithRed: 0.739 green: 0.739 blue: 0.739 alpha: 1];
	UIColor* gradientColor2 = [UIColor colorWithRed: 0.885 green: 0.885 blue: 0.885 alpha: 1];
	
	if (highlighted) {
		innerShadowColor = [UIColor colorWithRed: 0.404 green: 0.404 blue: 0.404 alpha: 1];
	}
	
	//// Shadow Declarations
	UIColor* innerShadow = innerShadowColor;
	CGSize innerShadowOffset = CGSizeMake(0.1, -0.1);
	CGFloat innerShadowBlurRadius = 1.5;
	
	if (highlighted) {
		innerShadowOffset = CGSizeMake(0.1, 4.1);
		innerShadowBlurRadius = 12;
	}
	
	//// Gradient Declarations
	NSArray* gradientColors = [NSArray arrayWithObjects:
							   (id)gradientColor.CGColor,
							   (id)gradientColor2.CGColor, nil];
	CGFloat gradientLocations[] = {0, 1};
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
	
	//// Bezier 3 Drawing
	if (highlighted) {
		CGContextSaveGState(context);
		[bezierPath addClip];
		CGContextDrawLinearGradient(context, gradient, [bezierPath bounds].origin, CGPointMake([bezierPath bounds].origin.x, [bezierPath bounds].origin.y + [bezierPath bounds].size.height), 0);
		CGContextRestoreGState(context);
	} else {
		[fillColor setFill];
		[bezierPath fill];
	}
	
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
	
	[strokeColor setStroke];
	bezierPath.lineWidth = 1;
	[bezierPath stroke];
	
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
	
	[[item.image imageWithEmbossState:info.state] drawAtCenter:info.iconCenter];
	
}

@end
