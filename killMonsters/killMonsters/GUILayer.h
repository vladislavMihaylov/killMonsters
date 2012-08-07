//
//  GUILayer.h
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameLayer;

@interface GUILayer: CCNode 
{
    GameLayer *gameLayer;
    
    CCLabelBMFont *scoreLabel;
    CCLabelBMFont *lifesLabel;
    CCLabelBMFont *pauseLabel;
    CCLabelBMFont *yourScoreLabel;
    CCLabelBMFont *yourBestScoreLabel;
    CCLabelBMFont *bestScoreLabel;
    
    CCMenuItemImage *pauseBtn;
    
    CCMenu *pauseMenu;
    
    CCLayer *pauseLayer;
    
    
}

- (void) updateLifesLabel: (NSInteger) lifes;
- (void) updateScoreLabel: (NSInteger) score;
- (void) updateBestScoreLabel: (NSInteger) score;

- (void) showPauseMenu;
- (void) showGameOverMenu;

@property (nonatomic, assign) GameLayer *gameLayer;

@end
