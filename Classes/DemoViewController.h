/*
 *  DemoViewController.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	This sample project uses the sound
 *		Hard pop.wav http://www.freesound.org/samplesViewSingle.php?id=108616
 *	by
 *		juskiddink http://www.freesound.org/usersViewSingle.php?id=649468
 *	licensed under
 *		Creative Commons Sampling Plus 1.0 License http://creativecommons.org/licenses/sampling+/1.0/
 *
 *	The two icons "11-x.png" and "19-check.png" are taken from the Glyphish icon set,
 *	with kind permission of Joseph Wain.
 *	You can get them here: http://glyphish.com/
 *
 *	https://github.com/atomton/ATMHud
 */

#import <UIKit/UIKit.h>
#import "ATMHudDelegate.h"
@class ATMHud;

@interface DemoViewController : UIViewController <ATMHudDelegate, UITableViewDataSource, UITableViewDelegate> {
	UITableView *tv_demo;
	ATMHud *hud;
	
	NSArray *sectionHeaders;
	NSArray *sectionFooters;
	NSArray *cellCaptions;
	
	BOOL useFixedSize;
}

@property (nonatomic, retain) UITableView *tv_demo;
@property (nonatomic, retain) ATMHud *hud;

@property (nonatomic, retain) NSArray *sectionHeaders;
@property (nonatomic, retain) NSArray *sectionFooters;
@property (nonatomic, retain) NSArray *cellCaptions;

@property (nonatomic, assign) BOOL useFixedSize;

@end
