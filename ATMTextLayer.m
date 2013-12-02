/*
 *  ATMTextLayer.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import "ATMTextLayer.h"

@implementation ATMTextLayer

- (id)initWithLayer:(id)layer {
	if ((self = [super init])) {
		_caption = @"";
	}
	return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
	if ([key isEqualToString:@"caption"]) {
		return YES;
	} else {
		return [super needsDisplayForKey:key];
	}
}

- (void)drawInContext:(CGContextRef)ctx {
	UIGraphicsPushContext(ctx);	// Makes this contest the current context
	
	CGRect f = self.bounds;
	CGRect s = f;
	s.origin.y -= 1;

	UIFont *font = [UIFont boldSystemFontOfSize:14];
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.lineBreakMode	= NSLineBreakByWordWrapping;
	paragraphStyle.alignment		= NSTextAlignmentCenter;
	
	[_caption drawInRect:f withAttributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blackColor]}];
	[_caption drawInRect:s withAttributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
	UIGraphicsPopContext();
}


@end
