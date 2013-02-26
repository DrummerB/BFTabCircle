//
//  BFTabCircleButton.h
//  Demo
//
//  Created by Balázs Faludi on 22.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFTabCircle;

// This is the round button in the middle of the tab circle.
@interface BFTabCircleButton : UIView

@property (nonatomic) BFTabCircle *tabCircle;

- (id)initWithWithTabCircle:(BFTabCircle *)tabCircle;

@end
