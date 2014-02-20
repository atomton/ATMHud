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


@class ATMHud, ATMHudQueueItem;
#ifdef ATM_SOUND
@class ATMSoundFX;
#endif
@protocol ATMHudDelegate;

typedef enum {
	ATMHudAccessoryPositionTop = 0,
	ATMHudAccessoryPositionRight,
	ATMHudAccessoryPositionBottom,
	ATMHudAccessoryPositionLeft
} ATMHudAccessoryPosition;

// See DemoViewController for blockDelegate usage 
typedef enum {
	userDidTapHud,			// actual HUD
	userDidTapOutsideHud,	// somewhere else in the view

	hudWillAppear,
	hudDidAppear,
	hudWillUpdate,
	hudDidUpdate,
	hudWillDisappear,
	hudDidDisappear,

	// add your own functionality to the blockDelegate, for instance to dismiss an action sheet
	usrAction1,
	usrAction2,
	usrAction3,
	usrAction4,
} delegateMessages;
typedef void (^ATMblockDelegate)(delegateMessages msg, ATMHud *hud);


@interface ATMHud : UIViewController
// Properties persist from show to show
@property (nonatomic, assign) CGFloat margin;						// default 10.0f
@property (nonatomic, assign) CGFloat padding;						// default 10.0f
@property (nonatomic, assign) CGFloat alpha;						// default 0.8f
@property (nonatomic, assign) CGFloat gray;							// default 0.8f
@property (nonatomic, assign) CGFloat animateDuration;				// default 0.1f
@property (nonatomic, assign) CGFloat progressBorderRadius;			// default 8.0f
@property (nonatomic, assign) CGFloat progressBorderWidth;			// default 2.0f
@property (nonatomic, assign) CGFloat progressBarRadius;			// default 5.0f
@property (nonatomic, assign) CGFloat progressBarInset;				// default 3.0f
@property (nonatomic, assign) CGFloat appearScaleFactor;			// default 0.8;
@property (nonatomic, assign) CGFloat disappearScaleFactor;			// default 5.0f
@property (nonatomic, assign) NSTimeInterval minShowTime;			// default 0 sec - do not hide even if told to until this much time elapses
																	//                 to insure HUD visible at least this long
@property (nonatomic, assign) CGPoint center;						// default {0, 0} - clients can place the HUD center above or below the real view centerpoint
@property (nonatomic, assign) BOOL shadowEnabled;					// default NO
@property (nonatomic, assign) CGFloat backgroundAlpha;				// default 0.0f; applied as [UIColor colorWithWhite:backgroundAlpha alpha:backgroundAlpha];

@property (nonatomic, weak) id <ATMHudDelegate> delegate;			// traditional delegate
@property (nonatomic, copy) ATMblockDelegate blockDelegate;			// block delegate
#ifdef ATM_SOUND
@property (nonatomic, strong) ATMSoundFX *sound;
#endif
@property (nonatomic, assign, readonly) NSUInteger queuePosition;	// item which is showing

+ (NSString *)version;

- (instancetype)initWithDelegate:(id)hudDelegate;

// These variables are reset after each hide
- (void)setCaption:(NSString *)caption;										// Reset to @"" after each hide
- (void)setImage:(UIImage *)image;											// Reset to nil
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
- (void)addQueueItems:(NSArray *)items;
- (void)clearQueue;
- (void)startQueueInView:(UIView *)view;
- (void)showNextInQueue;

- (void)showInView:(UIView *)view;
- (void)update;
- (void)hide;	// note: now removes the view from its superview

- (void)show __attribute__((deprecated));								// use showInView
- (void)hideAfter:(NSTimeInterval)delay __attribute__((deprecated));	// set minShowTime to insure the HUD shows for at least some period of time

#ifdef ATM_SOUND
- (void)playSound:(NSString *)soundPath;
#endif

@end
