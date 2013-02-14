//
//  BFBezierButton.m
//  Demo
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFBezierButton.h"
#import "BFTabRenderer.h"

@interface BFBezierButton ()

@end


@implementation BFBezierButton

- (id)initWithBezierPath:(UIBezierPath *)bezier
{
    self = [super init];
    if (self) {
        self.bezier = bezier;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	[BFTabRenderer renderTabWithBezierPath:self.bezier];
}

- (void)setBezier:(UIBezierPath *)bezier {
	if (_bezier != bezier) {
		self.frame = CGPathGetPathBoundingBox(bezier.CGPath);
		[bezier applyTransform:CGAffineTransformMakeTranslation(-self.frame.origin.x, -self.frame.origin.y)];
		_bezier = bezier;
	}
}

@end
