/*
 *  ATMHudQueueItem.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import <Foundation/Foundation.h>
#import "ATMHud.h"

@interface ATMHudQueueItem : NSObject {
	NSString *caption;
	UIImage *image;
	BOOL showActivity;
	ATMHudAccessoryPosition accessoryPosition;
	UIActivityIndicatorViewStyle activityStyle;
}

@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) BOOL showActivity;
@property (nonatomic, assign) ATMHudAccessoryPosition accessoryPosition;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;

@end
