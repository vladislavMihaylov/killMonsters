//
//  GUILayer.m
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GUILayer.h"
#import "GameConfig.h"
#import "GameLayer.h"
#import "MainMenuLayer.h"
#import "Apsalar.h"

@implementation GUILayer

@synthesize gameLayer;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if((self = [super init]))
    {
        CCSprite *lifes = [CCSprite spriteWithFile: @"lifes.png"];
        lifes.position = ccp(25, GameHeight - 20);
        lifes.scale = 0.8;
        [self addChild: lifes];
        
        CCSprite *coins = [CCSprite spriteWithFile: @"coins.png"];
        coins.position = ccp(75, GameHeight - 21);
        [self addChild: coins];
        
        scoreLabel = [CCLabelBMFont labelWithString: @"0" fntFile: @"font25.fnt"];
        scoreLabel.position = ccp(90, GameHeight - 20);
        scoreLabel.anchorPoint = ccp(0, 0.5);
        [self addChild: scoreLabel];
        
        lifesLabel = [CCLabelBMFont labelWithString: @"5" fntFile: @"font25.fnt"];
        lifesLabel.position = ccp(50, GameHeight - 20);
        [self addChild: lifesLabel];
        
        bestScoreLabel = [CCLabelTTF labelWithString: @"" fontName: @"Arial" fontSize: 30];
        bestScoreLabel.position = ccp(GameWidth + 200, GameCenterY - 10);
        [self addChild: bestScoreLabel];
        
        pauseBtn = [CCMenuItemImage itemFromNormalImage: @"pauseBtn.png" selectedImage: @"pauseBtn.png" target: self selector: @selector(showPauseMenu)];
        pauseBtn.scale = 0.7;
        pauseBtn.position = ccp(GameWidth * 0.95, GameHeight * 0.92);
        
        CCMenu *doPauseGameMenu = [CCMenu menuWithItems: pauseBtn, nil];
        doPauseGameMenu.position = ccp(0,0);
        [self addChild: doPauseGameMenu];
    }
    
    return self;
}

- (void) continuePlay
{
    IsGameActive = YES;
    
    [gameLayer unPauseGame];
    
    [self removeChild: pauseLayer cleanup: YES];
    [self removeChild: pauseLabel cleanup: YES];
    [self removeChild: pauseMenu cleanup: YES];
    [self removeChild: yourScoreLabel cleanup: YES];
    
    [pauseBtn setOpacity: 255];
}

- (void) restartGame
{
    scoreLabel.string = @"0";
    lifesLabel.string = @"5";
    
    [gameLayer startGame];
    
    [self removeChild: pauseLayer cleanup: YES];
    [self removeChild: pauseLabel cleanup: YES];
    [self removeChild: pauseMenu cleanup: YES];
    [self removeChild: yourScoreLabel cleanup: YES];
    [self removeChild: yourBestScoreLabel cleanup: YES];
    
    [pauseBtn setOpacity: 255];
    
    [Apsalar event: @"killMonsterSkipLevel"];
}

- (void) exitGame: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [MainMenuLayer scene]]];
}

- (void) showPauseMenu
{
    if(IsGameActive == YES)
    {
        [pauseBtn setOpacity:0];
        [gameLayer pauseGame];
        
        IsGameActive = NO;
        
        pauseLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 220)];
        pauseLayer.position = ccp(0, 0);
        [self addChild:pauseLayer z: kZpauseLayer];
        
        pauseLabel = [CCLabelBMFont labelWithString: @"PAUSED" fntFile: @"font40.fnt"];
        pauseLabel.color = ccc3(255, 0, 0);
        pauseLabel.position = ccp(GameCenterX, GameHeight + 30);
        [self addChild:pauseLabel z:kZMenu];
        
        //yourScoreLabel = [CCLabelTTF labelWithString: @"" fontName: @"Arial" fontSize: 30];
        yourScoreLabel = [CCLabelBMFont labelWithString: @"" fntFile: @"font25.fnt"];
        yourScoreLabel.string = [NSString stringWithFormat: @"Score: %@", scoreLabel.string];
        yourScoreLabel.position = ccp(GameCenterX, GameHeight + 30);
        [self addChild: yourScoreLabel z:kZMenu];
        
        CCMenuItemImage *exitGameBtn = [CCMenuItemImage itemFromNormalImage: @"exitBtn.png" 
                                                              selectedImage: @"exitBtnTap.png"
                                                                     target: self 
                                                                   selector: @selector(exitGame:)];
        
        CCMenuItemImage *continuePlayBtn = [CCMenuItemImage itemFromNormalImage: @"playBtn.png"
                                                                  selectedImage: @"playBtnTap.png"
                                                                         target: self 
                                                                       selector: @selector(continuePlay)];
        
        CCMenuItemImage *restartGameBtn = [CCMenuItemImage itemFromNormalImage: @"restartBtn.png" 
                                                                 selectedImage: @"restartBtnTap.png"
                                                                        target: self 
                                                                      selector: @selector(restartGame)];
        
        
        exitGameBtn.scale = 0.0;
        continuePlayBtn.scale = 0.0;
        restartGameBtn.scale = 0.0;
        
        exitGameBtn.position = ccp(GameCenterX - 100, GameCenterY - 60);
        continuePlayBtn.position = ccp(GameCenterX  + 100, GameCenterY - 60);
        restartGameBtn.position = ccp(GameCenterX, GameCenterY - 60);
        
        pauseMenu = [CCMenu menuWithItems: exitGameBtn, continuePlayBtn, restartGameBtn, nil];
        pauseMenu.position = ccp(0, 0);
        [self addChild:pauseMenu z: kZMenu];
        
        [yourScoreLabel runAction: 
         [CCEaseBackOut actionWithAction:
          [CCMoveTo actionWithDuration: 0.5f 
                              position: ccp(GameCenterX, GameCenterY + 20)
           ]
          ]
         ];
        
        [pauseLabel runAction: 
         [CCEaseBackOut actionWithAction:
          [CCMoveTo actionWithDuration: 0.5f 
                              position: ccp(GameCenterX, GameHeight - 80)
           ]
          ]
         ];
        
        
        
        [exitGameBtn runAction: 
         [CCScaleTo actionWithDuration: 0.1 scale: 1.3]
         ];
        
        [continuePlayBtn runAction: 
         [CCScaleTo actionWithDuration: 0.2 scale: 1.3]
         ];
        
        [restartGameBtn runAction: 
         [CCScaleTo actionWithDuration: 0.15 scale: 1.3]
         ];
        
    }
}

