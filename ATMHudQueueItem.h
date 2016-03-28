/*
 *  ATMHudQueueItem.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import "ATMHud.h"

@interface ATMHudQueueItem : NSObject
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL showActivity;
@property (nonatomic, assign) ATMHudAccessoryPosition accessoryPosition;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;

@end
