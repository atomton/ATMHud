/*
 *  ATMHudProgressLayer.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import <QuartzCore/CALayer.h>

@interface ATMProgressLayer : CALayer
@property (nonatomic, assign) CGFloat theProgress;
@property (nonatomic, assign) CGFloat progressBorderWidth;
@property (nonatomic, assign) CGFloat progressBorderRadius;
@property (nonatomic, assign) CGFloat progressBarRadius;
@property (nonatomic, assign) CGFloat progressBarInset;

@end
