/*
 *  ATMHud.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import <UIKit/UIKit.h>

#import "ATMProgressLayer.h"	// For the style enum

@class ATMHud, ATMHudQueueItem;
#ifdef ATM_SOUND
@class ATMSoundFX;
#endif
@protocol ATMHudDelegate;

typedef NS_ENUM(NSInteger, ATMHudAccessoryPosition) {
	ATMHudAccessoryPositionTop = 0,
	ATMHudAccessoryPositionRight,
	ATMHudAccessoryPositionBottom,
	ATMHudAccessoryPositionLeft
};

// See DemoViewController for blockDelegate usage 
typedef NS_ENUM(NSInteger, ATMHudAction) {
	ATMHudActionUserDidTapHud,			// actual HUD
	ATMHudActionUserDidTapOutsideHud,	// somewhere else in the view

	ATMHudActionWillAppear,
	ATMHudActionDidAppear,
	ATMHudActionWillUpdate,
	ATMHudActionDidUpdate,
	ATMHudActionWillDisappear,
	ATMHudActionDidDisappear,

	// add your own functionality to the blockDelegate, for instance to dismiss an action sheet
	ATMHudActionUsrAction1,
	ATMHudActionUsrAction2,
	ATMHudActionUsrAction3,
	ATMHudActionUsrAction4,
};


NS_ASSUME_NONNULL_BEGIN

typedef void (^ATMblockDelegate)(ATMHudAction msg, ATMHud *hud);

@interface ATMHud : UIViewController
// Properties persist from show to show
@property (nonatomic, assign) CGFloat margin;						// default 10.0f
@property (nonatomic, assign) CGFloat padding;						// default 10.0f
@property (nonatomic, assign) CGFloat alpha;						// default 0.8f
@property (nonatomic, assign) CGFloat gray;							// default 0.8f
@property (nonatomic, assign) CGFloat animateDuration;				// default 0.1f
@property (nonatomic, assign) CGFloat progressBorderRadius;			// default 8.0f
@property (nonatomic, assign) ATMHudProgressStyle progressStyle;	// default ATMHudProgressStyleBar. Must set before the HudView is created.
@property (nonatomic, assign) CGFloat progressBorderWidth;			// default 2.0f
@property (nonatomic, assign) CGFloat progressRadius;				// default 5.0f
@property (nonatomic, assign) CGFloat progressInset;				// default 3.0f
@property (nonatomic, assign) CGFloat appearScaleFactor;			// default 0.8;
@property (nonatomic, assign) CGFloat disappearScaleFactor;			// default 5.0f
@property (nonatomic, assign) NSTimeInterval minShowTime;			// default 0 sec - do not hide even if told to until this much time elapses
																	//                 to insure HUD visible at least this long
																	// set "minShowTime" before "show" , then send show, then send hide
@property (nonatomic, assign) CGPoint center;						// default {0, 0} - clients can place the HUD center above or below the real view centerpoint
@property (nonatomic, assign) BOOL shadowEnabled;					// default NO
@property (nonatomic, assign) BOOL usesParallax;					// default YES
@property (nonatomic, assign) CGFloat backgroundAlpha;				// default 0.0f; applied as [UIColor colorWithWhite:backgroundAlpha alpha:backgroundAlpha];
@property (nonatomic, strong) UIColor *hudBackgroundColor;			// default is a light slightly blue color

@property (nonatomic, weak) id <ATMHudDelegate> delegate;			// traditional delegate
@property (nonatomic, copy) ATMblockDelegate blockDelegate;			// block delegate
@property (nonatomic, copy, nullable) void (^convenienceBlock)();	// ATMHud will keep this block around for you
#ifdef ATM_SOUND
@property (nonatomic, strong) ATMSoundFX *sound;
#endif
@property (nonatomic, assign, readonly) NSUInteger queuePosition;	// item which is showing

+ (NSString *)version;

- (instancetype)initWithDelegate:(id)hudDelegate;

// These variables are reset after each hide
- (void)setCaption:(NSString *)caption;										// Reset to @"" after each hide
- (void)setImage:(UIImage * _Nullable )image;								// Reset to nil
- (void)setActivity:(BOOL)activity;											// Reset to NO
- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle;		// Reset to UIActivityIndicatorViewStyleWhite
- (void)setAccessoryPosition:(ATMHudAccessoryPosition)pos;					// Reset to ATMHudAccessoryPositionBottom
- (void)setFixedSize:(CGSize)fixedSize;										// Reset to CGSizeZero
- (void)setProgress:(CGFloat)progress;										// Reset to 0
- (void)setCenter:(CGPoint)pt;												// Reset to CGPointZero
- (void)setBlockTouches:(BOOL)val;											// Reset to NO
- (void)setAllowSuperviewInteraction:(BOOL)val;								// Reset to NO
#ifdef ATM_SOUND
- (void)setShowSound:(NSString *)sound;										// Reset to nil
- (void)setUpdateSound:(NSString *)sound;									// Reset to nil
- (void)setHideSound:(NSString *)sound;										// Reset to nil
#endif

- (ATMHudAccessoryPosition)accessoryPosition;
- (BOOL)allowSuperviewInteraction;
#ifdef ATM_SOUND
- (NSString *)showSound;
- (NSString *)updateSound;
- (NSString *)hideSound;
#endif

- (void)addQueueItem:(ATMHudQueueItem *)item;
- (void)addQueueItems:(NSArray<ATMHudQueueItem *> *)items;
- (void)clearQueue;
- (void)startQueueInView:(UIView *)view;
- (void)showNextInQueue;

- (void)showInView:(UIView *)view;
- (void)update;
- (void)hide;			// Ordered removal. Note: now removes the hudView from its superview
- (void)unloadView;		// Blunt force removal. Do not call hide.


- (void)show __attribute__((deprecated));								// use showInView
- (void)hideAfter:(NSTimeInterval)delay __attribute__((deprecated));	// set "minShowTime" before "show" , then show, then send "hide"

#ifdef ATM_SOUND
- (void)playSound:(NSString *)soundPath;
#endif

@end

NS_ASSUME_NONNULL_END