- (void) showGameOverMenu
{
    if(IsGameActive == YES)
    {
        [pauseBtn setOpacity:0];
        [gameLayer pauseGame];
        
        IsGameActive = NO;
        
        pauseLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 220)];
        pauseLayer.position = ccp(0, 0);
        [self addChild:pauseLayer z: kZpauseLayer];
        
        pauseLabel = [CCLabelBMFont labelWithString: @"GAME OVER" fntFile: @"font40.fnt"];
        pauseLabel.color = ccc3(255, 0, 0);
        pauseLabel.position = ccp(GameCenterX, GameHeight + 30);
        [self addChild:pauseLabel z:kZMenu];
        
        yourScoreLabel = [CCLabelBMFont labelWithString: @"" fntFile: @"font25.fnt"];
        yourScoreLabel.string = [NSString stringWithFormat: @"Score: %@", scoreLabel.string];
        yourScoreLabel.position = ccp(GameCenterX, GameHeight + 30);
        [self addChild: yourScoreLabel z:kZMenu];
        
        yourBestScoreLabel = [CCLabelBMFont labelWithString: @"" fntFile: @"font25.fnt"];
        yourBestScoreLabel.position = ccp(GameCenterX, GameHeight + 40);
        yourBestScoreLabel.string = [NSString stringWithFormat: @"%@", bestScoreLabel.string];
        [self addChild: yourBestScoreLabel z:kZMenu];
        
        CCMenuItemImage *exitGameBtn = [CCMenuItemImage itemFromNormalImage: @"exitBtn.png" 
                                                              selectedImage: @"exitBtnTap.png"
                                                                     target: self 
                                                                   selector: @selector(exitGame:)];
        
        CCMenuItemImage *restartGameBtn = [CCMenuItemImage itemFromNormalImage: @"restartBtn.png" 
                                                                 selectedImage: @"restartBtnTap.png"
                                                                        target: self 
                                                                      selector: @selector(restartGame)];
        
        
        exitGameBtn.scale = 0.0;
        restartGameBtn.scale = 0.0;
        
        exitGameBtn.position = ccp(GameCenterX - 50, GameCenterY - 60);
        restartGameBtn.position = ccp(GameCenterX + 50, GameCenterY - 60);
        
        pauseMenu = [CCMenu menuWithItems: exitGameBtn, restartGameBtn, nil];
        pauseMenu.position = ccp(0, 0);
        [self addChild:pauseMenu z: kZMenu];
        
        [yourBestScoreLabel runAction: 
                            [CCEaseBackOut actionWithAction:
                                                        [CCMoveTo actionWithDuration: 0.5f 
                                                                            position: ccp(GameCenterX, GameCenterY + 10)
                                                         ]
                             ]
        ];
        
        [yourScoreLabel runAction: 
         [CCEaseBackOut actionWithAction:
          [CCMoveTo actionWithDuration: 0.5f 
                              position: ccp(GameCenterX, GameCenterY + 45)
           ]
          ]
         ];
        
        [pauseLabel runAction: 
         [CCEaseBackOut actionWithAction:
          [CCMoveTo actionWithDuration: 0.5f 
                              position: ccp(GameCenterX, GameHeight - 65)
           ]
          ]
         ];
        
        
        
        [exitGameBtn runAction: 
         [CCScaleTo actionWithDuration: 0.1 scale: 1.3]
         ];

        
        [restartGameBtn runAction: 
         [CCScaleTo actionWithDuration: 0.15 scale: 1.3]
         ];
        
    }
}



- (void) updateScoreLabel: (NSInteger) score
{
    scoreLabel.string = [NSString stringWithFormat: @"%i", score];
}

- (void) updateLifesLabel: (NSInteger) lifes
{
    lifesLabel.string = [NSString stringWithFormat: @"%i", lifes];
}

- (void) updateBestScoreLabel: (NSInteger) score
{
    bestScoreLabel.string = [NSString stringWithFormat:@"Best score: %i", score];
}

@end
