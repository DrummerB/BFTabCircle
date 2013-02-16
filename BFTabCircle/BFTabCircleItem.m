//
//  BFTabCircleItem.m
//  Demo
//
//  Created by Balázs Faludi on 15.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import "BFTabCircleItem.h"

@implementation BFTabCircleItem

#pragma mark -
#pragma mark Initialization & Destruction

- (id)initWithTitle:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
		self.image = image;
		self.tag = tag;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image tag:(NSInteger)tag
{
    return [self initWithTitle:nil image:image tag:tag];
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithTitle:nil image:image tag:0];
}



@end
