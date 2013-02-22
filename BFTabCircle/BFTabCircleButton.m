//
//  BFTabCircleButton.m
//  Demo
//
//  Created by Balázs Faludi on 22.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabCircleButton.h"
#import "BFTabCircle.h"

#define kBFTabCircleButtonDefaultSize 44


@interface BFTabCircleButton ()
@property (nonatomic) CGRect frameBackup;
@end

@interface BFTabCircle ()
@property (nonatomic, weak) BFTabCircleButton *tabCircleButton;
@end

@implementation BFTabCircleButton

- (id)initWithWithTabCircle:(BFTabCircle *)tabCircle
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.tabCircle = tabCircle;
		
		CGFloat radius = self.tabCircle.innerRadius;
		CGFloat y = self.tabCircle.frame.origin.y + self.tabCircle.frame.size.height - self.tabCircle.verticalOffset - radius;
		CGRect frame = CGRectMake(self.tabCircle.center.x - radius, y, 2.0f * radius, 2.0f * radius);
		self.frame = frame;
		
		[self moveToTabBar];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* gradientColor2 = [UIColor colorWithRed: 0.965 green: 0.961 blue: 0.929 alpha: 1];
	UIColor* gradientColor3 = [UIColor colorWithRed: 0.882 green: 0.875 blue: 0.843 alpha: 1];
	UIColor* color2 = [UIColor colorWithRed: 0.302 green: 0.302 blue: 0.267 alpha: 1];
	
	//// Gradient Declarations
	NSArray* gradientColors = [NSArray arrayWithObjects:
							   (id)gradientColor2.CGColor,
							   (id)gradientColor3.CGColor, nil];
	CGFloat gradientLocations[] = {0, 1};
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
	
	//// Frames
	CGRect frame = self.bounds;
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame))];
	[color2 setFill];
	[borderPath fill];
	
	
	//// Inside Drawing
	CGRect insideRect = CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 2, CGRectGetWidth(frame) - 4, CGRectGetHeight(frame) - 4);
	UIBezierPath* insidePath = [UIBezierPath bezierPathWithOvalInRect: insideRect];
	CGContextSaveGState(context);
	[insidePath addClip];
	CGContextDrawLinearGradient(context, gradient,
								CGPointMake(CGRectGetMidX(insideRect), CGRectGetMinY(insideRect)),
								CGPointMake(CGRectGetMidX(insideRect), CGRectGetMaxY(insideRect)),
								0);
	CGContextRestoreGState(context);
	
	
	//// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

- (void)setTabCircle:(BFTabCircle *)tabCircle {
	if (_tabCircle != tabCircle) {
		_tabCircle = tabCircle;
		_tabCircle.tabCircleButton = self;
	}
}

#pragma mark -
#pragma mark Event handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.tabCircle.showing) {
		[self.tabCircle hideAnimated:YES];
	} else {
		[self.tabCircle showAnimated:YES];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.tabCircle.showing) {
		[self.tabCircle touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.tabCircle.showing) {
		[self.tabCircle touchesEnded:touches withEvent:event];
	}
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark Animations

- (void)moveToCircleCenter {
	self.transform = CGAffineTransformIdentity;
}

- (void)moveToTabBar {
	
	CGFloat scale = kBFTabCircleButtonDefaultSize / 2.0 / self.tabCircle.innerRadius;
	CGAffineTransform t = CGAffineTransformMakeTranslation(0.0, self.tabCircle.verticalOffset- kBFTabCircleButtonDefaultSize / 2.0f);
	t = CGAffineTransformScale(t, scale, scale);
	self.transform = t;
	
}


@end
