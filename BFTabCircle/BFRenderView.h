//
//  BFRenderView.h
//  Demo
//
//  Created by Balázs Faludi on 26.02.13.
//  Copyright (c) 2013 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BFRenderViewDelegate;


@interface BFRenderView : UIView

@property (nonatomic) NSObject<BFRenderViewDelegate> *delegate;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSObject *data;

@end


@protocol  BFRenderViewDelegate <NSObject>

- (void)renderView:(BFRenderView *)renderView drawRect:(CGRect)rect;

@end