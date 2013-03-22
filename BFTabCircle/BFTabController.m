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

@property (nonatomic) UIView *coverView;

@end

@implementation BFTabController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)loadView {
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
	rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - 88);
	self.view = [[UIView alloc] initWithFrame:rect];
	
	self.tabCircle = [[BFTabCircle alloc] initWithItems:[self tabItemsOfViewControllers]];
	self.tabCircle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	self.tabCircle.delegate = self;
	[self.view addSubview:self.tabCircle];
	
	self.tabButton = [[BFTabCircleButton alloc] initWithWithTabCircle:self.tabCircle];
	self.tabButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
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

	// Replace the old view controller's view with the new one.
	[self.selectedViewController.view removeFromSuperview];
	[self.selectedViewController removeFromParentViewController];
	_selectedIndex = selectedIndex;
	UIViewController *selectedVC = self.selectedViewController;
	selectedVC.view.frame = self.view.bounds;
	selectedVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self addChildViewController:selectedVC];
	[self.view insertSubview:selectedVC.view atIndex:0];
	
	// Replace the navigation item, if the tab controller is in a navigation controller.
	[self updateNavigationItem];
}

//- (UINavigationItem *)navigationItem {
//	return self.selectedViewController.navigationItem;
//}

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

- (void)tabCircleWillAppear:(BFTabCircle *)tabCircle {
	[self showCoverView];
}

- (void)tabCircleWillDisappear:(BFTabCircle *)tabCircle {
	[self hideCoverView];
}

#pragma mark -
#pragma mark CoverView

- (void)showCoverView {
	self.coverView = [[UIView alloc] initWithFrame:self.view.bounds];
	self.coverView.backgroundColor = [UIColor blackColor];
	self.coverView.alpha = 0.0f;
	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnCoverView:)];
	[self.coverView addGestureRecognizer:gr];
	NSInteger index = MAX(0, MIN([self.view.subviews indexOfObject:self.tabCircle], [self.view.subviews indexOfObject:self.tabButton]));
	[self.view insertSubview:self.coverView atIndex:index];
	
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[UIView animateWithDuration:0.2f animations:^{
		self.coverView.alpha = 0.5f;
	} completion:^(BOOL finished) {
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}];
}

- (void)hideCoverView {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[UIView animateWithDuration:0.2f animations:^{
		self.coverView.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[self.coverView removeFromSuperview];
		self.coverView = nil;
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}];
}

- (void)handleTapOnCoverView:(UITapGestureRecognizer *)recognizer {
	[self.tabCircle hideAnimated:YES];
	[self hideCoverView];
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

// Update the tab controller's navigation item to represent the currently selected view controller's navigation item.
// Unfortunately navigationItem is readonly, we have to set each property individually.
- (void)updateNavigationItem
{
	UINavigationItem *navItem = self.selectedViewController.navigationItem;
    self.navigationItem.title = navItem.title;
    self.navigationItem.prompt = navItem.prompt;
    self.navigationItem.hidesBackButton = navItem.hidesBackButton;
	self.navigationItem.backBarButtonItem = navItem.backBarButtonItem;
	self.navigationItem.leftBarButtonItem = navItem.leftBarButtonItem;
	self.navigationItem.rightBarButtonItem = navItem.rightBarButtonItem;
	self.navigationItem.titleView = navItem.titleView;
    
}

@end
