/*
 *  DemoViewController.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	This sample project uses the sound
 *		Hard pop.wav http://www.freesound.org/samplesViewSingle.php?id=108616
 *	by
 *		juskiddink http://www.freesound.org/usersViewSingle.php?id=649468
 *	licensed under
 *		Creative Commons Sampling Plus 1.0 License http://creativecommons.org/licenses/sampling+/1.0/
 *
 *	The two icons "11-x.png" and "19-check.png" are taken from the Glyphish icon set,
 *	with kind permission of Joseph Wain.
 *	You can get them here: http://glyphish.com/
 *
 *	https://github.com/atomton/ATMHud (original)
 */

#import "DemoViewController.h"
#import "ATMHud.h"
#import "ATMHudQueueItem.h"

#pragma mark -
#pragma mark Private interface

@interface DemoViewController () 
- (void)basicHudActionForRow:(NSUInteger)row;
- (void)advancedHudActionForRow:(NSUInteger)row;
- (void)positioningActionForRow:(NSUInteger)row;
@end

@implementation DemoViewController
{
	UITableView			*tv_demo;
	ATMHud				*hud;				// never released
	ATMHud				*hud2;				// always released
	
	NSArray				*sectionHeaders;
	NSArray				*sectionFooters;
	NSArray				*cellCaptions;
	
	BOOL useFixedSize;
}

//@synthesize hud, useFixedSize;
//@synthesize sectionHeaders, sectionFooters, cellCaptions;

#pragma mark -
#pragma mark View lifecycle

- (id)init
{
	if ((self = [super init])) {
		NSArray *section0 = @[@"Show with caption only", @"Show with caption and activity", @"Show with caption and image", @"Show activity only",
#ifdef ATM_SOUND
		@"Play sound on show",
#endif
		];
		NSArray *section1 = @[@"Show and auto-hide", @"Show, update and auto-hide", @"Show progress bar", @"Show queued HUD"];
		NSArray *section2 = @[@"Accessory top", @"Accessory right", @"Accessory bottom", @"Accessory left"];
		NSArray *section3 = @[@"Alloc/Release & BlockDel."];
		NSArray *section4 = @[@"Use fixed size"];
		
		sectionHeaders	= @[@"Basic functions", @"Advanced functions", @"Accessory positioning", @"Instantiated and Released", @""];
		sectionFooters	= @[@"Tap the HUD to hide it.", @"Tap to hide is disabled.", @"", @"Tap the HUD to hide it.", [ATMHud version]];
		cellCaptions	= @[section0, section1, section2, section3, section4];
	}
	return self;
}

- (void)loadView
{
	UIView *baseView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	tv_demo = [[UITableView alloc] initWithFrame:baseView.bounds style:UITableViewStyleGrouped];
	tv_demo.delegate = self;
	tv_demo.dataSource = self;
	tv_demo.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
								UIViewAutoresizingFlexibleHeight);
	
	[baseView addSubview:tv_demo];
	self.view = baseView;
	
	hud = [[ATMHud alloc] initWithDelegate:self];
}

