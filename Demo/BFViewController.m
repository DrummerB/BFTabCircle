//
//  BFViewController.m
//  Demo
//
//  Created by Balázs Faludi on 13.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFViewController.h"
#import "BFTabRenderer.h"
#import "BFBezierButton.h"
#import "BFTabCircleItem.h"
#import "BFTabCircle.h"
#import "BFCircleGeometry.h"

@interface BFViewController ()

@end

@implementation BFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[self.view addGestureRecognizer:gr];
	
	UITapGestureRecognizer *tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[self.view addGestureRecognizer:tg];
	
//	CGPoint points[4] = {CGPointMake(20, 200), CGPointMake(20, 100), CGPointMake(120, 200), CGPointMake(20, 200)};
//	UIBezierPath *bezier = [BFTabRenderer bezierPathWithPoints:points circleCenter:CGPointMake(20, 200)];
//	BFBezierButton *b = [[BFBezierButton alloc] initWithBezierPath:bezier];
//	[self.view addSubview:b];
	
	
	BFTabCircleItem *i1 = [[BFTabCircleItem alloc] initWithImage:nil];
	BFTabCircleItem *i2 = [[BFTabCircleItem alloc] initWithImage:nil];
	BFTabCircleItem *i3 = [[BFTabCircleItem alloc] initWithImage:nil];
	BFTabCircleItem *i4 = [[BFTabCircleItem alloc] initWithImage:nil];
	BFTabCircleItem *i5 = [[BFTabCircleItem alloc] initWithImage:nil];
	NSArray *items = @[i1, i2, i3, i4, i5];
	self.tabCircle = [[BFTabCircle alloc] initWithItems:items];
	[self.view addSubview:self.tabCircle];
	
}

- (void)handlePan:(UIPanGestureRecognizer *)gr {
	CGPoint location = [gr locationInView:self.view];
	NSLog(@"%f", [BFCircleGeometry angleOfPoint:location onCircleWithCenter:self.centerView.center]);
//	self.controlPoint.center = [BFTabRenderer controlPointForPoint:location
//															circleCenter:self.centerView.center
//															 orientation:BFCircleOrientationCounterClockwise];
}

- (void)handleTap:(UITapGestureRecognizer *)gr {
	
	[self.tabCircle showAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
