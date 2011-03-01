/*
 *  ATMHudProgressLayer.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import <QuartzCore/CALayer.h>

@interface ATMProgressLayer : CALayer {
	CGFloat theProgress;
	CGFloat progressBorderWidth;
	CGFloat progressBorderRadius;
	CGFloat progressBarRadius;
	CGFloat progressBarInset;
}

@property (nonatomic, assign) CGFloat theProgress;
@property (nonatomic, assign) CGFloat progressBorderWidth;
@property (nonatomic, assign) CGFloat progressBorderRadius;
@property (nonatomic, assign) CGFloat progressBarRadius;
@property (nonatomic, assign) CGFloat progressBarInset;

@end
