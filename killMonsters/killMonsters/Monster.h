//
//  Monster.h
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

typedef enum
{
    monsterNormal,
    monsterDying,
    monsterAtack,
} MonsterState;

@interface Monster: CCNode 
{
    
    MonsterState state;
    
    GameLayer *gameLayer;
    
    CCSprite *sprite;
    
    NSInteger height;
    NSInteger runTime;
    NSInteger numberOfPic;
}

+ (Monster *) create;

- (void) run;

@property (nonatomic, assign) GameLayer *gameLayer;
@property (nonatomic, assign) MonsterState state;

@end
