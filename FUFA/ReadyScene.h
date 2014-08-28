//
//  ReadyScene.h
//  FUFA
//
//  Created by Aatish Molasi on 5/17/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "ScoreCard.h"
#import "InfoLayer.h"
#import "SettingsLayer.h"
#import "EndgameLayer.h"

typedef enum {
    kGameStateCountdown,
    kGameStateStart
} eGameState;


@interface ReadyScene : CCLayerColor
{
    CCSprite *_field;
    
    CCMenu *_menu;
    CCNode *_readyButtonOne;
    CCNode *_readyButtonTwo;
    CCMenuItemImage *_shadowButtonOne;
    CCMenuItemImage *_shadowButtonTwo;
    
    ScoreCard *_scoreCardOne;
    ScoreCard *_scoreCardTwo;
    
    CCSpriteBatchNode *_playerOneSprite;
    CCSpriteBatchNode *_kicker;
    CCLayerColor *_background;
    
    NSMutableArray *_cleanupSprites;
    Player *_playerOne;
    Player *_playerTwo;
    
    int _round;
    NSDate *_startDate;
    eGameState _gameState;
}

@property (nonatomic, retain) CCSprite *field;

+(CCScene *)scene;
+(CCScene *)sceneWithPlayers:(NSInteger)players;
- (void)dismissBackground;
- (void)gotoMainMenu;

@end
