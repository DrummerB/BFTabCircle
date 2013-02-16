//
//  BFViewController.h
//  Demo
//
//  Created by Balázs Faludi on 13.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTabCircle.h"

@interface BFViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *controlPoint;
@property (strong, nonatomic) IBOutlet UIView *centerView;
@property (nonatomic) BFTabCircle *tabCircle;

@end
