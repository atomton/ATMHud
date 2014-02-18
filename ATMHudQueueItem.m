/*
 *  ATMHudQueueItem.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import "ATMHudQueueItem.h"

@implementation ATMHudQueueItem

- (instancetype)init
{
	if ((self = [super init])) {
		_caption = @"";
		_accessoryPosition = ATMHudAccessoryPositionBottom;
		_activityStyle = UIActivityIndicatorViewStyleWhite;
	}
	return self;
}


@end
