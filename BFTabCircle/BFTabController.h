//
//  BFTabController.h
//  Demo
//
//  Created by Balázs Faludi on 22.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFTabCircle;
@class BFTabCircleButton;

@interface BFTabController : UIViewController

@property (nonatomic) NSArray *viewControllers;
@property (nonatomic) BFTabCircle *tabCircle;
@property (nonatomic) BFTabCircleButton *tabButton;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, weak) UIViewController *selectedViewController;

@end
