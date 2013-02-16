//
//  BFCircleGeometry.m
//  Demo
//
//  Created by Balázs Faludi on 16.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFCircleGeometry.h"

@implementation BFCircleGeometry

+ (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(CGFloat)radius atAngle:(CGFloat)angle {
	return CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle));
}

+ (CGFloat)angleOfPoint:(CGPoint)point onCircleWithCenter:(CGPoint)center {
	CGFloat x = point.x - center.x;
	CGFloat y = point.y - center.y;
	if (x > 0) {
		return (y > 0 ? 0 : 2.0f * M_PI) + atanf(y / x);
	}
	return atanf(y / x) + M_PI;
}

@end
