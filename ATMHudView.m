/*
 *  ATMHudView.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import "ATMHudView.h"
#import "ATMTextLayer.h"
#import "ATMProgressLayer.h"
#import "ATMHud.h"
#import <QuartzCore/QuartzCore.h>
#import "ATMHudDelegate.h"
#import "ATMHudQueueItem.h"


@implementation ATMHudView
@synthesize caption, image, activity, activityStyle, p;
@synthesize showActivity;
@synthesize progress;
@synthesize targetBounds, captionRect, progressRect, activityRect, imageRect;
@synthesize fixedSize, activitySize;
@synthesize backgroundLayer, imageLayer, captionLayer, progressLayer;

- (CGRect)sharpRect:(CGRect)rect {
	CGRect r = rect;
	r.origin.x = (int)r.origin.x;
	r.origin.y = (int)r.origin.y;
	return r;
}

- (CGPoint)sharpPoint:(CGPoint)point {
	CGPoint _p = point;
	_p.x = (int)_p.x;
	_p.y = (int)_p.y;
	return _p;
}

- (id)initWithFrame:(CGRect)frame andController:(ATMHud *)c {
    if ((self = [super initWithFrame:frame])) {
		self.p = c;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.alpha = 0.0;
		
		backgroundLayer = [[CALayer alloc] init];
		backgroundLayer.cornerRadius = 10;
		backgroundLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:p.alpha].CGColor;
		[self.layer addSublayer:backgroundLayer];
		
		captionLayer = [[ATMTextLayer alloc] init];
		captionLayer.contentsScale = [[UIScreen mainScreen] scale];
		captionLayer.anchorPoint = CGPointMake(0, 0);
		[self.layer addSublayer:captionLayer];
		
		imageLayer = [[CALayer alloc] init];
		imageLayer.anchorPoint = CGPointMake(0, 0);
		[self.layer addSublayer:imageLayer];
		
		progressLayer = [[ATMProgressLayer alloc] init];
		progressLayer.contentsScale = [[UIScreen mainScreen] scale];
		progressLayer.anchorPoint = CGPointMake(0, 0);
		[self.layer addSublayer:progressLayer];
		
		activity = [[UIActivityIndicatorView alloc] init];
		activity.hidesWhenStopped = YES;
		[self addSubview:activity];
		
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowRadius = 8.0;
		self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
		self.layer.shadowOpacity = 0.4;
		
		progressRect = CGRectMake(0, 0, 210, 20);
		activityStyle = UIActivityIndicatorViewStyleWhite;
		activitySize = CGSizeMake(20, 20);
    }
    return self;
}

- (void)dealloc {
	[caption release];
	[image release];
	[activity release];
	[p release];
	
	[backgroundLayer release];
	[imageLayer release];
	[captionLayer release];
	[progressLayer release];
	
    [super dealloc];
}

- (void)setProgress:(CGFloat)_p {
	_p = MIN(MAX(0,_p),1);
	
	if (_p > 0 && _p < 0.08) _p = 0.08;
	if(_p == progress) return;
	progress = _p;
}

- (void)calculate {
	if (!caption || [caption isEqualToString:@""]) {
		activityRect = CGRectMake(p.margin, p.margin, activitySize.width, activitySize.height);
		targetBounds = CGRectMake(0, 0, p.margin*2+activitySize.width, p.margin*2+activitySize.height);
	} else {
		BOOL hasFixedSize = NO;
		CGSize captionSize = [caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:UILineBreakModeWordWrap];
		
		if (fixedSize.width > 0 & fixedSize.height > 0) {
			CGSize s = fixedSize;
			if (progress > 0 && (fixedSize.width < progressRect.size.width+p.margin*2)) {
				s.width = progressRect.size.width+p.margin*2;
			}
			hasFixedSize = YES;
			captionSize = [caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(s.width-p.margin*2, 200) lineBreakMode:UILineBreakModeWordWrap];
			targetBounds = CGRectMake(0, 0, s.width, s.height);
		}
		
		captionRect = CGRectZero;
		captionRect.size = captionSize;
		float adjustment = 0;
		CGFloat marginX = p.margin;
		CGFloat marginY = p.margin;
		if (!hasFixedSize) {
			if (p.accessoryPosition == ATMHudAccessoryPositionTop || p.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (progress > 0) {
					adjustment = p.padding+progressRect.size.height;
					if (captionSize.width+p.margin*2 < progressRect.size.width) {
						captionSize = [caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(progressRect.size.width, 200) lineBreakMode:UILineBreakModeWordWrap];
						captionRect.size = captionSize;
						targetBounds = CGRectMake(0, 0, progressRect.size.width+p.margin*2, captionSize.height+p.margin*2+adjustment);
					} else {
						targetBounds = CGRectMake(0, 0, captionSize.width+p.margin*2, captionSize.height+p.margin*2+adjustment);
					}
				} else {
					if (image) {
						adjustment = p.padding+image.size.height;
					} else if (showActivity) {
						adjustment = p.padding+activitySize.height;
					}
					targetBounds = CGRectMake(0, 0, captionSize.width+p.margin*2, captionSize.height+p.margin*2+adjustment);
				}
			} else if (p.accessoryPosition == ATMHudAccessoryPositionLeft || p.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (image) {
					adjustment = p.padding+image.size.width;
				} else if (showActivity) {
					adjustment = p.padding+activitySize.height;
				}
				targetBounds = CGRectMake(0, 0, captionSize.width+p.margin*2+adjustment, captionSize.height+p.margin*2);
			}
		} else {
			if (p.accessoryPosition == ATMHudAccessoryPositionTop || p.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (progress > 0) {
					adjustment = p.padding+progressRect.size.height;
					if (captionSize.width+p.margin*2 < progressRect.size.width) {
						captionSize = [caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(progressRect.size.width, 200) lineBreakMode:UILineBreakModeWordWrap];
						captionRect.size = captionSize;
					}
				} else {
					if (image) {
						adjustment = p.padding+image.size.height;
					} else if (showActivity) {
						adjustment = p.padding+activitySize.height;
					}
				}
				
				int deltaWidth = targetBounds.size.width-captionSize.width;
				marginX = 0.5*deltaWidth;
				if (marginX < p.margin) {
					captionSize = [caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:UILineBreakModeWordWrap];
					captionRect.size = captionSize;
					
					targetBounds = CGRectMake(0, 0, captionSize.width+2*p.margin, targetBounds.size.height);
					marginX = p.margin;
				}
				
				int deltaHeight = targetBounds.size.height-(adjustment+captionSize.height);
				marginY = 0.5*deltaHeight;
				if (marginY < p.margin) {
					targetBounds = CGRectMake(0, 0, targetBounds.size.width, captionSize.height+2*p.margin+adjustment);
					marginY = p.margin;
				}
			} else if (p.accessoryPosition == ATMHudAccessoryPositionLeft || p.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (image) {
					adjustment = p.padding+image.size.width;
				} else if (showActivity) {
					adjustment = p.padding+activitySize.width;
				}
				
				int deltaWidth = targetBounds.size.width-(adjustment+captionSize.width);
				marginX = 0.5*deltaWidth;
				if (marginX < p.margin) {
					captionSize = [caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:UILineBreakModeWordWrap];
					captionRect.size = captionSize;
					
					targetBounds = CGRectMake(0, 0, adjustment+captionSize.width+2*p.margin, targetBounds.size.height);
					marginX = p.margin;
				}
				
				int deltaHeight = targetBounds.size.height-captionSize.height;
				marginY = 0.5*deltaHeight;
				if (marginY < p.margin) {
					targetBounds = CGRectMake(0, 0, targetBounds.size.width, captionSize.height+2*p.margin);
					marginY = p.margin;
				}
			}
		}
		
		switch (p.accessoryPosition) {
			case ATMHudAccessoryPositionTop: {
				activityRect = CGRectMake((targetBounds.size.width-activitySize.width)*0.5, marginY, activitySize.width, activitySize.height);
				
				imageRect = CGRectZero;
				imageRect.origin.x = (targetBounds.size.width-image.size.width)*0.5;
				imageRect.origin.y = marginY;
				imageRect.size = image.size;
				
				progressRect = CGRectMake((targetBounds.size.width-progressRect.size.width)*0.5, marginY, progressRect.size.width, progressRect.size.height);
				
				captionRect.origin.x = (targetBounds.size.width-captionSize.width)*0.5;
				captionRect.origin.y = adjustment+marginY;
				break;
			}
				
			case ATMHudAccessoryPositionRight: {
				activityRect = CGRectMake(marginX+p.padding+captionSize.width, (targetBounds.size.height-activitySize.height)*0.5, activitySize.width, activitySize.height);
				
				imageRect = CGRectZero;
				imageRect.origin.x = marginX+p.padding+captionSize.width;
				imageRect.origin.y = (targetBounds.size.height-image.size.height)*0.5;
				imageRect.size = image.size;
				
				captionRect.origin.x = marginX;
				captionRect.origin.y = marginY;
				break;
			}
				
			case ATMHudAccessoryPositionBottom: {
				activityRect = CGRectMake((targetBounds.size.width-activitySize.width)*0.5, captionRect.size.height+marginY+p.padding, activitySize.width, activitySize.height);
				
				imageRect = CGRectZero;
				imageRect.origin.x = (targetBounds.size.width-image.size.width)*0.5;
				imageRect.origin.y = captionRect.size.height+marginY+p.padding;
				imageRect.size = image.size;
				
				progressRect = CGRectMake((targetBounds.size.width-progressRect.size.width)*0.5, captionRect.size.height+marginY+p.padding, progressRect.size.width, progressRect.size.height);
				
				captionRect.origin.x = (targetBounds.size.width-captionSize.width)*0.5;
				captionRect.origin.y = marginY;
				break;
			}
				
			case ATMHudAccessoryPositionLeft: {
				activityRect = CGRectMake(marginX, (targetBounds.size.height-activitySize.height)*0.5, activitySize.width, activitySize.height);
				
				imageRect = CGRectZero;
				imageRect.origin.x = marginX;
				imageRect.origin.y = (targetBounds.size.height-image.size.height)*0.5;
				imageRect.size = image.size;
				
				captionRect.origin.x = marginX+adjustment;
				captionRect.origin.y = marginY;
				break;
			}
		}
	}
}

- (CGSize)sizeForActivityStyle:(UIActivityIndicatorViewStyle)style {
	if (style == UIActivityIndicatorViewStyleWhiteLarge) {
		return CGSizeMake(37, 37);
	} else {
		return CGSizeMake(20, 20);
	}
}

- (CGSize)calculateSizeForQueueItem:(ATMHudQueueItem *)item {
	CGSize targetSize = CGSizeZero;
	CGSize styleSize = [self sizeForActivityStyle:item.activityStyle];
	if (!item.caption || [item.caption isEqualToString:@""]) {
		targetSize = CGSizeMake(p.margin*2+styleSize.width, p.margin*2+styleSize.height);
	} else {
		BOOL hasFixedSize = NO;
		CGSize captionSize = [item.caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:UILineBreakModeWordWrap];
		
		float adjustment = 0;
		CGFloat marginX = 0;
		CGFloat marginY = 0;
		if (!hasFixedSize) {
			if (item.accessoryPosition == ATMHudAccessoryPositionTop || item.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (item.image) {
					adjustment = p.padding+item.image.size.height;
				} else if (item.showActivity) {
					adjustment = p.padding+styleSize.height;
				}
				targetSize = CGSizeMake(captionSize.width+p.margin*2, captionSize.height+p.margin*2+adjustment);
			} else if (item.accessoryPosition == ATMHudAccessoryPositionLeft || item.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (item.image) {
					adjustment = p.padding+item.image.size.width;
				} else if (item.showActivity) {
					adjustment = p.padding+styleSize.width;
				}
				targetSize = CGSizeMake(captionSize.width+p.margin*2+adjustment, captionSize.height+p.margin*2);
			}
		} else {
			if (item.accessoryPosition == ATMHudAccessoryPositionTop || item.accessoryPosition == ATMHudAccessoryPositionBottom) {
				if (item.image) {
					adjustment = p.padding+item.image.size.height;
				} else if (item.showActivity) {
					adjustment = p.padding+styleSize.height;
				}
				
				int deltaWidth = targetSize.width-captionSize.width;
				marginX = 0.5*deltaWidth;
				if (marginX < p.margin) {
					captionSize = [item.caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:UILineBreakModeWordWrap];
					
					targetSize = CGSizeMake(captionSize.width+2*p.margin, targetSize.height);
				}
				
				int deltaHeight = targetSize.height-(adjustment+captionSize.height);
				marginY = 0.5*deltaHeight;
				if (marginY < p.margin) {
					targetSize = CGSizeMake(targetSize.width, captionSize.height+2*p.margin+adjustment);
				}
			} else if (item.accessoryPosition == ATMHudAccessoryPositionLeft || item.accessoryPosition == ATMHudAccessoryPositionRight) {
				if (item.image) {
					adjustment = p.padding+item.image.size.width;
				} else if (item.showActivity) {
					adjustment = p.padding+styleSize.width;
				}
				
				int deltaWidth = targetSize.width-(adjustment+captionSize.width);
				marginX = 0.5*deltaWidth;
				if (marginX < p.margin) {
					captionSize = [item.caption sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(160, 200) lineBreakMode:UILineBreakModeWordWrap];
					
					targetSize = CGSizeMake(adjustment+captionSize.width+2*p.margin, targetSize.height);
				}
				
				int deltaHeight = targetSize.height-captionSize.height;
				marginY = 0.5*deltaHeight;
				if (marginY < p.margin) {
					targetSize = CGSizeMake(targetSize.width, captionSize.height+2*p.margin);
				}
			}
		}
	}
	return targetSize;
}

- (void)applyWithMode:(ATMHudApplyMode)mode {
	switch (mode) {
		case ATMHudApplyModeShow: {
			if (CGPointEqualToPoint(p.center, CGPointZero)) {
				self.frame = CGRectMake((self.superview.bounds.size.width-targetBounds.size.width)*0.5, (self.superview.bounds.size.height-targetBounds.size.height)*0.5, targetBounds.size.width, targetBounds.size.height);
			} else {
				self.bounds = CGRectMake(0, 0, targetBounds.size.width, targetBounds.size.height);
				self.center = p.center;
			}
			
			[CATransaction begin];
			[CATransaction setDisableActions:YES];
			[CATransaction setCompletionBlock:^{
				if (showActivity) {
					activity.activityIndicatorViewStyle = activityStyle;
					activity.frame = [self sharpRect:activityRect];
				}
				
				CGRect r = self.frame;
				[self setFrame:[self sharpRect:r]];
				
				if ([(id)p.delegate respondsToSelector:@selector(hudWillAppear:)]) {
					[p.delegate hudWillAppear:p];
				}
				
				self.transform = CGAffineTransformMakeScale(p.appearScaleFactor, p.appearScaleFactor);

				[UIView animateWithDuration:.1 
								 animations:^{
									 self.transform = CGAffineTransformMakeScale(1.0, 1.0);
									 self.alpha = 1.0;
								 } 
								 completion:^(BOOL finished){
									if (finished) {
										if (!p.allowSuperviewInteraction) {
											self.superview.userInteractionEnabled = YES;
										}
										if (![p.showSound isEqualToString:@""] && p.showSound != NULL) {
											[p playSound:p.showSound];
										}
										if ([(id)p.delegate respondsToSelector:@selector(hudDidAppear:)]) {
											[p.delegate hudDidAppear:p];
										}
									} 
								 }];
			}];
			
			backgroundLayer.position = CGPointMake(0.5*targetBounds.size.width, 0.5*targetBounds.size.height);
			backgroundLayer.bounds = targetBounds;
			
			captionLayer.position = [self sharpPoint:CGPointMake(captionRect.origin.x, captionRect.origin.y)];
			captionLayer.bounds = CGRectMake(0, 0, captionRect.size.width, captionRect.size.height);
			CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"caption"];
			cAnimation.duration = 0.001;
			cAnimation.toValue = caption;
			[captionLayer addAnimation:cAnimation forKey:@"captionAnimation"];
			captionLayer.caption = caption;
			
			imageLayer.contents = (id)image.CGImage;
			imageLayer.position = [self sharpPoint:CGPointMake(imageRect.origin.x, imageRect.origin.y)];
			imageLayer.bounds = CGRectMake(0, 0, imageRect.size.width, imageRect.size.height);
			
			progressLayer.position = [self sharpPoint:CGPointMake(progressRect.origin.x, progressRect.origin.y)];
			progressLayer.bounds = CGRectMake(0, 0, progressRect.size.width, progressRect.size.height);
			progressLayer.progressBorderRadius = p.progressBorderRadius;
			progressLayer.progressBorderWidth = p.progressBorderWidth;
			progressLayer.progressBarRadius = p.progressBarRadius;
			progressLayer.progressBarInset = p.progressBarInset;
			progressLayer.theProgress = progress;
			[progressLayer setNeedsDisplay];
			
			[CATransaction commit];
			break;
		}
			
		case ATMHudApplyModeUpdate: {
			if ([(id)p.delegate respondsToSelector:@selector(hudWillUpdate:)]) {
				[p.delegate hudWillUpdate:p];
			}
			
			if (CGPointEqualToPoint(p.center, CGPointZero)) {
				self.frame = CGRectMake((self.superview.bounds.size.width-targetBounds.size.width)*0.5, (self.superview.bounds.size.height-targetBounds.size.height)*0.5, targetBounds.size.width, targetBounds.size.height);
			} else {
				self.bounds = CGRectMake(0, 0, targetBounds.size.width, targetBounds.size.height);
				self.center = p.center;
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
				backgroundLayer.bounds = targetBounds;
				
				progressLayer.theProgress = progress;
				[progressLayer setNeedsDisplay];
				
				CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"caption"];
				cAnimation.duration = 0.001;
				cAnimation.toValue = caption;
				[captionLayer addAnimation:cAnimation forKey:@"captionAnimation"];
				captionLayer.caption = caption;
				
				if (showActivity) {
					activity.activityIndicatorViewStyle = activityStyle;
					activity.frame = [self sharpRect:activityRect];
				}
				
				CGRect r = self.frame;
				[self setFrame:[self sharpRect:r]];
				
				if (![p.updateSound isEqualToString:@""] && p.updateSound != NULL) {
					[p playSound:p.updateSound];
				}
				if ([(id)p.delegate respondsToSelector:@selector(hudDidUpdate:)]) {
					[p.delegate hudDidUpdate:p];
				}
			}];
			
			backgroundLayer.position = CGPointMake(0.5*targetBounds.size.width, 0.5*targetBounds.size.height);
			imageLayer.position = [self sharpPoint:CGPointMake(imageRect.origin.x, imageRect.origin.y)];
			progressLayer.position = [self sharpPoint:CGPointMake(progressRect.origin.x, progressRect.origin.y)];
			
			imageLayer.bounds = CGRectMake(0, 0, imageRect.size.width, imageRect.size.height);
			progressLayer.bounds = CGRectMake(0, 0, progressRect.size.width, progressRect.size.height);
			
			progressLayer.progressBorderRadius = p.progressBorderRadius;
			progressLayer.progressBorderWidth = p.progressBorderWidth;
			progressLayer.progressBarRadius = p.progressBarRadius;
			progressLayer.progressBarInset = p.progressBarInset;
			
			captionLayer.position = [self sharpPoint:CGPointMake(captionRect.origin.x, captionRect.origin.y)];
			captionLayer.bounds = CGRectMake(0, 0, captionRect.size.width, captionRect.size.height);
			
			imageLayer.contents = (id)image.CGImage;
			[CATransaction commit];
			break;
		}
			
		case ATMHudApplyModeHide: {
			if ([(id)p.delegate respondsToSelector:@selector(hudWillDisappear:)]) {
				[p.delegate hudWillDisappear:p];
			}
			if (![p.hideSound isEqualToString:@""] && p.hideSound != NULL) {
				[p playSound:p.hideSound];
			}
			
			[UIView animateWithDuration:.1 
							 animations:^{ 
								 self.alpha = 0.0;
								 self.transform = CGAffineTransformMakeScale(p.disappearScaleFactor, p.disappearScaleFactor);
							 } 
							 completion:^(BOOL finished){
								 if (finished) {
									 self.superview.userInteractionEnabled = NO;
									 self.transform = CGAffineTransformMakeScale(1.0, 1.0);
									 [self reset];
									 if ([(id)p.delegate respondsToSelector:@selector(hudDidDisappear:)]) {
										 [p.delegate hudDidDisappear:p];
									 } 
								 }
							 }];
			break;
		}
	}
}

- (void)show {
	[self calculate];
	[self applyWithMode:ATMHudApplyModeShow];
}

- (void)hide {
	[self applyWithMode:ATMHudApplyModeHide];
}

- (void)update {
	[self calculate];
	[self applyWithMode:ATMHudApplyModeUpdate];
}

- (void)reset {
	[p setCaption:@""];
	[p setImage:nil];
	[p setProgress:0];
	[p setActivity:NO];
	[p setActivityStyle:UIActivityIndicatorViewStyleWhite];
	[p setAccessoryPosition:ATMHudAccessoryPositionBottom];
	[p setBlockTouches:NO];
	[p setAllowSuperviewInteraction:NO];
	// TODO: Reset or not reset, that is the question.
	[p setFixedSize:CGSizeZero];
	[p setCenter:CGPointZero];
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	imageLayer.contents = nil;
	[CATransaction commit];
	
	CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"caption"];
	cAnimation.duration = 0.001;
	cAnimation.toValue = @"";
	[captionLayer addAnimation:cAnimation forKey:@"captionAnimation"];
	captionLayer.caption = @"";
	
	[p setShowSound:@""];
	[p setUpdateSound:@""];
	[p setHideSound:@""];
}

@end
