//
//  BFTabController.m
//  Demo
//
//  Created by Balázs Faludi on 22.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabController.h"
#import "BFTabCircle.h"
#import "BFTabCircleItem.h"
#import "BFTabCircleButton.h"

#define kBFTabButtonSize 44

@interface BFTabController ()

@end

@implementation BFTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)loadView {
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
	self.view = [[UIView alloc] initWithFrame:rect];
	
	self.tabCircle = [[BFTabCircle alloc] initWithItems:[self tabItemsOfViewControllers]];
	self.tabCircle.delegate = self;
	[self.view addSubview:self.tabCircle];
	
	self.tabButton = [[BFTabCircleButton alloc] initWithWithTabCircle:self.tabCircle];
//	self.tabButton.center = CGPointMake(self.view.bounds.size.width / 2.0f,
//										self.view.bounds.size.height - self.tabButton.frame.size.height / 2.0f);
//	[self.tabButton addTarget:self action:@selector(tabButtonTapped:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:self.tabButton];
}

#pragma mark -
#pragma mark Getters & Setters

- (void)setViewControllers:(NSArray *)viewControllers {
	if (_viewControllers != viewControllers) {
		_viewControllers = viewControllers;
		self.tabCircle.items = [self tabItemsOfViewControllers];
		self.selectedIndex = 0;
	}
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
//	if (_selectedIndex != selectedIndex) {
		[self.selectedViewController.view removeFromSuperview];
		_selectedIndex = selectedIndex;
		UIViewController *selectedVC = self.selectedViewController;
		selectedVC.view.frame = self.view.bounds;
		[self.view insertSubview:selectedVC.view atIndex:0];
//	}
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
	NSInteger newIndex = [self.viewControllers indexOfObject:selectedViewController];
	[self setSelectedIndex:newIndex];
}

- (UIViewController *)selectedViewController {
	return [self.viewControllers objectAtIndex:self.selectedIndex];
}

#pragma mark -
#pragma mark BFTabCircleDelegate

- (void)tabCircle:(BFTabCircle *)tabCircle didSelectItem:(BFTabCircleItem *)item {
	NSInteger index = [tabCircle.items indexOfObject:item];
	self.selectedIndex = index;
}

#pragma mark -
#pragma mark Convenience Methods

// Goes through all the view controllers, and tries to convert the tabBarItem to a tabCircleItem.
- (NSArray *)tabItemsOfViewControllers {
	NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:self.viewControllers.count];
	for (UIViewController *viewController in self.viewControllers) {
		UITabBarItem *barItem = viewController.tabBarItem;
		if (barItem) {
			BFTabCircleItem *circleItem = [[BFTabCircleItem alloc] initWithTitle:barItem.title image:barItem.image tag:barItem.tag];
			[items addObject:circleItem];
		} else {
			BFTabCircleItem *circleItem = [[BFTabCircleItem alloc] initWithTitle:viewController.title image:nil tag:0];
			[items addObject:circleItem];
		}
	}
	return [NSArray arrayWithArray:items];
}

//- (void)tabButtonTapped:(id)sender {
//	[self.tabCircle showAnimated:YES];
//}

@end
