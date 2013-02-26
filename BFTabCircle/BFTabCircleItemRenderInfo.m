//
//  BFTabCircleItemRenderInfo.m
//  Demo
//
//  Created by Balázs Faludi on 20.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabCircleItemRenderInfo.h"

@implementation BFTabCircleItemRenderInfo

- (id)copy {
	BFTabCircleItemRenderInfo *infoCopy = [[BFTabCircleItemRenderInfo alloc] init];
	infoCopy.bezierPath = [self.bezierPath copy];
	infoCopy.iconCenter = self.iconCenter;
	infoCopy.state = self.state;
	return infoCopy;
}

@end
