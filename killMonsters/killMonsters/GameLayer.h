//
//  HelloWorldLayer.h
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GUILayer.h"

@class Monster;

// HelloWorldLayer
@interface GameLayer: CCLayer
{
    GUILayer *gui;
    
    CCSprite *playerSprite;
    CCSprite *bulletSprite;
    
    NSInteger time;
    NSInteger spawnTimeInterval;
    NSInteger lifes;
    NSInteger score;
    
    NSMutableArray *monstersArray;
    NSMutableArray *bulletsArray;
}

+(CCScene *) scene;

- (void) startGame;
- (void) pauseGame;
- (void) unPauseGame;

- (void) addScore;
- (void) initPlayer;
- (void) doShot: (CGPoint) location;
- (void) addDamageFromMonster: (Monster *) currentMonster;
- (void) destroyMonster: (Monster *) monster;

@property (nonatomic, assign) GUILayer *guiLayer;

@end
