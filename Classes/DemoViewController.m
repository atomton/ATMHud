/*
 *  DemoViewController.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
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
 *	https://github.com/atomton/ATMHud
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
@synthesize tv_demo, hud, useFixedSize;
@synthesize sectionHeaders, sectionFooters, cellCaptions;

#pragma mark -
#pragma mark View lifecycle
- (id)init {
	if ((self = [super init])) {
		NSArray *section0 = [NSArray arrayWithObjects:@"Show with caption only", @"Show with caption and activity", @"Show with caption and image", @"Show activity only", @"Play sound on show", nil];
		NSArray *section1 = [NSArray arrayWithObjects:@"Show and auto-hide", @"Show, update and auto-hide", @"Show progress bar", @"Show queued HUD", nil];
		NSArray *section2 = [NSArray arrayWithObjects:@"Accessory top", @"Accessory right", @"Accessory bottom", @"Accessory left", nil];
		NSArray *section3 = [NSArray arrayWithObject:@"Use fixed size"];
		
		sectionHeaders = [[NSArray alloc] initWithObjects:@"Basic functions", @"Advanced functions", @"Accessory positioning", @"", nil];
		sectionFooters = [[NSArray alloc] initWithObjects:@"Tap the HUD to hide it.", @"Tap to hide is disabled.", @"", [ATMHud buildInfo], nil];
		cellCaptions = [[NSArray alloc] initWithObjects:section0, section1, section2, section3, nil];
	}
	return self;
}

- (void)loadView {
	UIView *baseView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	tv_demo = [[UITableView alloc] initWithFrame:baseView.bounds style:UITableViewStyleGrouped];
	tv_demo.delegate = self;
	tv_demo.dataSource = self;
	tv_demo.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
								UIViewAutoresizingFlexibleHeight);
	
	[baseView addSubview:tv_demo];
	
	hud = [[ATMHud alloc] initWithDelegate:self];
	[baseView addSubview:hud.view];
	
	self.view = baseView;
	[baseView release];
}

- (void)viewDidLoad {
	useFixedSize = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[tv_demo release];
	[hud release];
	
	[cellCaptions release];
	[sectionHeaders release];
	[sectionFooters release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark UITableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [sectionHeaders objectAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return [sectionFooters objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 5;
			break;
			
		case 1:
			return 4;
			break;
			
		case 2:
			return 4;
			break;
			
		case 3:
			return 1;
			break;
			
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *ident = @"DefaultCell";
	if (indexPath.section == 3) {
		ident = @"SwitchCell";
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
	}
	
	if (indexPath.section == 3) {
		UISwitch *fsSwitch = [[UISwitch alloc] init];
		[fsSwitch sizeToFit];
		fsSwitch.on = useFixedSize;
		[fsSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
		
		cell.accessoryView = fsSwitch;
		[fsSwitch release];
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	} else {
		cell.accessoryView = nil;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
	cell.textLabel.text = [[cellCaptions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)switchToggled:(UISwitch *)sw {
	useFixedSize = [sw isOn];
	if (useFixedSize) {
		[hud setFixedSize:CGSizeMake(200, 100)];
	} else {
		[hud setFixedSize:CGSizeZero];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 3) {
		return nil;
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
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
	}
}

#pragma mark -
#pragma mark Demonstration functions and selectors
- (void)basicHudActionForRow:(NSUInteger)row {
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
			
		case 4:
			[hud setCaption:@"Showing the HUD triggers a sound."];
			[hud setShowSound:[[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"]];
			break;
	}
	[hud show];
}

- (void)advancedHudActionForRow:(NSUInteger)row {
	[hud setBlockTouches:YES];
	switch (row) {
		case 0:
			[hud setCaption:@"This HUD will auto-hide in 2 seconds."];
			[hud show];
			[hud hideAfter:2.0];
			break;
			
		case 1:
			[hud setCaption:@"This HUD will update in 2 seconds."];
			[hud setActivity:YES];
			[hud show];
			[self performSelector:@selector(updateHud) withObject:nil afterDelay:2.0];
			break;
			
		case 2: {
			NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
			[hud setCaption:@"Performing operation..."];
			[hud setProgress:0.08];
			[hud show];
			break;
		}
			
		case 3: {
			ATMHudQueueItem *item = [[ATMHudQueueItem alloc] init];
			item.caption = @"Display #1";
			item.image = nil;
			item.accessoryPosition = ATMHudAccessoryPositionBottom;
			item.showActivity = NO;
			[hud addQueueItem:item];
			[item release];
			
			item = [[ATMHudQueueItem alloc] init];
			item.caption = @"Display #2";
			item.image = nil;
			item.accessoryPosition = ATMHudAccessoryPositionRight;
			item.showActivity = YES;
			[hud addQueueItem:item];
			[item release];
			
			item = [[ATMHudQueueItem alloc] init];
			item.caption = @"Display #3";
			item.image = [UIImage imageNamed:@"19-check"];
			item.accessoryPosition = ATMHudAccessoryPositionBottom;
			item.showActivity = NO;
			[hud addQueueItem:item];
			[item release];
			
			[hud startQueue];
			[self performSelector:@selector(showNextDisplayInQueue) withObject:nil afterDelay:2];
			break;
		}
	}
}

- (void)tick:(NSTimer *)timer {
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

- (void)resetProgress {
	[hud setProgress:0];
}

- (void)updateHud {
	[hud setCaption:@"And now it will hide."];
	[hud setActivity:NO];
	[hud setImage:[UIImage imageNamed:@"19-check"]];
	[hud update];
	[hud hideAfter:2.0];
}

- (void)positioningActionForRow:(NSUInteger)row {
	[hud setAccessoryPosition:row];
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
	[hud show];
}

- (void)showNextDisplayInQueue {
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
- (void)userDidTapHud:(ATMHud *)_hud {
	[_hud hide];
}

#pragma mark -
#pragma mark More examples

// Uncomment this method to see a demonstration of playing a sound everytime a HUD appears.
/*
- (void)hudDidAppear:(ATMHud *)_hud {
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"pop"
															  ofType: @"wav"];
	[hud playSound:soundFilePath];
}
 */

@end
