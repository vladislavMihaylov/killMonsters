//
//  Monster.m
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Monster.h"


@implementation Monster

@synthesize gameLayer;
@synthesize state;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if((self = [super init]))
    {
        height = arc4random() % 680 + 50;
        runTime = arc4random() % 3 + 2;
        numberOfPic = arc4random() % 4;
        
        sprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"enemy%i.png", numberOfPic]];
        sprite.scale = 0.4;
        self.position = ccp(1070, height);
        self.scale = 1.5;
        
        [self addChild: sprite];
    }
    
    return self;
}

- (void) run
{
    state = monsterNormal;
    
    [self runAction: 
                [CCSequence actions: 
                                [CCMoveTo actionWithDuration: runTime
                                                    position: ccp(-20, self.position.y)], 
                                [CCCallFuncO actionWithTarget: gameLayer 
                                                     selector: @selector(addDamageFromMonster:) 
                                                       object: self], 
                                [CCCallFuncO actionWithTarget: gameLayer 
                                                     selector: @selector(destroyMonster:) 
                                                       object: self],
                 nil]
     ];
}


+ (Monster *) create
{
    Monster *monster = [[[Monster alloc] init] autorelease];
    
    return monster;
}

@end
