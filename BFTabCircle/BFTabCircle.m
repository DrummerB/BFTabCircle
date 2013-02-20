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
#import "BFTabCircleItem.h"
#import "BFTabCircleItemRenderInfo.h"

@interface BFTabCircle ()

//@property (nonatomic) NSDictionary *itemInfos;	// Stores precalculated bezier paths and the location of the icon.
@property (nonatomic) CFMutableDictionaryRef itemInfos;
@property (nonatomic) CGFloat extraInnerAngle; // Gives the first and last tabs a little mit more space.
@property (nonatomic) CGFloat extraImageAngle; // Gives the first and last tabs a little mit more space.
@property (nonatomic) CGFloat extraOuterAngle; // Gives the first and last tabs a little mit more space.
@property (nonatomic, weak) BFTabCircleItem *highlightedItem;

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
		_imageRadius = 110.0f;
		_verticalOffset = 16.f;
		_extraInnerAngle = 0.6f;
		_extraOuterAngle = -0.2f;
		_extraImageAngle = -0.2f;
		
		self.itemInfos = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
		
		self.multipleTouchEnabled = NO;
		self.selectedItem = nil;
		self.highlightedItem = nil;
		self.items = items;
		self.backgroundColor = [UIColor clearColor];
		[self hideAnimated:NO];
    }
    return self;
}

- (void)dealloc {
	CFRelease(self.itemInfos);
}

#pragma mark -
#pragma mark Getters & Setters

- (void)setItems:(NSArray *)items {
	if (_items != items) {
		_items = items;
		[self updateFrame];
		[self prepareInfos];
	}
}

//- (BFTabCircleItem *)selectedItem {
//	for (BFTabCircleItem *item in self.items) {
//		BFTabCircleItemRenderInfo *info = [self renderInfoForItem:item];
//		if (info.state == BFTabStateSelected) {
//			return item;
//		}
//	}
//	return nil;
//}
//
//- (BFTabCircleItem *)highlightedItem {
//	for (BFTabCircleItem *item in self.items) {
//		BFTabCircleItemRenderInfo *info = [self renderInfoForItem:item];
//		if (info.state == BFTabStateHighlighted) {
//			return item;
//		}
//	}
//	return nil;
//}

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
	
//	CGPoint center = CGPointMake(self.outerRadius, self.outerRadius);
//	CGPoint points[4];
//	
	for (int i = 0; i < self.items.count; i++) {
		BFTabCircleItem *item = self.items[i];
		BFTabCircleItemRenderInfo *info = [self renderInfoForItem:item];
		[BFTabRenderer renderTabItem:item withInfo:info];
	}
}

- (void)selectItem:(BFTabCircleItem *)item {
	
}

