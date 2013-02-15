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

@interface BFViewController ()

@end

@implementation BFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[self.view addGestureRecognizer:gr];
	
	CGPoint points[4] = {CGPointMake(20, 200), CGPointMake(20, 100), CGPointMake(120, 200), CGPointMake(20, 200)};
	UIBezierPath *bezier = [BFTabRenderer bezierPathWithPoints:points circleCenter:CGPointMake(20, 200)];
	BFBezierButton *b = [[BFBezierButton alloc] initWithBezierPath:bezier];
	[self.view addSubview:b];
}

- (void)handleTap:(UIPanGestureRecognizer *)gr {
	CGPoint location = [gr locationInView:self.view];
	self.controlPoint.center = [BFTabRenderer controlPointForPoint:location
															circleCenter:self.centerView.center
															 orientation:BFCircleOrientationCounterClockwise];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
