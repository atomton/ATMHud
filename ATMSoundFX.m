/*
 *  ATMSoundFX.m
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

#import <AudioToolbox/AudioServices.h>

#import "ATMSoundFX.h"

@implementation ATMSoundFX
{
	SystemSoundID soundID;
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    if ((self = [super init])) {
        NSURL *aFileURL = [NSURL fileURLWithPath:path isDirectory:NO];
        
        if (aFileURL)  {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &aSoundID);
            
            if (error == kAudioServicesNoError) {
                soundID = aSoundID;
            } else {
                self = nil;
            }
        } else {
            self = nil;
        }
    }
    return self;
}

- (void)dealloc {
	if (soundID) {
		// one presumes dealloc called even if init failed, since super succeeded...
		AudioServicesDisposeSystemSoundID(soundID);
		NSLog(@"SOUND DEALLOC");
	}
}

- (void)play {
    AudioServicesPlaySystemSound(soundID);
}

@end
