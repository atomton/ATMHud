/*
 *  ATMHudView.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

@class ATMTextLayer, ATMProgressLayer, ATMHud, ATMHudQueueItem;

typedef enum {
	ATMHudApplyModeShow = 0,
	ATMHudApplyModeUpdate,
	ATMHudApplyModeHide
} ATMHudApplyMode;

@interface ATMHudView : UIView
@property (nonatomic, weak) ATMHud *p;	// delegate
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;

@property (nonatomic, assign) BOOL showActivity;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGRect targetBounds;
@property (nonatomic, assign) CGRect captionRect;
@property (nonatomic, assign) CGRect progressRect;
@property (nonatomic, assign) CGRect activityRect;
@property (nonatomic, assign) CGRect imageRect;

@property (nonatomic, assign) CGSize fixedSize;
@property (nonatomic, assign) CGSize activitySize;

@property (nonatomic, strong) CALayer *backgroundLayer;
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) ATMTextLayer *captionLayer;
@property (nonatomic, strong) ATMProgressLayer *progressLayer;

- (id)initWithFrame:(CGRect)frame andController:(ATMHud *)c;

- (CGRect)sharpRect:(CGRect)rect;
- (CGPoint)sharpPoint:(CGPoint)point;

- (void)calculate;
- (CGSize)calculateSizeForQueueItem:(ATMHudQueueItem *)item;
- (CGSize)sizeForActivityStyle:(UIActivityIndicatorViewStyle)style;
- (void)applyWithMode:(ATMHudApplyMode)mode;
- (void)show;
- (void)reset;
- (void)update;
- (void)hide;

@end
