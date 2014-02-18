/*
 *  ATMSoundFX.h
 *  ATMHud
 *
 *  Created by Marcel Müller on 2011-03-01.
 *  Copyright (c) 2010-2011, Marcel Müller (atomcraft)
 *  Copyright (c) 2012-2014, David Hoerl
 *  All rights reserved.
 *
 *	https://github.com/atomton/ATMHud (original)
 */

@interface ATMSoundFX : NSObject

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (void)play;

@end
