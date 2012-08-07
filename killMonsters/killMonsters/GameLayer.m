//
//  HelloWorldLayer.m
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"
#import "GameConfig.h"
#import "Monster.h"
#import "Settings.h"
#import "SimpleAudioEngine.h"

#define SJ_PI 3.14159265359f
#define SJ_PI_X_2 6.28318530718f
#define SJ_RAD2DEG 180.0f/SJ_PI
#define SJ_DEG2RAD SJ_PI/180.0f

// HelloWorldLayer implementation
@implementation GameLayer

@synthesize guiLayer;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	GameLayer *layer = [GameLayer node];
	
	[scene addChild: layer];
    
    GUILayer *gui = [GUILayer node];
    [scene addChild: gui];
    
    layer.guiLayer = gui;
    gui.gameLayer = layer;
	
	return scene;
}

- (void) dealloc
{
	[super dealloc];
    
    [monstersArray dealloc];
    [bulletsArray dealloc];
}

-(id) init
{
	if( (self=[super init])) 
    {
        [[SimpleAudioEngine sharedEngine] preloadEffect: @"shot.wav"];
        
        monstersArray = [[NSMutableArray alloc] init];
        bulletsArray = [[NSMutableArray alloc] init];
        
        CCSprite *gameBg = [CCSprite spriteWithFile: @"gameBg.png"];
        gameBg.position = ccp(GameCenterX, GameCenterY);
        [self addChild: gameBg];
        
        [self initPlayer];
        
        [self startGame];
        
        [self scheduleUpdate];
	}
    
	return self;
}

- (void) startGame
{
    IsGameActive = YES;
    self.isTouchEnabled = YES;
    spawnTimeInterval = 3;
    
    lifes = 5;
    score = 0;
    
    [self schedule: @selector(timeIterator) interval: 1.0];
    

    
    for(CCSprite *currentBullet in bulletsArray)
    {
        [self removeChild: currentBullet cleanup: YES];
    }
    
    for(Monster *currentMonster in monstersArray)
    {
        [self removeChild: currentMonster cleanup: YES];
    }
    
    [bulletsArray removeAllObjects];
    [monstersArray removeAllObjects];
}

- (void) pauseGame
{
    self.isTouchEnabled = NO;
    
    for(CCSprite *currentBullet in bulletsArray)
    {
        [currentBullet pauseSchedulerAndActions];
    }
    
    for(Monster *currentMonster in monstersArray)
    {
        [currentMonster pauseSchedulerAndActions];
    }
    
    [self unschedule: @selector(timeIterator)];
}

- (void) unPauseGame
{
    self.isTouchEnabled = YES;
    
    for(CCSprite *currentBullet in bulletsArray)
    {
        [currentBullet resumeSchedulerAndActions];
    }
    
    for(Monster *currentMonster in monstersArray)
    {
        [currentMonster resumeSchedulerAndActions];
    }
    
    [self schedule: @selector(timeIterator) interval: 1.0];
}

- (void) initPlayer
{
    playerSprite = [CCSprite spriteWithFile: @"player.png"];
    playerSprite.scale = 0.8;
    playerSprite.position = ccp(40, GameCenterY);
    [self addChild: playerSprite z: 5];
}

- (void) spawnMonster
{
    if(IsGameActive == YES)
    {
        Monster *monster = [Monster create];
        
        [self addChild: monster];
        
        [monstersArray addObject: monster];
        
        monster.gameLayer = self;
        
        [monster run];
    }
}

- (void) timeIterator
{
    if(IsGameActive == YES)
    {
        time++;
        
        if(time != 0 && time % 15 == 0)
        {
            spawnTimeInterval--;
            
            if(spawnTimeInterval <= 1)
            {
                spawnTimeInterval = 1;
            }
        }
        
        if(time % spawnTimeInterval == 0)
        {
            [self spawnMonster];
        }
    }
}

- (void) update: (ccTime) dt
{
    if(IsGameActive == YES)
    {
        NSMutableArray *bulletsToRemove = [[NSMutableArray alloc] init];
        NSMutableArray *monstersToRemove = [[NSMutableArray alloc] init];
        
        for(CCSprite *currentBullet in bulletsArray)
        {
            if(currentBullet.position.x > 480 || currentBullet.position.x <  0 || currentBullet.position.y > 320 || currentBullet.position.y < 0)
            {
                [bulletsToRemove addObject: currentBullet];
            }
            
            for(Monster *currentMonster in monstersArray)
            {
                if(abs(currentBullet.position.x - currentMonster.position.x) <= 13 && abs(currentBullet.position.y - currentMonster.position.y) <= 13)
                {
                    if(currentMonster.state != monsterDying)
                    {
                        [self addScore];
                        [monstersToRemove addObject: currentMonster];
                    }
                }
            }
        }
        
        for(CCSprite *bulletToRemove in bulletsToRemove)
        {
            [self removeChild: bulletToRemove cleanup: YES];
            [bulletsArray removeObject: bulletToRemove];
        }
        
        for(Monster *monsterToRemove in monstersToRemove)
        {
            [self removeChild: monsterToRemove cleanup: YES];
            [monstersArray removeObject: monsterToRemove];
        }

        [bulletsToRemove release];
        [monstersToRemove release];
    }
}

- (void) doShot: (CGPoint) location
{
    bulletSprite = [CCSprite spriteWithFile: @"bullet.png"];
    //bulletSprite.scale = 0.1;
    bulletSprite.position = playerSprite.position;
    [self addChild: bulletSprite];
    
    [bulletsArray addObject: bulletSprite];
    
    /////////////////////
    
    CGPoint vector = ccpSub(location, playerSprite.position);
    
    CGPoint normalVector = ccpNormalize(vector);
    
    CGPoint shotPoint = ccp((normalVector.x * 500) + playerSprite.position.x, (normalVector.y * 500) + playerSprite.position.y);
    
    //CGPoint shotPosition = normalVector5;
    
    /////////////////////
    
    float angle = ccpToAngle(vector);
    
    [playerSprite setRotation: angle * -SJ_RAD2DEG];
    
    [[SimpleAudioEngine sharedEngine] playEffect: @"shot.wav"];
    
    [bulletSprite runAction: [CCMoveTo actionWithDuration: 1.5 position: shotPoint]];
}

- (void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: 0  swallowsTouches: YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];    
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    [self doShot: location];
    
    return YES;
}

- (void) addDamageFromMonster: (Monster *) currentMonster
{
    lifes--;
    
    if(lifes <= 0)
    {
        lifes = 0;
        
        NSInteger bestResultEver = [Settings sharedSettings].maxScore;
        if(score > bestResultEver)
        {
            //check for a new record and save if any
            [Settings sharedSettings].maxScore = score;
            [[Settings sharedSettings] save];
        }
        NSInteger b_Score = [Settings sharedSettings].maxScore;
        [guiLayer updateBestScoreLabel: b_Score];
        
        [guiLayer showGameOverMenu];
    }
    
    [guiLayer updateLifesLabel: lifes];
}

- (void) addScore
{
    score++;
    CCLOG(@"score: %i", score);
    [guiLayer updateScoreLabel: score];
}

- (void) destroyMonster: (Monster *) monster
{
    [self removeChild: monster cleanup: YES];
    [monstersArray removeObject: monster];
}

@end
