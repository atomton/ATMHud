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
- (void)userDidTapHud:(ATMHud *)_hud;
- (void)hudWillAppear:(ATMHud *)_hud;
- (void)hudDidAppear:(ATMHud *)_hud;
- (void)hudWillUpdate:(ATMHud *)_hud;
- (void)hudDidUpdate:(ATMHud *)_hud;
- (void)hudWillDisappear:(ATMHud *)_hud;
- (void)hudDidDisappear:(ATMHud *)_hud;

@end
