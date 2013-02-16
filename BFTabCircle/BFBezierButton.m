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
		self.backgroundColor = [UIColor clearColor];
		self.multipleTouchEnabled = NO;
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

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	CGPoint location = [[touches anyObject] locationInView:self];
//	self.highlighted = [self.bezier containsPoint:location];
//	[[[[touches anyObject] gestureRecognizers] objectAtIndex:0] setCancelsTouchesInView:NO];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	CGPoint location = [[touches anyObject] locationInView:self];
//	self.highlighted = [self.bezier containsPoint:location];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	CGPoint location = [[touches anyObject] locationInView:self];
//	if([self.bezier containsPoint:location]) {
//		[self sendActionsForControlEvents:UIControlEventTouchUpInside];
//	}
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//	[self touchesEnded:touches withEvent:event];
//}

@end
