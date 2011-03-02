/*
 *  ATMHudQueueItem.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import "ATMHudQueueItem.h"

@implementation ATMHudQueueItem
@synthesize caption, image, showActivity, accessoryPosition, activityStyle;

- (id)init {
	if ((self = [super init])) {
		caption = @"";
		image = nil;
		showActivity = NO;
		accessoryPosition = ATMHudAccessoryPositionBottom;
		activityStyle = UIActivityIndicatorViewStyleWhite;
	}
	return self;
}

- (void)dealloc {
	[caption release];
	[image release];
	[super dealloc];
}

@end
