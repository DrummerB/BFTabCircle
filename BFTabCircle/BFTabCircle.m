//
//  BFTabCircle.m
//  BFTabCircle
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabCircle.h"
#import "BFTabRenderer.h"
#import "BFCircleGeometry.h"

@interface BFTabCircle ()

//@property (nonatomic) NSArray *buttons;
@property (nonatomic) CGFloat extraInnerAngle; // Gives the first and last tabs a little mit more space.
@property (nonatomic) CGFloat extraOuterAngle; // Gives the first and last tabs a little mit more space.

@end


@implementation BFTabCircle

#pragma mark -
#pragma mark Initialization & Destruction

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
		_outerRadius = 150.0f;
		_innerRadius = 30.0f;
		_verticalOffset = 16.f;
		_extraInnerAngle = 0.6f;
		_extraOuterAngle = -0.2f;
		self.items = items;
		[self updateFrame];
		self.backgroundColor = [UIColor clearColor];
		[self hideAnimated:NO];
    }
    return self;
}

#pragma mark -
#pragma mark Getters & Setters

- (void)setItems:(NSArray *)items {
	if (_items != items) {
		_items = items;
		[self setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark Presentation

- (void)showAnimated:(BOOL)animated {
	void (^animationBlock)() = ^{
		self.transform = CGAffineTransformIdentity;
		self.alpha = 1.0f;
	};
	if (animated) {
		[UIView animateWithDuration:0.2f animations:animationBlock];
	} else {
		animationBlock();
	}
}

- (void)hideAnimated:(BOOL)animated {
	void (^animationBlock)() = ^{
		CGAffineTransform t = CGAffineTransformMakeTranslation(0.0f, self.bounds.size.height / 2);
		self.transform = CGAffineTransformScale(t, 0.01f, 0.01f);
		self.alpha = 0.0f;
	};
	if (animated) {
		[UIView animateWithDuration:0.2f animations:animationBlock];
	} else {
		animationBlock();
	}
}

- (void)drawRect:(CGRect)rect {
//	[[UIColor blueColor] setFill];
//	UIRectFill(self.bounds);
//	[[UIColor redColor] setFill];
//	UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.size.width / 2.0 - self.innerRadius,
//																			 self.bounds.size.height - self.innerRadius - self.verticalOffset,
//																			 self.innerRadius * 2.0f, self.innerRadius * 2.0f)];
//	[circle fill];
	
	CGPoint center = CGPointMake(self.outerRadius, self.outerRadius);
	CGPoint points[4];
	
	for (int i = 0; i < self.items.count; i++) {
		[self points:points forTabAtIndex:i];
		UIBezierPath *bezierPath = [BFTabRenderer bezierPathWithPoints:points circleCenter:center];
		[BFTabRenderer renderTabWithBezierPath:bezierPath];
	}
}

#pragma mark -
#pragma mark Convenience Methods

- (void)updateFrame {
	CGFloat height = self.outerRadius + self.verticalOffset;
	CGFloat width = 2.0f * self.outerRadius;
	CGFloat x = [[UIScreen mainScreen] applicationFrame].size.width / 2.0f - self.outerRadius;
	CGFloat y = [[UIScreen mainScreen] applicationFrame].size.height - height;
	self.frame = CGRectMake(x, y, width, height);
}

- (void)points:(CGPoint *)points forTabAtIndex:(NSUInteger)index {
	
	// Calculate the x offset of the intersection of the first and last tab with the bottom of the control.
	CGFloat innerIntersectionX = sqrtf(self.innerRadius*self.innerRadius - self.verticalOffset*self.verticalOffset);
	CGFloat outerIntersectionX = sqrtf(self.outerRadius*self.outerRadius - self.verticalOffset*self.verticalOffset);
	
	CGPoint center = CGPointMake(self.outerRadius, self.outerRadius);
	CGPoint outerStart	= CGPointMake(self.bounds.size.width / 2.0f - outerIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint outerEnd	= CGPointMake(self.bounds.size.width / 2.0f + outerIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint innerStart	= CGPointMake(self.bounds.size.width / 2.0f - innerIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint innerEnd	= CGPointMake(self.bounds.size.width / 2.0f + innerIntersectionX, self.outerRadius + self.verticalOffset);

	
	CGFloat additionalOuterAngle = atanf((outerStart.y - center.y) / (center.x - outerStart.x)) - self.extraOuterAngle;
	CGFloat totalOuterAngle = M_PI + 2.0f * additionalOuterAngle;
	CGFloat startOuterAngle = M_PI + additionalOuterAngle;
	CGFloat outerAnglePiece = totalOuterAngle / self.items.count;
	
	CGFloat additionalInnerAngle = atanf((innerStart.y - center.y) / (center.x - innerStart.x)) - self.extraInnerAngle;
	CGFloat totalInnerAngle = M_PI + 2.0f * additionalInnerAngle;
	CGFloat startInnerAngle = M_PI + additionalInnerAngle;
	CGFloat innerAnglePiece = totalInnerAngle / self.items.count;

	
	// Calculate the bottom left and top left edges. Handle the first tab differently.
	if (index == 0) {
		points[0] = innerStart;
		points[1] = outerStart;
	} else {
		CGFloat outerAngle = startOuterAngle - outerAnglePiece * (index);
		CGFloat innerAngle = startInnerAngle - innerAnglePiece * (index);
		points[0] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.innerRadius atAngle:2.0f * M_PI - innerAngle];
		points[1] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.outerRadius atAngle:2.0f * M_PI - outerAngle];
	}
	
	// Calculate the top right and bottom right edges. Handle the last tab differently.
	if (index == self.items.count - 1) {
		points[2] = outerEnd;
		points[3] = innerEnd;
	} else {
		CGFloat outerAngle = startOuterAngle - outerAnglePiece * (index + 1);
		CGFloat innerAngle = startInnerAngle - innerAnglePiece * (index + 1);
		points[3] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.innerRadius atAngle:2.0f * M_PI - innerAngle];
		points[2] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.outerRadius atAngle:2.0f * M_PI - outerAngle];
	}
}

@end






