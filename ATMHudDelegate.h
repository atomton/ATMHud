/*
 *  ATMHudDelegate.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

@class ATMHud;

@protocol ATMHudDelegate <NSObject>

@optional
- (void)userDidTapHud:(ATMHud *)theHud;			// tapped the visible HUD
- (void)userDidTapOutsideHud:(ATMHud *)theHud;	// tapped outside the HUD

- (void)hudWillAppear:(ATMHud *)theHud;
- (void)hudDidAppear:(ATMHud *)theHud;
- (void)hudWillUpdate:(ATMHud *)theHud;
- (void)hudDidUpdate:(ATMHud *)theHud;
- (void)hudWillDisappear:(ATMHud *)theHud;

@required
- (void)hudDidDisappear:(ATMHud *)theHud;

@end
