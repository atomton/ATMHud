/*
 *  ATMHud.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

@class ATMHudView, ATMSoundFX, ATMHudQueueItem;
@protocol ATMHudDelegate;

typedef enum {
	ATMHudAccessoryPositionTop = 0,
	ATMHudAccessoryPositionRight,
	ATMHudAccessoryPositionBottom,
	ATMHudAccessoryPositionLeft
} ATMHudAccessoryPosition;

@interface ATMHud : UIViewController
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) CGFloat gray;
@property (nonatomic, assign) CGFloat hideDelay;	// wait this long before closing (not directly used by this class)
@property (nonatomic, assign) CGFloat animateDuration;
@property (nonatomic, assign) CGFloat appearScaleFactor;
@property (nonatomic, assign) CGFloat disappearScaleFactor;
@property (nonatomic, assign) CGFloat progressBorderRadius;
@property (nonatomic, assign) CGFloat progressBorderWidth;
@property (nonatomic, assign) CGFloat progressBarRadius;
@property (nonatomic, assign) CGFloat progressBarInset;

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, assign) BOOL blockTouches;
@property (nonatomic, assign) BOOL allowSuperviewInteraction;

@property (nonatomic, copy) NSString *showSound;
@property (nonatomic, copy) NSString *updateSound;
@property (nonatomic, copy) NSString *hideSound;

@property (nonatomic, weak) id <ATMHudDelegate> delegate;
@property (nonatomic, assign) ATMHudAccessoryPosition accessoryPosition;

@property (nonatomic, strong) ATMHudView *__view;
@property (nonatomic, strong) ATMSoundFX *sound;
@property (nonatomic, strong) NSMutableArray *displayQueue;
@property (nonatomic, assign) NSUInteger queuePosition;
@property (nonatomic, copy) void (^userObject)();			// for use by users

+ (NSString *)buildInfo;

- (id)initWithDelegate:(id)hudDelegate;

- (void)setCaption:(NSString *)caption;
- (void)setImage:(UIImage *)image;
- (void)setActivity:(BOOL)activity;
- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle;
- (void)setFixedSize:(CGSize)fixedSize;
- (void)setProgress:(CGFloat)progress;

- (void)addQueueItem:(ATMHudQueueItem *)item;
- (void)addQueueItems:(NSArray *)items;
- (void)clearQueue;
- (void)startQueue;
- (void)showNextInQueue;
- (void)showQueueAtIndex:(NSUInteger)index;

- (void)show;
- (void)update;
- (void)hide;
- (void)hideAfter:(NSTimeInterval)delay;

#ifdef ATM_SOUND
- (void)playSound:(NSString *)soundPath;
#endif

@end
