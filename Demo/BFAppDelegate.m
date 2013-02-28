//
//  BFAppDelegate.m
//  Demo
//
//  Created by Balázs Faludi on 13.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFAppDelegate.h"

#import "BFTabController.h"
#import "BFTabCircleItem.h"

@implementation BFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSArray *imageNames = @[@"0037.png", @"0042.png", @"0012.png", @"0015.png", @"0086.png"];
	NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:imageNames.count];
	for (NSString *imageName in imageNames) {
		UIViewController *vc = [[UIViewController alloc] initWithNibName:@"BFViewController" bundle:nil];
		UIImage *image = [UIImage imageNamed:imageName];
		UITabBarItem *tbi = [[UITabBarItem alloc] initWithTitle:nil image:image tag:0];
		vc.tabBarItem = tbi;
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.center = CGPointMake(vc.view.bounds.size.width / 2.0f, vc.view.bounds.size.height / 2.0f);
		[vc.view addSubview:imageView];
		[viewControllers addObject:vc];
	}
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.viewController = [[BFTabController alloc] init];
	self.viewController.viewControllers = viewControllers;
	
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
