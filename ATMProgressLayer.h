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

typedef NS_ENUM(NSInteger, ATMHudProgressStyle) {
	ATMHudProgressStyleBar,
	ATMHudProgressStyleCircle
};

@interface ATMProgressLayer : CALayer
@property (nonatomic, assign) ATMHudProgressStyle progressStyle;

@property (nonatomic, assign) CGFloat theProgress;
@property (nonatomic, assign) CGFloat progressBorderWidth;
@property (nonatomic, assign) CGFloat progressBorderRadius;
@property (nonatomic, assign) CGFloat progressRadius;
@property (nonatomic, assign) CGFloat progressInset;

- (CGSize)progressSize;

@end

