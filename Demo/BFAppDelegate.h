//
//  BFAppDelegate.h
//  Demo
//
//  Created by Balázs Faludi on 13.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFTabController;

@interface BFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BFTabController *viewController;

@end
