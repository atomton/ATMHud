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

@interface ATMHudView : UIView {
	NSString *caption;
	UIImage *image;
	UIActivityIndicatorView *activity;
	UIActivityIndicatorViewStyle activityStyle;
	ATMHud *p;
	
	BOOL showActivity;
 
	CGFloat progress;
	
	CGRect targetBounds;
	CGRect captionRect;
	CGRect progressRect;
	CGRect activityRect;
	CGRect imageRect;
	
	CGSize fixedSize;
	CGSize activitySize;
	
	CALayer *backgroundLayer;
	CALayer *imageLayer;
	ATMTextLayer *captionLayer;
	ATMProgressLayer *progressLayer;
}

@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;
@property (nonatomic, retain) ATMHud *p;

@property (nonatomic, assign) BOOL showActivity;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGRect targetBounds;
@property (nonatomic, assign) CGRect captionRect;
@property (nonatomic, assign) CGRect progressRect;
@property (nonatomic, assign) CGRect activityRect;
@property (nonatomic, assign) CGRect imageRect;

@property (nonatomic, assign) CGSize fixedSize;
@property (nonatomic, assign) CGSize activitySize;

@property (nonatomic, retain) CALayer *backgroundLayer;
@property (nonatomic, retain) CALayer *imageLayer;
@property (nonatomic, retain) ATMTextLayer *captionLayer;
@property (nonatomic, retain) ATMProgressLayer *progressLayer;

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
