//
//  BFViewController.m
//  Demo
//
//  Created by Balázs Faludi on 13.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFViewController.h"
#import "BFTabCircleRenderer.h"

@interface BFViewController ()

@end

@implementation BFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIPanGestureRecognizer *gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[self.view addGestureRecognizer:gr];
	
}

- (void)handleTap:(UIPanGestureRecognizer *)gr {
	CGPoint location = [gr locationInView:self.view];
	self.controlPoint.center = [BFTabCircleRenderer controlPointForPoint:location
															circleCenter:self.centerView.center
															 orientation:BFCircleOrientationClockwise];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
