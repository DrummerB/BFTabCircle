//
//  BFTabCircleItem.h
//  Demo
//
//  Created by Balázs Faludi on 15.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Model class that stores info about a tab.
@interface BFTabCircleItem : NSObject

@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger tag;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag;
- (id)initWithImage:(UIImage *)image tag:(NSInteger)tag;
- (id)initWithImage:(UIImage *)image;

@end
