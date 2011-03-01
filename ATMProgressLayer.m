/*
 *  ATMHudProgressLayer.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import "ATMProgressLayer.h"

@implementation ATMProgressLayer
@synthesize theProgress, progressBorderWidth, progressBorderRadius, progressBarRadius, progressBarInset;

- (void)drawInContext:(CGContextRef)ctx {
	UIGraphicsPushContext(ctx);
	if (theProgress > 0) {
		CGRect rrect = CGRectInset(self.bounds, progressBorderWidth, progressBorderWidth);
		CGFloat radius = progressBorderRadius;
		
		CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
		CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
		
		CGContextMoveToPoint(ctx, minx, midy);
		CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
		CGContextClosePath(ctx);
		CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
		CGContextSetLineWidth(ctx, progressBorderWidth);
		CGContextDrawPath(ctx, kCGPathStroke);
		
		radius = progressBarRadius;
		
		rrect = CGRectInset(rrect, progressBarInset, progressBarInset);
		rrect.size.width = rrect.size.width * theProgress;
		minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
		miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
		CGContextMoveToPoint(ctx, minx, midy);
		CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
		CGContextClosePath(ctx);
		CGContextSetRGBFillColor(ctx,1, 1, 1, 1);
		CGContextDrawPath(ctx, kCGPathFill);
	}
	UIGraphicsPopContext();
}
@end
