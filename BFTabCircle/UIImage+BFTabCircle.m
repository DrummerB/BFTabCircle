//
//  UIImage+CEEditor.m
//  CocosGame
//
//  Created by Balázs Faludi on 04.05.12.
//  Copyright (c) 2012 Universität Basel. All rights reserved.
//

#import "UIImage+BFTabCircle.h"
//#import "CGExtensions.h"
//#import "UIColor+CEEditor.h"

@implementation UIImage (BFTabCircle)

- (CGRect)bounds {
	return CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
}

- (UIImage *)imageWithEmbossState:(BFEmbossState)state {
	UIGraphicsBeginImageContext(self.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	
	[self drawEmbossedInRect:self.bounds state:state];
	
	UIGraphicsPopContext();
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return outputImage;
}

- (void)drawEmbossedInRect:(CGRect)rect state:(BFEmbossState)state
{
	UIColor *gradientTop;
	UIColor *gradientBottom;
	UIColor *dropShadow;
	UIColor *innerShadow;
	
	switch (state) {
		default:
		case BFEmbossStateNormal:
			gradientTop = [UIColor colorWithWhite:0.35 alpha:1.0];
			gradientBottom = [UIColor colorWithWhite:0.45 alpha:1.0];
			dropShadow = [UIColor colorWithWhite:0.87 alpha:1.0];
			innerShadow = [UIColor colorWithWhite:0.10 alpha:1.0];
			break;
		case BFEmbossStateInactive:
			gradientTop = [UIColor colorWithWhite:0.58 alpha:1.0];
			gradientBottom = [UIColor colorWithWhite:0.63 alpha:1.0];
			dropShadow = [UIColor colorWithWhite:0.87 alpha:1.0];
			innerShadow = [UIColor colorWithWhite:0.40 alpha:1.0];
			break;
		case BFEmbossStatePressed:
			gradientTop = [UIColor colorWithWhite:0.23 alpha:1.0];
			gradientBottom = [UIColor colorWithWhite:0.33 alpha:1.0];
			dropShadow = [UIColor colorWithWhite:0.83 alpha:1.0];
			innerShadow = [UIColor colorWithWhite:0.07 alpha:1.0];
			break;
	}
	
    CGSize size = rect.size;
    CGFloat dropShadowOffsetY = size.width <= 64.0 ? -1.0 : -2.0;
    CGFloat innerShadowBlurRadius = size.width <= 32.0 ? 1.0 : 4.0;
	
    CGContextRef c = UIGraphicsGetCurrentContext();
	
    //save the current graphics state
    CGContextSaveGState(c);
	
    //Create mask image:
    CGRect maskRect = rect;
    CGImageRef maskImage = self.CGImage;
	
    //Draw image and white drop shadow:
	CGColorRef dropShadowColor = dropShadow.CGColor;
    CGContextSetShadowWithColor(c, CGSizeMake(0, dropShadowOffsetY), 0, dropShadowColor);
//    [self drawInRect:maskRect fromRect: operation:NSCompositeSourceOver fraction:1.0];
//	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeSourceAtop alpha:1.0f];
//	CGColorRelease(dropShadowColor);
	
    //Clip drawing to mask:
    CGContextClipToMask(c, maskRect, maskImage);
	
    //Draw gradient:
//    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:gradientTop
//														 endingColor:gradientBottom];
//    [gradient drawInRect:maskRect angle:90.0];
//	CGColorRef innerShadowColor = [innerShadow copyCGColor];
//    CGContextSetShadowWithColor(c, CGSizeMake(0, -1), innerShadowBlurRadius, innerShadowColor);
//	CGColorRelease(innerShadowColor);
	
	CFMutableArrayRef gradientColors = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
	CFArrayAppendValue(gradientColors, gradientTop.CGColor);
	CFArrayAppendValue(gradientColors, gradientBottom.CGColor);
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, NULL);
	CGContextDrawLinearGradient(c, gradient, rect.origin, CGPointMake(rect.origin.x, rect.origin.x + rect.size.height), 0);
	CFRelease(gradient);
	CFRelease(gradientColors);
	
	return;
    //Draw inner shadow with inverted mask:
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef maskContext = CGBitmapContextCreate(NULL, CGImageGetWidth(maskImage), CGImageGetHeight(maskImage), 8,
													 CGImageGetWidth(maskImage) * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
    CGContextDrawImage(maskContext, maskRect, maskImage);
    CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(maskContext, maskRect);
    CGImageRef invertedMaskImage = CGBitmapContextCreateImage(maskContext);
    CGContextDrawImage(c, maskRect, invertedMaskImage);
    CGImageRelease(invertedMaskImage);
    CGContextRelease(maskContext);
	
    //restore the graphics state
    CGContextRestoreGState(c);
}

@end
