//
//  BFRenderView.m
//  Demo
//
//  Created by Balázs Faludi on 26.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFRenderView.h"

@implementation BFRenderView

- (void)drawRect:(CGRect)rect
{
    if ([self.delegate respondsToSelector:@selector(renderView:drawRect:)]) {
		[self.delegate renderView:self drawRect:rect];
	}
}

@end
