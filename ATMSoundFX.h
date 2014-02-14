/*
 *  ATMSoundFX.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud
 */

@interface ATMSoundFX : NSObject

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (void)play;

@end