- (void)highlightItem:(BFTabCircleItem *)item {
	if (item != self.highlightedItem) {
		// Unhighlight old item.
		if (self.highlightedItem) {
			BFTabCircleItemRenderInfo *highlightedInfo = [self renderInfoForItem:self.highlightedItem];
			highlightedInfo.state = self.highlightedItem == self.selectedItem ? BFTabStateSelected : BFTabStateNormal;
		}
		// Highlight new item.
		if (item) {
			BFTabCircleItemRenderInfo *info = [self renderInfoForItem:item];
			info.state = BFTabStateHighlighted;
		}
		self.highlightedItem = item;
		[self setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark Event Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint location = [[touches anyObject] locationInView:self];
	BFTabCircleItem *item = [self itemAtLocation:location];
	[self highlightItem:item];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint location = [[touches anyObject] locationInView:self];
	BFTabCircleItem *item = [self itemAtLocation:location];
	[self highlightItem:item];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	CGPoint location = [[touches anyObject] locationInView:self];
//	BFTabCircleItem *item = [self itemAtLocation:location];
//	if (item) {
//		self.selectedItem = item;
//		BFTabCircleItemRenderInfo *info = [self renderInfoForItem:item];
//		info.state = BFTabStateHighlighted;
//		[self setNeedsDisplay];
//		
//		if ([self.delegate respondsToSelector:@selector(tabCircle:didSelectItem:)]) {
//			[self.delegate tabCircle:self didSelectItem:item];
//		}
//	}
//	[self hideAnimated:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
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

- (BFTabCircleItemRenderInfo *)renderInfoForItem:(BFTabCircleItem *)item {
	BFTabCircleItemRenderInfo *info = (__bridge BFTabCircleItemRenderInfo *)CFDictionaryGetValue(self.itemInfos, (__bridge const void *)(item));
	return info;
}

// Calculate the points that make up every tab slice and the poisitions of the icons.
- (void)prepareInfos {
//	NSMutableDictionary *infos = [[NSMutableDictionary alloc] initWithCapacity:self.items.count];
	CFDictionaryRemoveAllValues(self.itemInfos);

	// Calculate the x offset of the intersection of the first and last tab with the bottom of the control.
	CGFloat innerIntersectionX = sqrtf(self.innerRadius*self.innerRadius - self.verticalOffset*self.verticalOffset);
	CGFloat imageIntersectionX = sqrtf(self.imageRadius*self.imageRadius - self.verticalOffset*self.verticalOffset);
	CGFloat outerIntersectionX = sqrtf(self.outerRadius*self.outerRadius - self.verticalOffset*self.verticalOffset);
	
	CGPoint center = CGPointMake(self.outerRadius, self.outerRadius);
	CGPoint outerStart	= CGPointMake(self.bounds.size.width / 2.0f - outerIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint outerEnd	= CGPointMake(self.bounds.size.width / 2.0f + outerIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint imageStart	= CGPointMake(self.bounds.size.width / 2.0f - imageIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint imageEnd	= CGPointMake(self.bounds.size.width / 2.0f + imageIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint innerStart	= CGPointMake(self.bounds.size.width / 2.0f - innerIntersectionX, self.outerRadius + self.verticalOffset);
	CGPoint innerEnd	= CGPointMake(self.bounds.size.width / 2.0f + innerIntersectionX, self.outerRadius + self.verticalOffset);
	
	
	CGFloat additionalOuterAngle = atanf((outerStart.y - center.y) / (center.x - outerStart.x)) - self.extraOuterAngle;
	CGFloat totalOuterAngle = M_PI + 2.0f * additionalOuterAngle;
	CGFloat startOuterAngle = M_PI + additionalOuterAngle;
	CGFloat outerAnglePiece = totalOuterAngle / self.items.count;
	
	CGFloat additionalImageAngle = atanf((imageStart.y - center.y) / (center.x - imageStart.x)) - self.extraImageAngle;
	CGFloat totalImageAngle = M_PI + 2.0f * additionalImageAngle;
	CGFloat startImageAngle = M_PI + additionalImageAngle;
	CGFloat imageAnglePiece = totalImageAngle / self.items.count;
	
	CGFloat additionalInnerAngle = atanf((innerStart.y - center.y) / (center.x - innerStart.x)) - self.extraInnerAngle;
	CGFloat totalInnerAngle = M_PI + 2.0f * additionalInnerAngle;
	CGFloat startInnerAngle = M_PI + additionalInnerAngle;
	CGFloat innerAnglePiece = totalInnerAngle / self.items.count;
	
	CGPoint points[4];
	CGPoint imageLeft, imageRight;
	for (int index = 0; index < self.items.count; index++) {
		
		// Calculate the bottom left and top left edges. Handle the first tab differently.
		if (index == 0) {
			points[0] = innerStart;
			points[1] = outerStart;
			imageLeft = imageStart;
		} else {
			CGFloat outerAngle = startOuterAngle - outerAnglePiece * (index);
			CGFloat imageAngle = startImageAngle - imageAnglePiece * (index);
			CGFloat innerAngle = startInnerAngle - innerAnglePiece * (index);
			points[0] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.innerRadius atAngle:2.0f * M_PI - innerAngle];
			points[1] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.outerRadius atAngle:2.0f * M_PI - outerAngle];
			imageLeft = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.imageRadius atAngle:2.0f * M_PI - imageAngle];
		}
		
		// Calculate the top right and bottom right edges. Handle the last tab differently.
		if (index == self.items.count - 1) {
			points[2] = outerEnd;
			points[3] = innerEnd;
			imageRight = imageEnd;
		} else {
			CGFloat outerAngle = startOuterAngle - outerAnglePiece * (index + 1);
			CGFloat imageAngle = startImageAngle - imageAnglePiece * (index + 1);
			CGFloat innerAngle = startInnerAngle - innerAnglePiece * (index + 1);
			points[3] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.innerRadius atAngle:2.0f * M_PI - innerAngle];
			points[2] = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.outerRadius atAngle:2.0f * M_PI - outerAngle];
			imageRight = [BFCircleGeometry pointOnCircleWithCenter:center radius:self.imageRadius atAngle:2.0f * M_PI - imageAngle];
		}
		
		UIBezierPath *bezier = [BFTabRenderer bezierPathWithPoints:points circleCenter:center];
		BFTabCircleItemRenderInfo *info = [[BFTabCircleItemRenderInfo alloc] init];
		info.bezierPath = bezier;
		info.iconCenter = CGPointMake((imageLeft.x + imageRight.x) / 2.0f, (imageLeft.y + imageRight.y) / 2.0f);
//		[infos setObject:info forKey:self.items[index]];
		CFDictionaryAddValue(self.itemInfos, (__bridge const void *)(self.items[index]), (__bridge const void *)(info));
	}
//	self.itemInfos = [NSDictionary dictionaryWithDictionary:infos];
}

- (BFTabCircleItem *)itemAtLocation:(CGPoint)point {
	for (int i = 0; i < self.items.count; i++) {
		BFTabCircleItemRenderInfo *info = [self renderInfoForItem:self.items[i]];
		UIBezierPath *bezier = info.bezierPath;
		if ([bezier containsPoint:point]) {
			return self.items[i];
		}
	}
	return nil;
}

@end
