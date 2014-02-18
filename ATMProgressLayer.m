/*
 *  ATMHudProgressLayer.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import "ATMProgressLayer.h"

@implementation ATMProgressLayer

- (void)setTheProgress:(CGFloat)p
{
	_theProgress = p;
	[self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
	UIGraphicsPushContext(ctx);
	if (_theProgress > 0) {
		CGRect rrect = CGRectInset(self.bounds, _progressBorderWidth, _progressBorderWidth);
		CGFloat radius = _progressBorderRadius;
		
		CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
		CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
		
		CGContextMoveToPoint(ctx, minx, midy);
		CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
		CGContextClosePath(ctx);
		CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
		CGContextSetLineWidth(ctx, _progressBorderWidth);
		CGContextDrawPath(ctx, kCGPathStroke);
		
		radius = _progressBarRadius;
		
		rrect = CGRectInset(rrect, _progressBarInset, _progressBarInset);
		rrect.size.width = rrect.size.width * _theProgress;
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
