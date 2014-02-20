/*
 *  ATMHud.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import <QuartzCore/QuartzCore.h>
#ifdef ATM_SOUND
#import <AudioToolbox/AudioServices.h>
#endif
#import "ATMHud.h"
#import "ATMHudView.h"
#import "ATMHudDelegate.h"
#import "ATMHudQueueItem.h"
#ifdef ATM_SOUND
#import "ATMSoundFX.h"
#endif

#define VERSION @"atomHUD 3.0.0 • 2014-02-11"

@interface ATMHud ()
@property (nonatomic, assign) NSUInteger queuePosition;
@property (nonatomic, assign) ATMHudAccessoryPosition accessoryPosition;
@property (nonatomic, assign) BOOL blockTouches;
@property (nonatomic, assign) BOOL allowSuperviewInteraction;
#ifdef ATM_SOUND
@property (nonatomic, copy) NSString *showSound;
@property (nonatomic, copy) NSString *updateSound;
@property (nonatomic, copy) NSString *hideSound;
#endif

@end


@implementation ATMHud
{
	ATMHudView		*hudView;
	NSMutableArray	*displayQueue;
	NSDate			*minShowDate;
}

+ (NSString *)version
{
	return VERSION;
}

- (instancetype)init
{
	if ((self = [super init])) {
		_margin						= 10.0f;
		_padding					= 10.0f;
		_alpha						= 0.8f;		// DFH: originally 0.7
		_gray						= 0.2f;		// DFH: originally 0.0
		_animateDuration			= 0.1f;
		_progressBorderRadius		= 8.0f;
		_progressBorderWidth		= 2.0f;
		_progressBarRadius			= 5.0f;
		_progressBarInset			= 3.0f;
		_appearScaleFactor			= 0.8;		// DFH: originally 1.4f
		_disappearScaleFactor		= 0.8;		// DFH: originally 1.4f
#if 0 // these default to these
		_minShowTime				= 0;
		_center						= CGPointZero;
		_blockTouches				= NO;
		_allowSuperviewInteraction	= NO;
		_removeViewWhenHidden		= NO;
		_shadowEnabled				= NO;
		_backgroundAlpha			= 0;
		_queuePosition				= 0;
#endif
		hudView = [[ATMHudView alloc] initWithFrame:CGRectZero andController:self];
		hudView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin		|
									UIViewAutoresizingFlexibleRightMargin	|
									UIViewAutoresizingFlexibleBottomMargin	|
									UIViewAutoresizingFlexibleLeftMargin );
		[hudView reset];						// actually sets many of our variables
	}
	return self;
}

- (instancetype)initWithDelegate:(id)hudDelegate
{
	if ((self = [self init])) {
		_delegate = hudDelegate;
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"ATM HUD DEALLOC...");
	[hudView removeFromSuperview];
	[self.view removeFromSuperview];
	NSLog(@"...ATM HUD DEALLOC");
}

- (void)loadView
{
	UIView *base = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	base.backgroundColor		= [UIColor colorWithWhite:_backgroundAlpha alpha:_backgroundAlpha];
	base.autoresizingMask		= (UIViewAutoresizingFlexibleWidth |
							       UIViewAutoresizingFlexibleHeight);
	base.userInteractionEnabled	= NO;
	[base addSubview:hudView];

	self.view = base;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Overrides

- (void)setAppearScaleFactor:(CGFloat)value
{
	if (!isnormal(value)) {
		value = 0.01f;
	}
	_appearScaleFactor = value;
}

- (void)setDisappearScaleFactor:(CGFloat)value
{
	if (!isnormal(value)) {
		value = 0.01f;
	}
	_disappearScaleFactor = value;
}

- (void)setAlpha:(CGFloat)value
{
	_alpha = value;
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	hudView.backgroundLayer.backgroundColor = [UIColor colorWithWhite:_gray alpha:value].CGColor;
	[CATransaction commit];
}

- (void)setGray:(CGFloat)value
{
	_gray = value;
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	hudView.backgroundLayer.backgroundColor = [UIColor colorWithWhite:_gray alpha:_alpha].CGColor;
	[CATransaction commit];
}

- (void)setCenter:(CGPoint)pt
{
	_center = pt;
	hudView.center = pt;
}

- (void)setShadowEnabled:(BOOL)value
{
	_shadowEnabled = value;
	hudView.layer.shadowOpacity = value ? 0.4f :0.0f;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"HUD: caption=%@", hudView.caption];
}

#pragma mark -
#pragma mark Property forwards

- (void)setCaption:(NSString *)caption
{
	hudView.caption = caption;
}

- (void)setImage:(UIImage *)image
{
	hudView.image = image;
}

- (void)setActivity:(BOOL)activity
{
	hudView.showActivity = activity;
	if (activity) {
		[hudView.activity startAnimating];
	} else {
		[hudView.activity stopAnimating];
	}
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle
{
	hudView.activityStyle = activityStyle;
	hudView.activitySize = activityStyle == UIActivityIndicatorViewStyleWhiteLarge ? CGSizeMake(37, 37) : CGSizeMake(20, 20);
}

- (void)setFixedSize:(CGSize)fixedSize
{
	hudView.fixedSize = fixedSize;
}

- (void)setProgress:(CGFloat)progress
{
	if (progress < 0) progress = 0;
	else
	if (progress > 1.0f) progress = 1;
	
	hudView.progress = progress;
}

#pragma mark -
#pragma mark Queue

- (void)addQueueItem:(ATMHudQueueItem *)item
{
	if(!displayQueue) {
		displayQueue = [NSMutableArray arrayWithCapacity:4];
	}
	[displayQueue addObject:item];
}

- (void)addQueueItems:(NSArray *)items
{
	[displayQueue addObjectsFromArray:items];
}

- (void)clearQueue
{
	[displayQueue removeAllObjects];
}

- (void)startQueueInView:(UIView *)view
{
	_queuePosition = 0;
	if (!CGSizeEqualToSize(hudView.fixedSize, CGSizeZero)) {
		CGSize newSize = hudView.fixedSize;
		CGSize targetSize;
		ATMHudQueueItem *queueItem;
		for (NSUInteger i = 0; i < [displayQueue count]; i++) {
			queueItem = displayQueue[i];
			
			targetSize = [hudView calculateSizeForQueueItem:queueItem];
			if (targetSize.width > newSize.width) {
				newSize.width = targetSize.width;
			}
			if (targetSize.height > newSize.height) {
				newSize.height = targetSize.height;
			}
		}
		[self setFixedSize:newSize];
	}
	[self showQueueAtIndex:_queuePosition inView:view];
}

- (void)showNextInQueue
{
	_queuePosition++;
	[self showQueueAtIndex:_queuePosition inView:nil];
}

- (void)showQueueAtIndex:(NSUInteger)index inView:view
{
	if ([displayQueue count] > 0) {
		_queuePosition = index;
		if (_queuePosition == [displayQueue count]) {
			[self hide];
			return;
		}
		ATMHudQueueItem *item = displayQueue[_queuePosition];
		
		hudView.caption = item.caption;
		hudView.image = item.image;
		
		BOOL flag = item.showActivity;
		hudView.showActivity = flag;
		if (flag) {
			[hudView.activity startAnimating];
		} else {
			[hudView.activity stopAnimating];
		}
		
		_accessoryPosition = item.accessoryPosition;
		[self setActivityStyle:item.activityStyle];
		
		if (_queuePosition == 0) {
			[self showInView:view];
		} else {
			[self update];
		}
	}
}

#pragma mark -
#pragma mark Controlling

- (void)showInView:(UIView *)v
{
	self.view.frame = v.bounds;

	[v addSubview:self.view];
	[self _show];
}

- (void)show
{
	[self _show];
}

- (void)_show
{
	[self updateHideTime];
	[hudView show];
}

- (void)update
{
	[self updateHideTime];
	[hudView update];
}

- (void)updateHideTime
{
	if (isnormal(_minShowTime)) {
		minShowDate = [NSDate dateWithTimeIntervalSinceNow:_minShowTime];
	} else {
		minShowDate = nil;	// just be sure
	}
}

- (void)hide
{
	_blockTouches = YES;

	NSTimeInterval x = [minShowDate timeIntervalSinceDate:[NSDate date]];	// if minShowDate==nil then x==0
	if (x <= 0) {
		[hudView hide];
	} else {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, x * NSEC_PER_SEC), dispatch_get_main_queue(), ^
			{
				[hudView hide];
			} );
	}
}

- (void)hideAfter:(NSTimeInterval)delay
{
	_blockTouches = YES;

	[self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

#pragma mark -
#pragma mark Internal methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!_blockTouches) {
		_blockTouches = YES;
		UITouch *aTouch = [touches anyObject];
		if (aTouch.tapCount == 1) {
			CGPoint p = [aTouch locationInView:self.view];
			if (CGRectContainsPoint(hudView.frame, p)) {
				if ([(id)_delegate respondsToSelector:@selector(userDidTapHud:)]) {
					[_delegate userDidTapHud:self];
				}
				if (_blockDelegate) {
					_blockDelegate(userDidTapHud, self);
				}
			} else {
				if ([(id)_delegate respondsToSelector:@selector(userDidTapOutsideHud:)]) {
					[_delegate userDidTapOutsideHud:self];
				}
				if (_blockDelegate) {
					_blockDelegate(userDidTapOutsideHud, self);
				}
			}
		}
		_blockTouches = NO;
	}
}

#ifdef ATM_SOUND
- (void)playSound:(NSString *)soundPath
{
	_sound = [[ATMSoundFX alloc] initWithContentsOfFile:soundPath];
	[_sound play];
}
#endif

@end
