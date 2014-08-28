
//
//  Player.m
//  PenaltyAttemptOne
//
//  Created by Aatish Molasi on 5/1/14.
//  Copyright (c) 2014 Aatish Molasi. All rights reserved.
//

#import "Player.h"

@interface Player()


@property (nonatomic, retain)CCFiniteTimeAction *diveAnimation;
@property (nonatomic, retain)CCAction *breatheAnimation;
@property (nonatomic, retain)CCFiniteTimeAction *jumpAnimation;
@property (nonatomic, retain)CCAction *readyAction;
@property (nonatomic, retain)CCFiniteTimeAction *kickAction;

@end

@implementation Player

@synthesize sprite = _sprite;
@synthesize country = _country;
@synthesize teamName = _teamName;
@synthesize currentType = _currentType;
@synthesize time = _time;
@synthesize minTime = _minTime;
@synthesize score = _score;
@synthesize playerReady = _playerReady;
@synthesize playerNumber = _playerNumber;

@synthesize diveAnimation = _diveAnimation;
@synthesize breatheAnimation = _breatheAnimation;
@synthesize jumpAnimation = _jumpAnimation;
@synthesize readyAction = _readyAction;
@synthesize kickAction = _kickAction;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.playerReady = NO;
    }
    return self;
}

- (id)initWithPlayerNumber:(int)playerNumber
{
    self = [super init];
    if (self)
    {
        self.playerReady = NO;
        self.playerNumber = playerNumber;
        self.minTime = NSIntegerMax;
        if (playerNumber == 1)
        {
            self.teamName = @"Spain";
            self.country = @"Spain";
        }
        else
        {
            self.teamName = @"Brazil";
            self.country = @"Brazil";
        }
        self.score = [[NSMutableArray alloc] init];
//        for (int i=0; i<5; i++)
//        {
//            [self.score addObject:[NSNumber numberWithInt:0]];
//        }
        
        NSMutableArray *breatheFrames = [NSMutableArray array];
        for (int i=1001; i<=1018; i++) {
            [breatheFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"%@%d.png",@"Heavybreathe",(i)]]];
        }
        
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:breatheFrames delay:0.1f];
        //self.diveAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        
        self.breatheAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        
        
        NSMutableArray *jumpFrames = [NSMutableArray array];
        for (int i=1001; i<=1012; i++) {
            [jumpFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"%@%d.png",@"jmp",(i)]]];
        }
        
        CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpFrames delay:0.1f];
        //self.diveAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        
        self.jumpAnimation = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:jumpAnim] times:1];
        
        
        NSMutableArray *diveFrames = [NSMutableArray array];
        for (int i=1; i<=12; i++) {
            [diveFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"%@%d.png",@"goalieDive",(i)]]];
        }
        
        CCAnimation *divinAnim = [CCAnimation animationWithSpriteFrames:diveFrames delay:0.1f];
        //self.diveAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        
        self.diveAnimation = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:divinAnim] times:1];
        [self.diveAnimation setTag:4];
        
        
        NSMutableArray *readyFrames = [NSMutableArray array];
        for (int i=1; i<=15; i++) {
            [readyFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"%@%d.png",@"playerIdle",(i)]]];
        }
        
        CCAnimation *readyAnim = [CCAnimation animationWithSpriteFrames:readyFrames delay:0.1f];
        //self.diveAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        
        self.readyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:readyAnim]];
        
        
        NSMutableArray *shootFrames = [NSMutableArray array];
        for (int i=1; i<=15; i++) {
            [shootFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"%@%d.png",@"playerKick",(i)]]];
        }
        
        CCAnimation *shootAnim = [CCAnimation animationWithSpriteFrames:shootFrames delay:0.1f];
        //self.diveAnimation = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]];
        
        self.kickAction = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:shootAnim] times:1];
        [self.kickAction setTag:5];
        
        
    }
    return self;
}

