/*
 *  ATMHudView.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

@class ATMTextLayer, ATMProgressLayer, ATMHud, ATMHudQueueItem;

typedef enum {
	ATMHudApplyModeShow = 0,
	ATMHudApplyModeUpdate,
	ATMHudApplyModeHide
} ATMHudApplyMode;


@interface ATMHudView : UIView
@property (nonatomic, weak) ATMHud *hud;				// delegate
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;

@property (nonatomic, assign) BOOL showActivity;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGSize fixedSize;
@property (nonatomic, assign) CGSize activitySize;
@property (nonatomic, strong) CALayer *backgroundLayer;

- (instancetype)initWithFrame:(CGRect)frame andController:(ATMHud *)c;

- (CGSize)calculateSizeForQueueItem:(ATMHudQueueItem *)item;
- (void)show;
- (void)reset;
- (void)update;
- (void)hide;

@end

