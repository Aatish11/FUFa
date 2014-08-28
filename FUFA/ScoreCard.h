//
//  ScoreCard.h
//  FUFA
//
//  Created by Aatish Molasi on 5/25/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface ScoreCard : CCMenu
{
    id delegate;
    Player *_player;
}

+(id) itemWithTarget:(id)target selector:(SEL)selector player:(Player *)player turn:(int)turn;

- (void)updateScorePlayerOne:(NSMutableArray *)scoreOne playerTwo:(NSMutableArray *)scoreTwo;

@end

@protocol ScorecardDelegate <NSObject>

- (void)tapReady:(id)sender;
- (void)tapInfo:(id)sender;
- (void)tapDetails:(id)sender;

@end