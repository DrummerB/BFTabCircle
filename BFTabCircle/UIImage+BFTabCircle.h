//
//  UIImage+BFTabCircle.h
//  Demo
//
//  Created by Balázs Faludi on 17.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (BFTabCircle)

typedef NS_ENUM(NSUInteger, BFEmbossState) {
	BFEmbossStateNormal = 0,
	BFEmbossStateInactive,
	BFEmbossStatePressed,
	BFEmbossStateDefault = BFEmbossStateNormal,
};

- (void)drawEmbossedInRect:(CGRect)rect state:(BFEmbossState)state;
- (UIImage *)imageWithEmbossState:(BFEmbossState)state;

@end