- (void)shoot
{
    if (self.sprite)
    {
        [self.sprite runAction:self.kickAction];
        int direction = -45;
        
        if (self.playerNumber == 2)
        {
            direction = direction*-1;
        }
        CGPoint exdPos = ccp(self.sprite.position.x, self.sprite.position.y-direction);
        if (self.playerNumber == 2)
        {
            exdPos.x -= 10;
        }
        [self.sprite stopAction:self.readyAction];
        ccBezierConfig bezier;
        bezier.controlPoint_1 =  ccp(exdPos.x, exdPos.y);
        bezier.controlPoint_2 = ccp(exdPos.x, exdPos.y);// ccp(self.sprite.position.x+10, self.sprite.position.y-direction+10);
        bezier.endPosition = exdPos;
//        [self.sprite runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1 position:ccp(self.sprite.position.x, self.sprite.position.y-direction)], nil]];
        [self.sprite runAction:[CCSequence actions:[CCBezierTo actionWithDuration:1 bezier:bezier], nil]];
    }
}

- (void)readyKicker:(BOOL)ready
{
    if (self.sprite)
    {
        if (ready == YES)
            [self.sprite runAction:self.readyAction];
        else
            [self.sprite stopAction:self.readyAction];
    }
}


- (void)save
{
    if (self.sprite && !([self.sprite getActionByTag:4]))
    {
        int direction = 1;
        int ydirection = 20;
        if (self.playerNumber == 2)
        {
            direction = direction * -1;
            ydirection *= -1;
        }
        CGPoint exdPos = ccp(self.sprite.position.x+direction, self.sprite.position.y+20);
        [self.sprite stopAction:self.breatheAnimation];
        [self.sprite runAction:[CCSequence actions:self.diveAnimation,nil]];
        ccBezierConfig bezier;
        bezier.controlPoint_1 = ccp(exdPos.x, exdPos.y-5);// ccp(self.sprite.position.x-20, self.sprite.position.y-direction-20);
        bezier.controlPoint_2 = ccp(exdPos.x+40, exdPos.y);// ccp(self.sprite.position.x+10, self.sprite.position.y-direction+10);
        bezier.endPosition = exdPos;
        [self.sprite runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:0.2 position:ccp(self.sprite.position.x-4*direction/2, self.sprite.position.y+12*direction/2)],
                                [CCMoveTo actionWithDuration:0.2 position:ccp(self.sprite.position.x-83*direction/2, self.sprite.position.y-7*direction/2)],
                                [CCMoveTo actionWithDuration:0.2 position:ccp(self.sprite.position.x-154*direction/2, self.sprite.position.y+78*direction/2)],
                                [CCMoveTo actionWithDuration:0.3 position:ccp(self.sprite.position.x-164*direction/2, self.sprite.position.y+90*direction/2)],nil]];
        //[self.sprite runAction:[CCSequence actions:[CCBezierTo actionWithDuration:1 bezier:bezier], nil]];
        
        //[self.sprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2],[CCMoveTo actionWithDuration:0.5 position:ccp(self.sprite.position.x+direction, self.sprite.position.y)],[CCBezierTo actionWithDuration:<#(ccTime)#> bezier:<#(ccBezierConfig)#>] nil]];
    }
}

- (void)roundResult:(NSNumber *)res
{
    [self.score addObject:res];
}

- (void)breathe:(BOOL)breathe
{
    if (self.sprite)
    {
        if (breathe == YES)
            [self.sprite runAction:self.breatheAnimation];
        else
            [self.sprite stopAction:self.breatheAnimation];
    }
}

- (void)jump
{
    if (self.sprite)
    {
        [self.sprite stopAction:self.breatheAnimation];
        [self.sprite runAction:[CCSequence actions:self.jumpAnimation,
                                [CCCallFuncO actionWithTarget:self.sprite selector:@selector(runAction:) object:self.breatheAnimation],nil]];
    }
}

- (void)setPlayerType:(ePlayerType)playerType
{
    self.currentType = playerType;
    if (playerType == kPlayerShooter)
    {
    }
    else if (playerType == kPlayerKeeper)
    {
    }
}

@end
