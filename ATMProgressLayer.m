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

#import <UIKit/UIKit.h>

#import "ATMProgressLayer.h"

#define PROGRESS_HEIGHT_BAR			10
#define PROGRESS_WIDTH_BAR			210
#define PROGRESS_DIMENSION_CIRCLE	40

@implementation ATMProgressLayer

- (CGSize)progressSize
{
	if(_progressStyle == ATMHudProgressStyleBar) {
		return CGSizeMake(PROGRESS_WIDTH_BAR, PROGRESS_HEIGHT_BAR);
	} else {
		return CGSizeMake(PROGRESS_DIMENSION_CIRCLE, PROGRESS_DIMENSION_CIRCLE);
	}
}

- (void)setTheProgress:(CGFloat)p
{
	_theProgress = p;
	[self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
	UIGraphicsPushContext(ctx);
	if (_theProgress > 0) {
		if(_progressStyle == ATMHudProgressStyleBar) {
			[self drawBar:ctx];
		} else {
			[self drawCircle:ctx];
		}
	}
	UIGraphicsPopContext();
}

- (void)drawBar:(CGContextRef)ctx
{
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
	//CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
	CGContextSetRGBStrokeColor(ctx,0, 0, 0, 1);
	CGContextSetLineWidth(ctx, _progressBorderWidth);
	CGContextDrawPath(ctx, kCGPathStroke);
	
	radius = _progressRadius;
	
	rrect = CGRectInset(rrect, _progressInset, _progressInset);
	rrect.size.width = rrect.size.width * _theProgress;
	minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(ctx, minx, midy);
	CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
	CGContextClosePath(ctx);
	//CGContextSetRGBFillColor(ctx,1, 1, 1, 1);
	CGContextSetRGBFillColor(ctx,0, 0, 0, 1);	// DFH
	CGContextDrawPath(ctx, kCGPathFill);
}

- (void)drawCircle:(CGContextRef)ctx
{

	CGRect rrect = CGRectInset(self.bounds, _progressBorderWidth, _progressBorderWidth);
	CGFloat radius = PROGRESS_DIMENSION_CIRCLE/2 - _progressBorderRadius;
	
	CGFloat midx = CGRectGetMidX(rrect);
	CGFloat midy = CGRectGetMidY(rrect);

	CGContextAddArc(ctx, midx, midy, radius, 0, 2.0*M_PI, 1);
	CGContextClosePath(ctx);

	CGContextSetRGBStrokeColor(ctx,0, 0, 0, 1);
	CGContextSetLineWidth(ctx, _progressBorderWidth);
	CGContextDrawPath(ctx, kCGPathStroke);

	CGFloat progressWidth = _progressBorderWidth * 4;
	radius -= progressWidth/2;

	CGFloat radians = (2*M_PI*_theProgress);
	CGContextAddArc(ctx, midx, midy, radius, -2.0*M_PI/4.0, -2.0*M_PI/4.0 + radians, 0);
	//CGContextClosePath(ctx);

	CGContextSetRGBStrokeColor(ctx,0, 0, 0, 1);
	CGContextSetLineWidth(ctx, progressWidth);
	CGContextDrawPath(ctx, kCGPathStroke);
}

@end
