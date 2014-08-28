//
//  Player.h
//  PenaltyAttemptOne
//
//  Created by Aatish Molasi on 5/1/14.
//  Copyright (c) 2014 Aatish Molasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kPlayerKeeper,
    kPlayerShooter
} ePlayerType;

@interface Player : NSObject
{
    CCSprite *_sprite;
    NSString *_country;
    NSString *_teamName;
    ePlayerType _currentType;
    int _playerNumber;
    NSTimeInterval _time;
    NSMutableArray *_score;
    float _minTime;
    BOOL _playerReady;
    
    CCFiniteTimeAction *_diveAnimation;
    CCAction *_breatheAnimation;
    CCFiniteTimeAction *_jumpAnimation;
    CCAction *_readyAction;
    CCFiniteTimeAction *_kickAction;
}
@property(nonatomic, retain) CCSprite *sprite;
@property(nonatomic, retain) NSString *country;
@property(nonatomic, retain) NSString *teamName;
@property(nonatomic) ePlayerType currentType;
@property(nonatomic) int playerNumber;
@property(nonatomic) float minTime;
@property(nonatomic) NSTimeInterval time;
@property(nonatomic, retain) NSMutableArray* score;
@property(assign, getter = isPlayerReady) BOOL playerReady;

- (id)initWithPlayerNumber:(int)playerNumber;
- (void)shoot;
- (void)save;
- (void)breathe:(BOOL)breathe;
- (void)jump;
- (void)roundResult:(NSNumber *)res;
- (void)readyKicker:(BOOL)ready;

- (void)setPlayerType:(ePlayerType)playerType;

@end

