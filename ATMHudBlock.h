//
//  ATMHudBlock.h
//  ATMHud
//
//  Created by Constantine on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATMHud;

@protocol ATMHudCallback <NSObject>
+ (id)blockWithUserDidTapHud:(id)tapBlock willAppear:(id)willAppearBlock didAppear:(id)didAppearBlock willUpdate:(id)willUpdateBlock didUpdate:(id)didUpdateBlock willDisappear:(id)willDisappearBlock didDisappear:(id)didDisappearBlock;
@end

@interface ATMHudCallback : NSObject <ATMHudCallback> {
@private
    id _tapBlock;
    id _willAppearBlock;
    id _didAppearBlock;
    id _willUpdateBlock;
    id _didUpdateBlock;
    id _willDisappearBlock;
    id _didDisappearBlock;
}

@end

typedef void (^ATMHudDefaultBlock)(ATMHud *hud);

#pragma mark - ATMHudBlock

@protocol ATMHudBlock <NSObject>
@optional
+ (id)blockWithUserDidTapHud:(ATMHudDefaultBlock)tapBlock willAppear:(ATMHudDefaultBlock)willAppearBlock didAppear:(ATMHudDefaultBlock)didAppearBlock willUpdate:(ATMHudDefaultBlock)willUpdateBlock didUpdate:(ATMHudDefaultBlock)didUpdateBlock willDisappear:(ATMHudDefaultBlock)willDisappearBlock didDisappear:(ATMHudDefaultBlock)didDisappearBlock;
@end

@interface ATMHudBlock : ATMHudCallback <ATMHudBlock>
@property (readwrite, nonatomic, copy) ATMHudDefaultBlock tapBlock;
@property (readwrite, nonatomic, copy) ATMHudDefaultBlock willAppearBlock;
@property (readwrite, nonatomic, copy) ATMHudDefaultBlock didAppearBlock;
@property (readwrite, nonatomic, copy) ATMHudDefaultBlock willUpdateBlock;
@property (readwrite, nonatomic, copy) ATMHudDefaultBlock didUpdateBlock;
@property (readwrite, nonatomic, copy) ATMHudDefaultBlock willDisappearBlock;
@property (readwrite, nonatomic, copy) ATMHudDefaultBlock didDisappearBlock;
@end