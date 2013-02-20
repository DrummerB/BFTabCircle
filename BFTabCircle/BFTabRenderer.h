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

@class BFTabCircleItemRenderInfo;
@class BFTabCircleItem;

@interface BFTabRenderer : NSObject

+ (UIBezierPath *)bezierPathWithPoints:(CGPoint *)points circleCenter:(CGPoint)center;
+ (void)renderTabItem:(BFTabCircleItem *)item withInfo:(BFTabCircleItemRenderInfo *)info;

@end
