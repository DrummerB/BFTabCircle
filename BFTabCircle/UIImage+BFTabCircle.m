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

- (void)drawAtCenter:(CGPoint)point size:(CGSize)size blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha {
	CGPoint position = CGPointMake(roundf(point.x - size.width / 2.0f), roundf(point.y - size.height / 2.0f));
	[self drawAtPoint:position blendMode:blendMode alpha:alpha];
}

- (void)drawAtCenter:(CGPoint)point {
	[self drawAtCenter:point size:self.size blendMode:kCGBlendModeNormal alpha:1.0f];
}

- (UIImage *)imageWithEmbossState:(BFEmbossState)state {
	UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
	CGContextTranslateCTM(context, 0, self.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
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
    CGFloat dropShadowOffsetY = size.width <= 64.0 ? 1.0 : 2.0;
    CGFloat innerShadowBlurRadius = size.width <= 32.0 ? 1.0 : 4.0;
	
    CGContextRef c = UIGraphicsGetCurrentContext();

    // Save the current graphics state
    CGContextSaveGState(c);
	
    // Create mask image.
    CGRect maskRect = rect;
    CGImageRef maskImage = self.CGImage;
	
    // Draw image and white drop shadow:
	CGColorRef dropShadowColor = dropShadow.CGColor;
    CGContextSetShadowWithColor(c, CGSizeMake(0, dropShadowOffsetY), 0, dropShadowColor);
	CGContextDrawImage(c, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
	
    // Clip drawing to mask.
    CGContextClipToMask(c, maskRect, maskImage);
	
    // Fill image with gradient.
	CFMutableArrayRef gradientColors = CFArrayCreateMutable(NULL, 2, &kCFTypeArrayCallBacks);
	CFArrayAppendValue(gradientColors, gradientTop.CGColor);
	CFArrayAppendValue(gradientColors, gradientBottom.CGColor);
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, NULL);
	CGContextDrawLinearGradient(c, gradient, rect.origin, CGPointMake(rect.origin.x, rect.origin.x + rect.size.height), 0);
	CFRelease(gradient);
	CFRelease(gradientColors);
	
	CGColorRef innerShadowColor = innerShadow.CGColor;
    CGContextSetShadowWithColor(c, CGSizeMake(0, 1), innerShadowBlurRadius, innerShadowColor);

    // Draw inner shadow with inverted mask.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGSize pixelSize = CGSizeMake(CGImageGetWidth(maskImage) * self.scale, CGImageGetHeight(maskImage) * self.scale);
    CGContextRef maskContext = CGBitmapContextCreate(NULL, pixelSize.width, pixelSize.height, 8,
													 pixelSize.width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
	maskRect = CGRectMake(0.0f, 0.0f, maskRect.size.width * self.scale, maskRect.size.height * self.scale);
    CGContextSetBlendMode(maskContext, kCGBlendModeXOR);
    CGContextDrawImage(maskContext, maskRect, maskImage);
    CGContextSetRGBFillColor(maskContext, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(maskContext, maskRect);
    CGImageRef invertedMaskImage = CGBitmapContextCreateImage(maskContext);
    CGContextDrawImage(c, maskRect, invertedMaskImage);
    CGImageRelease(invertedMaskImage);
    CGContextRelease(maskContext);
	
    // Restore the graphics state
    CGContextRestoreGState(c);
}

@end
