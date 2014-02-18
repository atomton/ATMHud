/*
 *  ATMTextLayer.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import "ATMTextLayer.h"

//#define DROP_SHADOW

@implementation ATMTextLayer

+ (BOOL)needsDisplayForKey:(NSString *)key
{
	if ([key isEqualToString:@"caption"]) {
		return YES;
	} else {
		return [super needsDisplayForKey:key];
	}
}

- (instancetype)initWithLayer:(id)layer
{
	if ((self = [super init])) {
		self.caption = @"";
	}
	return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
	UIGraphicsPushContext(ctx);	// Makes this contest the current context
	CGRect f = self.bounds;
#ifdef DROP_SHADOW
	CGRect s = f;
#endif
	f.origin.y -= 1;	// seems weird, but the text looks a bit better being just a pixel higher! This is how the original code worked.

	UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
	NSMutableParagraphStyle *paragraphStyle	= [NSMutableParagraphStyle new];
	paragraphStyle.lineBreakMode			= NSLineBreakByWordWrapping;
	paragraphStyle.alignment				= NSTextAlignmentCenter;

#ifdef DROP_SHADOW
	[_caption drawInRect:s withAttributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blackColor]}];
#endif
	[_caption drawInRect:f withAttributes:@{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
	UIGraphicsPopContext();
}

@end
