//
//  BFBezierButton.h
//  Demo
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFBezierButton : UIControl

@property (nonatomic) UIBezierPath *bezier;

- (id)initWithBezierPath:(UIBezierPath *)bezier;

@end
