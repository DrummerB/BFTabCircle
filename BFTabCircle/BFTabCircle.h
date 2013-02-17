//
//  BFTabCircle.h
//  BFTabCircle
//
//  Created by Balázs Faludi on 14.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class BFTabCircleItem;
@protocol BFTabCircleDelegate;

@interface BFTabCircle : UIView

@property (nonatomic) NSArray *items;
@property (nonatomic) CGFloat outerRadius;	// Radius of the tab circle
@property (nonatomic) CGFloat imageRadius;  // Distance of the tab images' center from the tab circle's center.
@property (nonatomic) CGFloat innerRadius;  // Radius of the button in the middle.
@property (nonatomic) CGFloat verticalOffset;  // The distance between the center of the circle and the bottom of the screen.
@property (nonatomic) BOOL showing;
@property (nonatomic, weak) NSObject<BFTabCircleDelegate> *delegate;

- (id)initWithItems:(NSArray *)items;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end


@protocol BFTabCircleDelegate <NSObject>

- (void)tabCircle:(BFTabCircle *)tabCircle selectedItem:(BFTabCircleItem *)item;

@end