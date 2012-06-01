//
//  ATMHudBlock.m
//  ATMHud
//
//  Created by Constantine on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ATMHudBlock.h"

@interface ATMHudCallback ()
@property (readwrite, nonatomic, copy) id tapBlock;
@property (readwrite, nonatomic, copy) id willAppearBlock;
@property (readwrite, nonatomic, copy) id didAppearBlock;
@property (readwrite, nonatomic, copy) id willUpdateBlock;
@property (readwrite, nonatomic, copy) id didUpdateBlock;
@property (readwrite, nonatomic, copy) id willDisappearBlock;
@property (readwrite, nonatomic, copy) id didDisappearBlock;
@end

@implementation ATMHudCallback
@synthesize tapBlock = _tapBlock;
@synthesize willAppearBlock = _willAppearBlock;
@synthesize didAppearBlock = _didAppearBlock;
@synthesize willUpdateBlock = _willUpdateBlock;
@synthesize didUpdateBlock = _didUpdateBlock;
@synthesize willDisappearBlock = _willDisappearBlock;
@synthesize didDisappearBlock = _didDisappearBlock;

+ (id)blockWithUserDidTapHud:(id)tapBlock willAppear:(id)willAppearBlock didAppear:(id)didAppearBlock willUpdate:(id)willUpdateBlock didUpdate:(id)didUpdateBlock willDisappear:(id)willDisappearBlock didDisappear:(id)didDisappearBlock {
	id callback = [[[self alloc] init] autorelease];
	[callback setTapBlock:tapBlock];
	[callback setWillAppearBlock:willAppearBlock];
	[callback setDidAppearBlock:didAppearBlock];
	[callback setWillUpdateBlock:willUpdateBlock];
	[callback setDidUpdateBlock:didUpdateBlock];
	[callback setWillDisappearBlock:willDisappearBlock];
	[callback setDidDisappearBlock:didDisappearBlock];
	
	return callback;
}

- (id)init {
	if ([self class] == [ATMHudCallback class]) {
		[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
	}
	
	return [super init];
}

- (void)dealloc {
	[_tapBlock release];
	[_willAppearBlock release];
	[_didAppearBlock release];
	[_willUpdateBlock release];
	[_didUpdateBlock release];
	[_willDisappearBlock release];
	[_didDisappearBlock release];
	[super dealloc];
}

@end

@implementation ATMHudBlock
@dynamic tapBlock, willAppearBlock, didAppearBlock, willUpdateBlock, didUpdateBlock, willDisappearBlock, didDisappearBlock;
@end