- (void)viewDidLoad
{
	useFixedSize = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark UITableView

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return sectionHeaders[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return sectionFooters[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [cellCaptions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [cellCaptions[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *ident = @"DefaultCell";
	if (indexPath.section == ([cellCaptions count] - 1)) {
		ident = @"SwitchCell";
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
	}
	
	if (indexPath.section == ([cellCaptions count] - 1)) {
		UISwitch *fsSwitch = [UISwitch new];
		[fsSwitch sizeToFit];
		fsSwitch.on = useFixedSize;
		[fsSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
		
		cell.accessoryView = fsSwitch;
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		cell.accessoryView = nil;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	cell.textLabel.text = cellCaptions[indexPath.section][indexPath.row];
	
	return cell;
}

- (void)switchToggled:(UISwitch *)sw
{
	useFixedSize = [sw isOn];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == ([cellCaptions count] - 1)) {
		return nil;
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (useFixedSize) {
		[hud setFixedSize:CGSizeMake(200, 100)];
	} else {
		[hud setFixedSize:CGSizeZero];
	}

#pragma mark -
#pragma mark Experiment with different UI values
#pragma mark -

#if 0
	hud.appearScaleFactor		= 0.8f;
	hud.disappearScaleFactor	= 0.8f;
	hud.gray					= 0.2f;
	hud.alpha					= 0.8f;
	hud.margin					= 10.0f;
	hud.padding					= 10.0f;
	hud.alpha					= 0.8f;		// DFH: originally 0.7
	hud.gray					= 0.2f;		// DFH: originally 0.0
	hud.animateDuration			= 0.1f;
	hud.progressBorderRadius	= 8.0f;
	hud.progressBorderWidth		= 2.0f;
	hud.progressBarRadius		= 5.0f;
	hud.progressBarInset		= 3.0f;
	hud.accessoryPosition		= ATMHudAccessoryPositionBottom;
	hud.appearScaleFactor		= 0.8;		// DFH: originally 1.4f
	hud.disappearScaleFactor	= 0.8;		// DFH: originally 1.4f
#if 1 // these default to these
	hud.minShowTime					= 0;
	hud.center						= CGPointZero;
	hud.blockTouches				= NO;
	hud.allowSuperviewInteraction	= NO;
	hud.shadowEnabled				= NO;
#endif

#endif

	switch (indexPath.section) {
	case 0:
		[self basicHudActionForRow:indexPath.row];
		break;
		
	case 1:
		[self advancedHudActionForRow:indexPath.row];
		break;
		
	case 2:
		[self positioningActionForRow:indexPath.row];
		break;
	
	case 3:
	{
		hud2 = [ATMHud new];
		[hud2 setCaption:@"Just a simple caption."];
		__weak DemoViewController *weakSelf = self;
		hud2.blockDelegate = ^(delegateMessages msg, ATMHud *h)
								{
assert([NSThread isMainThread]);
									NSLog(@"MSG %d", msg);
									switch(msg) {
									case userDidTapHud:
										[h hide];
										break;
									case hudDidDisappear:
									{
//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
										// All this to avoid Xcode warnigs
										DemoViewController *strongSelf = weakSelf;
										if(strongSelf) {
											NSLog(@"Will dealloc...");
											strongSelf->hud2 = nil;
											NSLog(@"DID dealloc");
										}
    }
//);

									}	break;
									default:
										break;
									}
								};
		[hud2 showInView:self.view];
	}	break;
	
	}
}

#pragma mark -
#pragma mark Demonstration functions and selectors
- (void)basicHudActionForRow:(NSUInteger)row
{
	hud.minShowTime = 0;
	[hud setBlockTouches:NO];

	switch (row) {
	case 0:
		[hud setCaption:@"Just a simple caption."];
		break;
		
	case 1:
		[hud setCaption:@"Caption and an activity indicator."];
		[hud setActivity:YES];
		break;
		
	case 2:
		[hud setCaption:@"Caption and an image."];
		[hud setImage:[UIImage imageNamed:@"19-check"]];
		break;
		
	case 3:
		[hud setActivity:YES];
		[hud setActivityStyle:UIActivityIndicatorViewStyleWhiteLarge];
		break;
#ifdef ATM_SOUND
	case 4:
		[hud setCaption:@"Showing the HUD triggers a sound."];
		[hud setShowSound:[[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"]];
		break;
#endif
	}
	[hud showInView:self.view];
}

- (void)advancedHudActionForRow:(NSUInteger)row
{
	hud.minShowTime = 0;
	[hud setBlockTouches:YES];

	switch (row) {
	case 0:
		[hud setCaption:@"This HUD will auto-hide in 2 seconds."];
		hud.minShowTime = 2;			// new way
		[hud showInView:self.view];
		//[hud hideAfter:2.0];			// old way
		[hud hide];
		break;
		
	case 1:
		[hud setCaption:@"This HUD will update in 2 seconds."];
		[hud setActivity:YES];
		[hud showInView:self.view];
		[self performSelector:@selector(updateHud) withObject:nil afterDelay:2.0];
		break;
		
	case 2: {
		NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
		[hud setCaption:@"Performing operation..."];
		[hud setProgress:0.08];
		[hud showInView:self.view];
		break;
	}
		
	case 3: {
		ATMHudQueueItem *item = [ATMHudQueueItem new];
		item.caption = @"Display #1";
		item.image = nil;
		item.accessoryPosition = ATMHudAccessoryPositionBottom;
		item.showActivity = NO;
		[hud addQueueItem:item];
		
		item = [ATMHudQueueItem new];
		item.caption = @"Display #2";
		item.image = nil;
		item.accessoryPosition = ATMHudAccessoryPositionRight;
		item.showActivity = YES;
		[hud addQueueItem:item];
		
		item = [ATMHudQueueItem new];
		item.caption = @"Display #3";
		item.image = [UIImage imageNamed:@"19-check"];
		item.accessoryPosition = ATMHudAccessoryPositionBottom;
		item.showActivity = NO;
		[hud addQueueItem:item];
		
		[hud startQueueInView:self.view];
		[self performSelector:@selector(showNextDisplayInQueue) withObject:nil afterDelay:2];
		break;
	}
	}
}

- (void)tick:(NSTimer *)timer
{
	static CGFloat p = 0.08;
	p += 0.01;
	[hud setProgress:p];
	if (p >= 1) {
		p = 0;
		[timer invalidate];
		[hud hide];
		[self performSelector:@selector(resetProgress) withObject:nil afterDelay:0.2];
	}
}

- (void)resetProgress
{
	[hud setProgress:0];
}

- (void)updateHud
{
	[hud setCaption:@"And now it will hide."];
	[hud setActivity:NO];
	[hud setImage:[UIImage imageNamed:@"19-check"]];
	
	hud.minShowTime = 2;	// new way
	[hud update];
	[hud hide];				// new way
	//[hud hideAfter:2.0];	// old way
}

- (void)positioningActionForRow:(NSUInteger)row
{
	[hud setAccessoryPosition:(ATMHudAccessoryPosition)row];
	switch (row) {
	case 0:
		[hud setCaption:@"Position: Top"];
		[hud setProgress:0.45];
		break;
		
	case 1:
		[hud setCaption:@"Position: Right"];
		[hud setActivity:YES];
		break;
		
	case 2:
		[hud setCaption:@"Position: Bottom"];
		[hud setImage:[UIImage imageNamed:@"11-x"]];
		break;
		
	case 3:
		[hud setCaption:@"Position: Left"];
		[hud setActivity:YES];
		break;
	}
	[hud showInView:self.view];
}

- (void)showNextDisplayInQueue
{
	static int i = 1;
	[hud showNextInQueue];
	if (i < 3) {
		[self performSelector:@selector(showNextDisplayInQueue) withObject:nil afterDelay:2.0];
		i++;
	} else {
		i = 1;
		[hud clearQueue];
	}
}

#pragma mark -
#pragma mark ATMHudDelegate

- (void)userDidTapHud:(ATMHud *)_hud
{
	[_hud hide];
}

#pragma mark -
#pragma mark More examples

// Uncomment this method to see a demonstration of playing a sound everytime a HUD appears.
/*
- (void)hudDidAppear:(ATMHud *)_hud
{
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"pop"
															  ofType: @"wav"];
	[hud playSound:soundFilePath];
}
 */

@end
