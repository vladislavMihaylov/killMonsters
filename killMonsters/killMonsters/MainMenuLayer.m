//
//  MainMenuLayer.m
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameConfig.h"
#import "GameLayer.h"
#import "Apsalar.h"
#import "SimpleAudioEngine.h"

@implementation MainMenuLayer

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    MainMenuLayer *layer = [MainMenuLayer node];
    
    [scene addChild: layer];
    
    return scene;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if((self = [super init]))
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"bgMusic.mp3" loop: YES];
        
        CCSprite *menuBg = [CCSprite spriteWithFile: @"menuBg.png"];
        menuBg.position = ccp(GameCenterX, GameCenterY);
        [self addChild: menuBg];
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage: @"mainMenuPlayBtn.png" 
                                                       selectedImage: @"mainMenuPlayBtn.png"
                                                              target: self 
                                                            selector: @selector(play:)];
        
        play.position = ccp(GameCenterX + 100, GameCenterY + 40);
        
        CCMenuItemImage *more = [CCMenuItemImage itemFromNormalImage: @"mainMenuMoreBtn.png" 
                                                       selectedImage: @"mainMenuMoreBtn.png"
                                                              target: self 
                                                            selector: @selector(showMoreGames)];
        
        more.position = ccp(GameCenterX + 100, GameCenterY - 40);
        
        CCMenu *mainMenu = [CCMenu menuWithItems: play, more, nil];
        mainMenu.position = ccp(0,0);
        [self addChild: mainMenu];
    }
    
    return self;
}

- (void) play: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [GameLayer scene]]];
}

-(void)showMoreGames
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kRequestMoreAppsNotificationKey object: nil];
    
    [Apsalar event: @"killMonsterShowMoreGames"];
}

@end
