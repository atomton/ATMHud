/*
 *  ATMHudAppDelegate.m
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

#import "ATMHudAppDelegate.h"
#import "DemoViewController.h"

@implementation ATMHudAppDelegate
@synthesize window, nav;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DemoViewController *rvc = [[DemoViewController alloc] init];
	rvc.title = @"atomHUD • Demo";

	nav = [[UINavigationController alloc] initWithRootViewController:rvc];
	[rvc release];

	window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc {
    [window release];
	[nav release];
    [super dealloc];
}


@end
