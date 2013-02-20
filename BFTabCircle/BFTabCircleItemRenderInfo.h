//
//  BFTabCircleItemRenderInfo.h
//  Demo
//
//  Created by Balázs Faludi on 20.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BFTabCircle.h"

@interface BFTabCircleItemRenderInfo : NSObject

@property (nonatomic) UIBezierPath *bezierPath;
@property (nonatomic) CGPoint iconCenter;
@property (nonatomic) BFTabState state;

@end