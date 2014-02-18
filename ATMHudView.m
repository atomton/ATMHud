/*
 *  ATMHudView.m
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

#import "ATMHudView.h"
#import "ATMTextLayer.h"
#import "ATMProgressLayer.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"
#import "ATMHudQueueItem.h"

@interface ATMHudView ()

@end

@implementation ATMHudView
{
	CGRect				targetBounds;
	CALayer				*imageLayer;
	ATMTextLayer		*captionLayer;
	ATMProgressLayer	*progressLayer;
	CGRect				captionRect;
	CGRect				progressRect;
	CGRect				activityRect;
	CGRect				imageRect;
	BOOL				didHide;
	UIFont				*bsf14;
}

- (CGPoint)integralPoint:(CGPoint)point
{
	CGPoint _p = point;
	_p.x = rintf((float)_p.x);
	_p.y = rintf((float)_p.y);
	return _p;
}

- (void)removeFromSuperview
{
	NSLog(@"removeFromSuperview");
	[super removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame andController:(ATMHud *)h
{
    if ((self = [super initWithFrame:frame])) {
		_hud = h;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.alpha = 0.0;
		
		bsf14 = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
	
		_backgroundLayer = [CALayer new];
		_backgroundLayer.cornerRadius = 10;
		_backgroundLayer.backgroundColor = [UIColor colorWithWhite:_hud.gray alpha:_hud.alpha].CGColor;
		[self.layer addSublayer:_backgroundLayer];
		
		captionLayer = [ATMTextLayer new];
		captionLayer.contentsScale = [[UIScreen mainScreen] scale];
		captionLayer.anchorPoint = CGPointMake(0, 0);
		[self.layer addSublayer:captionLayer];
		
		imageLayer = [CALayer new];
		imageLayer.anchorPoint = CGPointMake(0, 0);
		[self.layer addSublayer:imageLayer];
		
		progressLayer = [ATMProgressLayer new];
		progressLayer.contentsScale = [[UIScreen mainScreen] scale];
		progressLayer.anchorPoint = CGPointMake(0, 0);
		[self.layer addSublayer:progressLayer];
		
		_activity = [UIActivityIndicatorView new];
		_activity.hidesWhenStopped = YES;
		[self addSubview:_activity];
		
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowRadius = 8.0;
		self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
		self.layer.shadowOpacity = 0.4f;
		
		progressRect = CGRectMake(0, 0, 210, 20);
		_activityStyle = UIActivityIndicatorViewStyleWhite;
		_activitySize = CGSizeMake(20, 20);
		
		didHide = YES;
    }
    return self;
}

- (void)dealloc
{
	NSLog(@"ATM_HUD_VIEW DEALLOC");
}

- (void)setProgress:(CGFloat)_p
{
	_p = MIN(MAX(0,_p),1);
	
	if (_p > 0 && _p < 0.08f) _p = 0.08f;
	if (_p == _progress) return;
	
	_progress = _p;
	progressLayer.theProgress = _progress;
}

- (CGRect)calcString:(NSString *)str sizeForSize:(CGSize)origSize
{
	NSStringDrawingContext *sdc = [NSStringDrawingContext new];
	sdc.minimumScaleFactor = 0;
	
	NSParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle];	// uses LineBreakWordWrapping
	NSDictionary *dict = @{ NSFontAttributeName : bsf14, NSParagraphStyleAttributeName : paragraphStyle };
	
	CGRect r = [_caption boundingRectWithSize:origSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:sdc];
	
	return CGRectIntegral(r);
}

- (void)calculate
{
	if (![_caption length]) {
		activityRect = CGRectMake(_hud.margin, _hud.margin, _activitySize.width, _activitySize.height);
		targetBounds = CGRectMake(0, 0, _hud.margin*2+_activitySize.width, _hud.margin*2+_activitySize.height);
	} else {
		BOOL hasFixedSize = NO;
		captionRect = [self calcString:_caption sizeForSize:CGSizeMake(160, 200)];
		if (_fixedSize.width > 0 & _fixedSize.height > 0) {
			CGSize s = _fixedSize;
			if (_progress > 0 && (_fixedSize.width < progressRect.size.width+_hud.margin*2)) {
				s.width = progressRect.size.width+_hud.margin*2;
			}
			hasFixedSize = YES;
			captionRect = [self calcString:_caption sizeForSize:CGSizeMake(s.width-_hud.margin*2, 200)];
			targetBounds = CGRectMake(0, 0, s.width, s.height);
		}
		
		float adjustment = 0;
		CGFloat marginX = _hud.margin;
		CGFloat marginY = _hud.margin;
		if (!hasFixedSize) {
			if (_hud.accessoryPosition == ATMHudAccessoryPositionTop || _hud.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (_progress > 0) {
					adjustment = _hud.padding+progressRect.size.height;
					if (captionRect.size.width+_hud.margin*2 < progressRect.size.width) {
						captionRect = [self calcString:_caption sizeForSize:CGSizeMake(progressRect.size.width, 200)];
						targetBounds = CGRectMake(0, 0, progressRect.size.width+_hud.margin*2, captionRect.size.height+_hud.margin*2+adjustment);
					} else {
						targetBounds = CGRectMake(0, 0, captionRect.size.width+_hud.margin*2, captionRect.size.height+_hud.margin*2+adjustment);
					}
				} else {
					if (_image) {
						adjustment = _hud.padding+_image.size.height;
					} else if (_showActivity) {
						adjustment = _hud.padding+_activitySize.height;
					}
					targetBounds = CGRectMake(0, 0, captionRect.size.width+_hud.margin*2, captionRect.size.height+_hud.margin*2+adjustment);
				}
			} else if (_hud.accessoryPosition == ATMHudAccessoryPositionLeft || _hud.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (_image) {
					adjustment = _hud.padding+_image.size.width;
				} else if (_showActivity) {
					adjustment = _hud.padding+_activitySize.height;
				}
				targetBounds = CGRectMake(0, 0, captionRect.size.width+_hud.margin*2+adjustment, captionRect.size.height+_hud.margin*2);
			}
		} else {
			if (_hud.accessoryPosition == ATMHudAccessoryPositionTop || _hud.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (_progress > 0) {
					adjustment = _hud.padding+progressRect.size.height;
					if (captionRect.size.width+_hud.margin*2 < progressRect.size.width) {
						captionRect = [self calcString:_caption sizeForSize:CGSizeMake(progressRect.size.width, 200)];
					}
				} else {
					if (_image) {
						adjustment = _hud.padding+_image.size.height;
					} else if (_showActivity) {
						adjustment = _hud.padding+_activitySize.height;
					}
				}
				
				long deltaWidth = lrintf(targetBounds.size.width - captionRect.size.width);
				marginX = 0.5f*deltaWidth;
				if (marginX < _hud.margin) {
					captionRect = [self calcString:_caption sizeForSize:CGSizeMake(160, 200)];
					targetBounds = CGRectMake(0, 0, captionRect.size.width+2*_hud.margin, targetBounds.size.height);
					marginX = _hud.margin;
				}
				
				long deltaHeight = lrintf(targetBounds.size.height - (adjustment+captionRect.size.height));
				marginY = 0.5f*deltaHeight;
				if (marginY < _hud.margin) {
					targetBounds = CGRectMake(0, 0, targetBounds.size.width, captionRect.size.height+2*_hud.margin+adjustment);
					marginY = _hud.margin;
				}
			} else if (_hud.accessoryPosition == ATMHudAccessoryPositionLeft || _hud.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (_image) {
					adjustment = _hud.padding+_image.size.width;
				} else if (_showActivity) {
					adjustment = _hud.padding+_activitySize.width;
				}
				
				long deltaWidth = lrintf(targetBounds.size.width-(adjustment+captionRect.size.width));
				marginX = 0.5f*deltaWidth;
				if (marginX < _hud.margin) {
					captionRect = [self calcString:_caption sizeForSize:CGSizeMake(160, 200)];
					targetBounds = CGRectMake(0, 0, adjustment+captionRect.size.width+2*_hud.margin, targetBounds.size.height);
					marginX = _hud.margin;
				}
				
				long deltaHeight = lrintf(targetBounds.size.height-captionRect.size.height);
				marginY = 0.5f*deltaHeight;
				if (marginY < _hud.margin) {
					targetBounds = CGRectMake(0, 0, targetBounds.size.width, captionRect.size.height+2*_hud.margin);
					marginY = _hud.margin;
				}
			}
		}
		
		switch (_hud.accessoryPosition) {
		case ATMHudAccessoryPositionTop: {
			activityRect = CGRectMake((targetBounds.size.width-_activitySize.width)*0.5f, marginY, _activitySize.width, _activitySize.height);
			
			imageRect = CGRectZero;
			if (_image)
				imageRect.origin.x = (targetBounds.size.width-_image.size.width)*0.5f;
			else
				imageRect.origin.x = (targetBounds.size.width)*0.5f;
			
			imageRect.origin.y = marginY;
			if (_image && _image.size.width > 0.0f && _image.size.height > 0.0f) {
				imageRect.size = _image.size;
			}				
			progressRect = CGRectMake((targetBounds.size.width-progressRect.size.width)*0.5f, marginY, progressRect.size.width, progressRect.size.height);
			
			captionRect.origin.x = (targetBounds.size.width-captionRect.size.width)*0.5f;
			captionRect.origin.y = adjustment+marginY;
			break;
		}
			
		case ATMHudAccessoryPositionRight: {
			activityRect = CGRectMake(marginX+_hud.padding+captionRect.size.width, (targetBounds.size.height-_activitySize.height)*0.5f, _activitySize.width, _activitySize.height);
			
			imageRect = CGRectZero;
			imageRect.origin.x = marginX+_hud.padding+captionRect.size.width;
			if (_image) {
				imageRect.origin.y = (targetBounds.size.height-_image.size.height)*0.5f;
				imageRect.size = _image.size;
			}
			
			captionRect.origin.x = marginX;
			captionRect.origin.y = marginY;
			break;
		}
			
		case ATMHudAccessoryPositionBottom: {
			activityRect = CGRectMake((targetBounds.size.width-_activitySize.width)*0.5f, captionRect.size.height+marginY+_hud.padding, _activitySize.width, _activitySize.height);
			
			imageRect = CGRectZero;
			if (_image)
				imageRect.origin.x = (targetBounds.size.width-_image.size.width)*0.5f;
			else
				imageRect.origin.x = (targetBounds.size.width)*0.5f;
			imageRect.origin.y = captionRect.size.height+marginY+_hud.padding;
			if (_image)
				imageRect.size = _image.size;
			
			progressRect = CGRectMake((targetBounds.size.width-progressRect.size.width)*0.5f, captionRect.size.height+marginY+_hud.padding, progressRect.size.width, progressRect.size.height);
			
			captionRect.origin.x = (targetBounds.size.width-captionRect.size.width)*0.5f;
			captionRect.origin.y = marginY;
			break;
		}
			
		case ATMHudAccessoryPositionLeft: {
			activityRect = CGRectMake(marginX, (targetBounds.size.height-_activitySize.height)*0.5f, _activitySize.width, _activitySize.height);
			
			imageRect = CGRectZero;
			imageRect.origin.x = marginX;
			if (_image) {
				imageRect.origin.y = (targetBounds.size.height-_image.size.height)*0.5f;
				imageRect.size = _image.size;
			} else {
				imageRect.origin.y = (targetBounds.size.height)*0.5f;
			}
			
			captionRect.origin.x = marginX+adjustment;
			captionRect.origin.y = marginY;
			break;
		}
		}
	}
}

- (CGSize)sizeForActivityStyle:(UIActivityIndicatorViewStyle)style
{
	CGSize size;
	if (style == UIActivityIndicatorViewStyleWhiteLarge) {
		size = CGSizeMake(37, 37);
	} else {
		size = CGSizeMake(20, 20);
	}
	return size;
}

- (CGSize)calculateSizeForQueueItem:(ATMHudQueueItem *)item
{
	CGSize targetSize = CGSizeZero;
	CGSize styleSize = [self sizeForActivityStyle:item.activityStyle];
	if (!item.caption || [item.caption isEqualToString:@""]) {
		targetSize = CGSizeMake(_hud.margin*2+styleSize.width, _hud.margin*2+styleSize.height);
	} else {
		BOOL hasFixedSize = NO;
		captionRect = [self calcString:item.caption sizeForSize:CGSizeMake(160, 200)];
		
		float adjustment = 0;
		CGFloat marginX = 0;
		CGFloat marginY = 0;
		if (!hasFixedSize) {
			if (item.accessoryPosition == ATMHudAccessoryPositionTop || item.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (item.image) {
					adjustment = _hud.padding+item.image.size.height;
				} else if (item.showActivity) {
					adjustment = _hud.padding+styleSize.height;
				}
				targetSize = CGSizeMake(captionRect.size.width+_hud.margin*2, captionRect.size.height+_hud.margin*2+adjustment);
			} else if (item.accessoryPosition == ATMHudAccessoryPositionLeft || item.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (item.image) {
					adjustment = _hud.padding+item.image.size.width;
				} else if (item.showActivity) {
					adjustment = _hud.padding+styleSize.width;
				}
				targetSize = CGSizeMake(captionRect.size.width+_hud.margin*2+adjustment, captionRect.size.height+_hud.margin*2);
			}
		} else {
			if (item.accessoryPosition == ATMHudAccessoryPositionTop || item.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (item.image) {
					adjustment = _hud.padding+item.image.size.height;
				} else if (item.showActivity) {
					adjustment = _hud.padding+styleSize.height;
				}
				
				long deltaWidth = lrintf(targetSize.width-captionRect.size.width);
				marginX = 0.5f*deltaWidth;
				if (marginX < _hud.margin) {
					captionRect = [self calcString:_caption sizeForSize:CGSizeMake(160, 200)];
					targetSize = CGSizeMake(captionRect.size.width+2*_hud.margin, targetSize.height);
				}
				
				long deltaHeight = lrintf(targetSize.height-(adjustment+captionRect.size.height));
				marginY = 0.5f*deltaHeight;
				if (marginY < _hud.margin) {
					targetSize = CGSizeMake(targetSize.width, captionRect.size.height+2*_hud.margin+adjustment);
				}
			} else if (item.accessoryPosition == ATMHudAccessoryPositionLeft || item.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (item.image) {
					adjustment = _hud.padding+item.image.size.width;
				} else if (item.showActivity) {
					adjustment = _hud.padding+styleSize.width;
				}
				
				long deltaWidth = lrintf(targetSize.width-(adjustment+captionRect.size.width));
				marginX = 0.5f*deltaWidth;
				if (marginX < _hud.margin) {
					captionRect = [self calcString:_caption sizeForSize:CGSizeMake(160, 200)];
					targetSize = CGSizeMake(adjustment+captionRect.size.width+2*_hud.margin, targetSize.height);
				}
				
				long deltaHeight = lrintf(targetSize.height-captionRect.size.height);
				marginY = 0.5f*deltaHeight;
				if (marginY < _hud.margin) {
					targetSize = CGSizeMake(targetSize.width, captionRect.size.height+2*_hud.margin);
				}
			}
		}
	}
	return targetSize;
}

- (void)applyWithMode:(ATMHudApplyMode)mode
{
	id delegate = (id)_hud.delegate;
	ATMblockDelegate blockDelegate = _hud.blockDelegate;

	switch (mode) {
	case ATMHudApplyModeShow: {
		// NSLog(@"ATMHud: ATMHudApplyModeShow delegate=%@", delegate);
		if (CGPointEqualToPoint(_hud.center, CGPointZero)) {
			self.frame = CGRectMake((self.superview.bounds.size.width-targetBounds.size.width)*0.5f, (self.superview.bounds.size.height-targetBounds.size.height)*0.5f, targetBounds.size.width, targetBounds.size.height);
		} else {
			self.bounds = CGRectMake(0, 0, targetBounds.size.width, targetBounds.size.height);
			self.center = _hud.center;
		}
		
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		[CATransaction setCompletionBlock:^{
			if (_showActivity) {
				_activity.activityIndicatorViewStyle = _activityStyle;
				_activity.frame = CGRectIntegral(activityRect);
			}
			
			CGRect r = self.frame;
			self.frame = CGRectIntegral(r);
			if ([delegate respondsToSelector:@selector(hudWillAppear:)]) {
				[delegate hudWillAppear:_hud];
			}
			if (blockDelegate) {
				blockDelegate(hudWillAppear, _hud);
			}
			
			self.transform = CGAffineTransformMakeScale(_hud.appearScaleFactor, _hud.appearScaleFactor);

			[UIView animateWithDuration:_hud.animateDuration 
							 animations:^{
								 self.transform = CGAffineTransformMakeScale(1.0, 1.0);
								 self.alpha = 1.0;
							 } 
							 completion:^(BOOL finished){
								// if (finished) Got to do this regardless of whether it finished or not.
								{
									if (!_hud.allowSuperviewInteraction) {
										self.superview.userInteractionEnabled = YES;
									}
#ifdef ATM_SOUND
									if (![_hud.showSound isEqualToString:@""] && _hud.showSound != NULL) {
										[_hud playSound:_hud.showSound];
									}
#endif
									if ([delegate respondsToSelector:@selector(hudDidAppear:)]) {
										[delegate hudDidAppear:_hud];
									}
									if (blockDelegate) {
										blockDelegate(hudDidAppear, _hud);
									}
								}
							 }];
		}];
		
		_backgroundLayer.position = CGPointMake(0.5f*targetBounds.size.width, 0.5f*targetBounds.size.height);
		_backgroundLayer.bounds = targetBounds;
		
		captionLayer.position = [self integralPoint:CGPointMake(captionRect.origin.x, captionRect.origin.y)];
		captionLayer.bounds = CGRectMake(0, 0, captionRect.size.width, captionRect.size.height);
		CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"caption"];
		cAnimation.duration = 0.001;
		cAnimation.toValue = _caption;
		[captionLayer addAnimation:cAnimation forKey:@"captionAnimation"];
		captionLayer.caption = _caption;
		imageLayer.contents = (id)_image.CGImage;
		imageLayer.position = [self integralPoint:CGPointMake(imageRect.origin.x, imageRect.origin.y)];
		imageLayer.bounds = CGRectMake(0, 0, imageRect.size.width, imageRect.size.height);
		
		progressLayer.position = [self integralPoint:CGPointMake(progressRect.origin.x, progressRect.origin.y)];
		progressLayer.bounds = CGRectMake(0, 0, progressRect.size.width, progressRect.size.height);
		progressLayer.progressBorderRadius = _hud.progressBorderRadius;
		progressLayer.progressBorderWidth = _hud.progressBorderWidth;
		progressLayer.progressBarRadius = _hud.progressBarRadius;
		progressLayer.progressBarInset = _hud.progressBarInset;
		progressLayer.theProgress = _progress;
		[progressLayer setNeedsDisplay];
		
		[CATransaction commit];
		break;
	}
		
	case ATMHudApplyModeUpdate: {
		// NSLog(@"ATMHud: ATMHudApplyModeUpdate delegate=%@", delegate);
		if ([delegate respondsToSelector:@selector(hudWillUpdate:)]) {
			[delegate hudWillUpdate:_hud];
		}
		if (blockDelegate) {
			blockDelegate(hudWillUpdate, _hud);
		}
		
		if (CGPointEqualToPoint(_hud.center, CGPointZero)) {
			self.frame = CGRectMake((self.superview.bounds.size.width-targetBounds.size.width)*0.5f, (self.superview.bounds.size.height-targetBounds.size.height)*0.5f, targetBounds.size.width, targetBounds.size.height);
		} else {
			self.bounds = CGRectMake(0, 0, targetBounds.size.width, targetBounds.size.height);
			self.center = _hud.center;
		}
		
		CABasicAnimation *ccAnimation = [CABasicAnimation animationWithKeyPath:@"caption"];
		ccAnimation.duration = 0.001;
		ccAnimation.toValue = @"";
		ccAnimation.delegate = self;
		[captionLayer addAnimation:ccAnimation forKey:@"captionClearAnimation"];
		captionLayer.caption = @"";
		
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		[CATransaction setCompletionBlock:^{
			_backgroundLayer.bounds = targetBounds;
			
			progressLayer.theProgress = _progress;
			[progressLayer setNeedsDisplay];
			
			CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"caption"];
			cAnimation.duration = 0.001;
			cAnimation.toValue = _caption;
			[captionLayer addAnimation:cAnimation forKey:@"captionAnimation"];
			captionLayer.caption = _caption;
			
			if (_showActivity) {
				_activity.activityIndicatorViewStyle = _activityStyle;
				_activity.frame = CGRectIntegral(activityRect);
			}
			
			CGRect r = self.frame;
			[self setFrame:CGRectIntegral(r)];
#ifdef ATM_SOUND				
			if (![_hud.updateSound isEqualToString:@""] && _hud.updateSound != NULL) {
				[_hud playSound:_hud.updateSound];
			}
#endif
			if ([delegate respondsToSelector:@selector(hudDidUpdate:)]) {
				[delegate hudDidUpdate:_hud];
			}
			if (blockDelegate) {
				blockDelegate(hudDidUpdate, _hud);
			}
		}];
		
		_backgroundLayer.position = CGPointMake(0.5f*targetBounds.size.width, 0.5f*targetBounds.size.height);
		imageLayer.position = [self integralPoint:CGPointMake(imageRect.origin.x, imageRect.origin.y)];
		progressLayer.position = [self integralPoint:CGPointMake(progressRect.origin.x, progressRect.origin.y)];
		
		imageLayer.bounds = CGRectMake(0, 0, imageRect.size.width, imageRect.size.height);
		progressLayer.bounds = CGRectMake(0, 0, progressRect.size.width, progressRect.size.height);
		
		progressLayer.progressBorderRadius = _hud.progressBorderRadius;
		progressLayer.progressBorderWidth = _hud.progressBorderWidth;
		progressLayer.progressBarRadius = _hud.progressBarRadius;
		progressLayer.progressBarInset = _hud.progressBarInset;
		
		captionLayer.position = [self integralPoint:CGPointMake(captionRect.origin.x, captionRect.origin.y)];
		captionLayer.bounds = CGRectMake(0, 0, captionRect.size.width, captionRect.size.height);
		
		imageLayer.contents = (id)_image.CGImage;
		[CATransaction commit];
		break;
	}
		
	case ATMHudApplyModeHide: {
		// NSLog(@"ATMHud: ATMHudApplyModeHide delegate=%@", delegate);
		if ([delegate respondsToSelector:@selector(hudWillDisappear:)]) {
			[delegate hudWillDisappear:_hud];
		}
		if (blockDelegate) {
			blockDelegate(hudWillDisappear, _hud);
		}
#ifdef ATM_SOUND
		if (![_hud.hideSound isEqualToString:@""] && _hud.hideSound != NULL) {
			[_hud playSound:_hud.hideSound];
		}
#endif
		//NSLog(@"GOT TO ATMHudApplyModeHide duration=%f delegate=%x _hud=%x", _hud.animateDuration, (unsigned int)delegate, (unsigned int)_hud);

		__weak ATMHudView *weakSelf = self;
		[UIView animateWithDuration:_hud.animateDuration
						animations:^{
							self.alpha = 0.0;
							self.transform = CGAffineTransformMakeScale(_hud.disappearScaleFactor, _hud.disappearScaleFactor);
						} 
						completion:^(BOOL finished){
							 // if (finished) Got to do this regardless of whether it finished or not.
							{
								weakSelf.superview.userInteractionEnabled = NO;
								weakSelf.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
#define NO_CRASH
								[weakSelf reset];
#ifdef NO_CRASH
								[weakSelf.hud.view removeFromSuperview];
#else
								dispatch_async(dispatch_get_main_queue(), ^
									{
										[weakSelf.hud.view removeFromSuperview];
									} );
#endif
								if ([delegate respondsToSelector:@selector(hudDidDisappear:)]) {
									[delegate hudDidDisappear:weakSelf.hud];
								} 
								if (blockDelegate) {
									blockDelegate(hudDidDisappear, weakSelf.hud);
								}
							}
						 }];
		break;
	}
	}
}

- (void)show
{
	if (didHide) {
		//NSLog(@"ATMHUD SHOW!!!");
		didHide = NO;
		[self calculate];
		[self applyWithMode:ATMHudApplyModeShow];
	} else {
		//NSLog(@"ATMHUD Asked to show, but already showing!!!");
	}
}

- (void)hide
{
	if (!didHide) {
		didHide = YES;	// multiple calls to hide wrecks havoc, might get called in a cleanup routine in user code just to be sure.
		//NSLog(@"ATMHUD HIDE!!!");
		[self applyWithMode:ATMHudApplyModeHide];
	} else {
		//NSLog(@"ATMHUD Asked to hide, but already hidden!!!");
	}
}

- (void)update
{
	[self calculate];
	[self applyWithMode:ATMHudApplyModeUpdate];
}

- (void)reset
{
	ATMHud *hud = _hud;
	if(!hud) return;
	
assert([NSThread isMainThread]);

	[hud setCaption:@""];
	[hud setImage:nil];
	[hud setProgress:0];
	[hud setActivity:NO];
	[hud setActivityStyle:UIActivityIndicatorViewStyleWhite];
	[hud setAccessoryPosition:ATMHudAccessoryPositionBottom];
	[hud setBlockTouches:NO];
	[hud setAllowSuperviewInteraction:NO];
	[hud setFixedSize:CGSizeZero];
	[hud setCenter:CGPointZero];
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	imageLayer.contents = nil;
	[CATransaction commit];
	
	CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"caption"];
	cAnimation.duration = 0.001;
	cAnimation.toValue = @"";
	[captionLayer addAnimation:cAnimation forKey:@"captionAnimation"];
	captionLayer.caption = @"";

#ifdef ATM_SOUND
	[hud setShowSound:@""];
	[hud setUpdateSound:@""];
	[hud setHideSound:@""];
#endif
}

#pragma mark -

// Issue #21 - provided by paweldudek 
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
