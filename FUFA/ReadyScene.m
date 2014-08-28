//
//  ReadyScene.m
//  FUFA
//
//  Created by Aatish Molasi on 5/17/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import "ReadyScene.h"
#import "HelloWorldLayer.h"


@interface ReadyScene()

- (void)dismissReadyButton:(CCNodeRGBA *)button;
- (void)readyPlayers;
- (void)startCountdown;
- (void)decideWinner;
- (void)transitionToOppositeEnd;

@property (nonatomic, retain)CCMenu *menu;
@property (nonatomic, retain)CCNode *readyButtonOne;
@property (nonatomic, retain)CCNode *readyButtonTwo;
@property (nonatomic, retain)CCMenuItemImage *shadowButtonOne;
@property (nonatomic, retain)CCMenuItemImage *shadowButtonTwo;
@property (nonatomic, retain)ScoreCard *scoreCardOne;
@property (nonatomic, retain)ScoreCard *scoreCardTwo;
@property (nonatomic, retain)CCSpriteBatchNode *playerOneSprite;
@property (nonatomic, retain)CCSpriteBatchNode *kicker;
@property (nonatomic, retain)CCLayerColor *background;
@property (nonatomic, retain)CCAction *diveAnimation;
@property (nonatomic, retain)NSMutableArray *cleanupSprites;
@property (nonatomic, retain)Player *playerOne;
@property (nonatomic, retain)Player *playerTwo;
@property (nonatomic) int round;
@property (nonatomic, retain)NSDate *startDate;
@property (nonatomic)eGameState gameState;

@end

@implementation ReadyScene

@synthesize field;
@synthesize menu = _menu;
@synthesize readyButtonOne = _readyButtonOne;
@synthesize readyButtonTwo = _readyButtonTwo;
@synthesize shadowButtonOne = _shadowButtonOne;
@synthesize shadowButtonTwo = _shadowButtonTwo;
@synthesize playerOneSprite = _playerOneSprite;
@synthesize scoreCardOne = _scoreCardOne;
@synthesize kicker = _kicker;
@synthesize diveAnimation = _diveAnimation;
@synthesize playerOne = _playerOne;
@synthesize playerTwo = _playerTwo;
@synthesize cleanupSprites = _cleanupSprites;
@synthesize round = _round;
@synthesize startDate = _startDate;
@synthesize gameState = _gameState;
@synthesize background = _background;

static int totalPlayers = 2;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    ReadyScene *layer = [ReadyScene node];
    [scene addChild: layer];
    return scene;
}

+(CCScene *)sceneWithPlayers:(NSInteger)players
{
    CCScene *scene = [CCScene node];
    ReadyScene *layer = [ReadyScene node];
    [scene addChild: layer];
    totalPlayers = players;
    return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init]) )
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.round = 0;
        self.cleanupSprites = [[NSMutableArray alloc] init];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"goalieDive.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"heavybreathe.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"jumpanimation.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"playerIdle.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"playerKick.plist"];
        
        self.playerOne = [[Player alloc] initWithPlayerNumber:1];
        self.playerTwo = [[Player alloc] initWithPlayerNumber:2];
        self.playerOne.currentType = kPlayerKeeper;
        self.playerTwo.currentType = kPlayerShooter;
        
        //Adding the field
        self.field = [CCSprite spriteWithFile:@"full_field.png"];
        self.field.anchorPoint = ccp(0.5, 0.5);

        self.field.position = ccp(size.width/2,(self.field.boundingBox.size.height/2));
        [self addChild:self.field];
        
        [self readyPlayers];
    }
    return self;
}

- (void)readyPlayers
{
    //Some basic initialization
    NSMutableArray *itemsArray = nil;
    self.round++;
    self.startDate = [NSDate date];
    self.gameState = kGameStateCountdown;
    for (CCSprite *sprite in self.cleanupSprites)
    {
        
        [sprite removeFromParent];
        [sprite cleanup];
    }
    [self.cleanupSprites removeAllObjects];
    float delay = ((self.round == 1)?1:0.2);
    float swipeIn = 0.3;
    int fadeIn = 1;
    NSMutableArray *holderArray = [[NSMutableArray alloc] init];
    
    self.playerOne.playerReady = NO;

    self.playerOne.time = NSIntegerMax;

    self.playerTwo.playerReady = NO;
    self.playerTwo.time = NSIntegerMax;

    self.touchEnabled = NO;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    //Player one button
    
    CGPoint finalPoint = ccp(size.width/2,self.readyButtonOne.boundingBox.size.height/2-self.position.y);
    CGPoint initialPoint = ccp(size.width/2,-self.readyButtonOne.boundingBox.size.height/2-self.position.y);
    if (self.round == 1 && false)
    {
        
        self.readyButtonOne = [CCMenuItemImage itemWithNormalImage:@"Button_Ready_P1_Normal.png"
                                                     selectedImage:@"Button_Ready_P1_Pressed.png" target:self selector:@selector(dismissReadyButton:)];
        finalPoint = ccp(size.width/2,self.readyButtonOne.boundingBox.size.height/2-self.position.y);
        initialPoint = ccp(size.width/2,-self.readyButtonOne.boundingBox.size.height/2-self.position.y);

        itemsArray = [NSMutableArray arrayWithObjects:self.shadowButtonOne, self.shadowButtonTwo, self.readyButtonTwo,self.readyButtonOne, nil];
    }
    else
    {
//        self.readyButtonOne = [CCMenuItemImage itemWithNormalImage:@"Base_P1.png"
//                                                     selectedImage:@"Base_P1.png" target:self selector:@selector(dismissReadyButton:)];
        self.readyButtonOne = [ScoreCard itemWithTarget:self selector:@selector(dismissReadyButton:) player:self.playerOne turn:self.round];
        itemsArray = [NSMutableArray arrayWithObjects:self.shadowButtonOne, self.shadowButtonTwo,nil];
        
        
        finalPoint = ccp(size.width/2,0-self.position.y);
        initialPoint = ccp(size.width/2,0-115-self.position.y);
        [(ScoreCard*)self.readyButtonOne updateScorePlayerOne:self.playerTwo.score playerTwo:self.playerOne.score];
    }
    [(CCNodeRGBA *)self.readyButtonOne setOpacity:0];
    self.readyButtonOne.anchorPoint = ccp(0.5, 0.5);

    
    self.shadowButtonOne = [CCMenuItemImage itemWithNormalImage:@"Overlay_P1.png"
                                                 selectedImage:@"Overlay_P1.png" target:nil selector:nil];
    self.shadowButtonOne.opacity = 0;
    self.shadowButtonOne.anchorPoint = ccp(0.5, 0.5);
    self.shadowButtonOne.isEnabled = NO;
    
    self.shadowButtonTwo = [CCMenuItemImage itemWithNormalImage:@"Overlay_P2.png"
                                                  selectedImage:@"Overlay_P2.png" target:nil selector:nil];
    self.shadowButtonTwo.opacity = 0;
    self.shadowButtonTwo.anchorPoint = ccp(0.5, 0.5);
    self.shadowButtonTwo.isEnabled = NO;
    
    self.readyButtonOne.position = initialPoint;
    self.shadowButtonOne.position = finalPoint;
    
    [self.readyButtonOne runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],[CCFadeIn actionWithDuration:0.1],[CCMoveTo actionWithDuration:swipeIn position:finalPoint], nil]];
    [self.shadowButtonOne runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],[CCFadeIn actionWithDuration:fadeIn], nil]];
    
    //Player two button
    
    CGPoint finalPointTwo = ccp(size.width/2,size.height-self.readyButtonTwo.boundingBox.size.height/2-self.position.y);
    CGPoint initialPointTwo = ccp(size.width/2,size.height+self.readyButtonTwo.boundingBox.size.height/2-self.position.y);
    if(self.round == 1 && false)
    {
        self.readyButtonTwo = [CCMenuItemImage itemWithNormalImage:@"Button_Ready_P2_Normal.png"
                                                  selectedImage:@"Button_Ready_P2_Pressed.png" target:self selector:@selector(dismissReadyButton:)];
        itemsArray = [NSMutableArray arrayWithObjects:self.shadowButtonOne, self.shadowButtonTwo, self.readyButtonTwo,self.readyButtonOne, nil];
        finalPointTwo = ccp(size.width/2,size.height-self.readyButtonTwo.boundingBox.size.height/2-self.position.y);
        initialPointTwo = ccp(size.width/2,size.height+self.readyButtonTwo.boundingBox.size.height/2-self.position.y);
        
    }
    else
    {
        self.readyButtonTwo = [ScoreCard itemWithTarget:self selector:@selector(dismissReadyButton:) player:self.playerTwo turn:self.round];
        itemsArray = [NSMutableArray arrayWithObjects:self.shadowButtonOne, self.shadowButtonTwo,nil];
        
        finalPointTwo = ccp(size.width/2,size.height-self.position.y);
        initialPointTwo = ccp(size.width/2,size.height+115-self.position.y);
        [(ScoreCard*)self.readyButtonTwo updateScorePlayerOne:self.playerOne.score playerTwo:self.playerTwo.score];

    }
    self.readyButtonTwo.position = initialPointTwo;
    self.shadowButtonTwo.position = finalPointTwo;
    self.readyButtonTwo.anchorPoint = ccp(0.5, 0.5);
    [(CCNodeRGBA *)self.readyButtonTwo setOpacity:0];
    [self.readyButtonTwo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],[CCFadeIn actionWithDuration:0.1],[CCMoveTo actionWithDuration:swipeIn position:finalPointTwo], nil]];
    [self.shadowButtonTwo runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay],[CCFadeIn actionWithDuration:fadeIn], nil]];
    

    [holderArray insertObjects:itemsArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [itemsArray count])]];
    //self.menu = [CCMenu menuWithItems:];
    self.menu = [CCMenu menuWithArray:holderArray];
    self.menu.enabled = YES;
    self.menu.position = CGPointZero;
    
    [self addChild: self.menu];
    
    if (self.round != 1 || true)
    {
        [self addChild:self.readyButtonOne];
        [self addChild:self.readyButtonTwo];
    }
//    [self.playerTwo.sprite cleanup];
    [self.playerTwo.sprite removeFromParentAndCleanup:YES];
    self.playerTwo.sprite = nil;
    [self.playerOne.sprite removeFromParentAndCleanup:YES];
    self.playerOne.sprite = nil;
    
    CCSprite *keeper = [CCSprite spriteWithSpriteFrameName:@"Heavybreathe1001.png"];
    CCSprite *shooter = [CCSprite spriteWithSpriteFrameName:@"playerIdle1.png"];
    CGPoint pos,pos2;
    if (self.playerTwo.currentType == kPlayerKeeper)
    {
        shooter.rotation = 180;
        pos = ccp(+self.field.boundingBox.size.width/2, self.readyButtonTwo.boundingBox.origin.y-200);
        pos2 = ccp(+self.field.boundingBox.size.width/2-10, self.readyButtonOne.boundingBox.origin.y+200);
        self.playerTwo.sprite = keeper;
        self.playerOne.sprite = shooter;
        [self.playerTwo breathe:YES];
        [self.playerOne readyKicker:YES];
    }
    else
    {
        keeper.rotation = 180;
        pos = ccp(+self.field.boundingBox.size.width/2, self.readyButtonOne.boundingBox.origin.y+200);
        pos2 = ccp(+self.field.boundingBox.size.width/2+10, self.readyButtonTwo.boundingBox.origin.y-200);
        self.playerOne.sprite = keeper;
        self.playerTwo.sprite = shooter;
        [self.playerOne breathe:YES];
        [self.playerTwo readyKicker:YES];
    }
    keeper.position = pos;
    shooter.position = pos2;
    [self.field addChild:keeper];
    [self.field addChild:shooter];
}


- (void)dismissReadyButton:(CCNodeRGBA *)button
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint finalPoint = CGPointZero;
    if ([button isEqual:self.readyButtonOne])
    {
        finalPoint = ccp(size.width/2,-self.readyButtonOne.boundingBox.size.height/2-self.position.y);
        self.playerOne.playerReady = YES;
    }
    else if([button isEqual:self.readyButtonTwo])
    {
        finalPoint = ccp(size.width/2,size.height+self.readyButtonTwo.boundingBox.size.height/2-self.position.y);
        self.playerTwo.playerReady = YES;
    }
    else if ([button tag] == 1)
    {
        finalPoint = ccp(size.width/2,0-115-self.position.y);
        self.playerOne.playerReady = YES;
        button = (CCNodeRGBA*)[button parent];
    }
    else if ([button tag] == 2)
    {
        finalPoint = ccp(size.width/2,size.height+115-self.position.y);
        self.playerTwo.playerReady = YES;
        button = (CCNodeRGBA*)[button parent];
        
    }
    [button runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3 position:finalPoint],[CCCallFuncND actionWithTarget:self selector:@selector(cleanup:) data:button], nil]];
    if (self.playerOne.playerReady == YES && self.playerTwo.playerReady == YES)
    {
        [self startCountdown];
    }
}

- (void)transitionToOppositeEnd
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    float y = (size.height - self.field.boundingBox.size.height);
    
    CCSprite *keeper = [CCSprite spriteWithSpriteFrameName:@"Heavybreathe1001.png"];
    CCSprite *shooter = [CCSprite spriteWithSpriteFrameName:@"playerIdle1.png"];
    CGPoint pos,pos2;
    if (self.playerTwo.currentType == kPlayerKeeper)
    {
        y = y*-1;
        keeper.rotation = 180;
        pos = ccp(+self.field.boundingBox.size.width/2+10, self.readyButtonTwo.boundingBox.origin.y-200-y);
        pos2 = ccp(+self.field.boundingBox.size.width/2, self.readyButtonOne.boundingBox.origin.y-200-y);

//        self.playerOne.sprite = keeper;
//        self.playerTwo.sprite = shooter;
//        [self.playerTwo breathe:YES];
//        [self.playerOne readyKicker:YES];
    }
    else
    {
        shooter.rotation = 180;
        pos = ccp(+self.field.boundingBox.size.width/2-10, self.readyButtonOne.boundingBox.origin.y+200-y);
        pos2 = ccp(+self.field.boundingBox.size.width/2, self.readyButtonTwo.boundingBox.origin.y-200-y);
        
//        [self.playerOne breathe:YES];
//        [self.playerTwo readyKicker:YES];
    }
    [self.cleanupSprites addObject:keeper];
    [self.cleanupSprites addObject:shooter];
    keeper.position = pos2;
    shooter.position = pos;
    [self.field addChild:keeper];
    [self.field addChild:shooter];
    
    self.touchEnabled = NO;
    
    if (self.round == 3)
    {
        NSLog(@"We have to do something here!");
        [self showfinalScore:self];
        return;
    }
    if (self.round%2 == 0)
    {
        y = 0;
        self.playerOne.currentType = kPlayerKeeper;
        self.playerTwo.currentType = kPlayerShooter;
    }
    else
    {
        self.playerOne.currentType = kPlayerShooter;
        self.playerTwo.currentType = kPlayerKeeper;
    }
    CGPoint newPosition = ccp(0,y);
    [self runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.6 position:newPosition],
                     [CCCallFunc actionWithTarget:self selector:@selector(readyPlayers)],
                     nil]];
}

- (void)setupNextRound
{
    
}

- (void)startCountdown
{
    self.touchEnabled = YES;
    if (self.playerTwo.currentType == kPlayerKeeper)
    {
        [self.playerTwo jump];
    }
    else
    {
        [self.playerOne jump];
    }
    NSLog(@"It's the final countdown!");
    NSMutableArray *countdownArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1], nil];
    [self.shadowButtonOne runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5], nil]];
    [self.shadowButtonTwo runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.5], nil]];
    int randomDelay = 1+arc4random()%4;
    NSLog(@"This is the random number : %d",randomDelay);
    [countdownArray addObject:[NSNumber numberWithInt:randomDelay]];
    int totalCount = 0;
    for (int i=[countdownArray count]-1; i>=0; i--)
    {
        NSNumber *delay = [countdownArray objectAtIndex:[countdownArray count]-i-1];
        totalCount = totalCount+[delay intValue];
        [self performSelector:@selector(displayCount:) withObject:[NSNumber numberWithInt:i] afterDelay:totalCount];
    }
}

- (void)displayCount:(NSNumber *)count
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    NSString *fileName = [NSString stringWithFormat:@"%d%@",[count intValue],@".png"];
    CCSprite *countSprite = [CCSprite spriteWithFile:fileName];
    //countSprite.scale = 0.5;
    countSprite.opacity = 0;
    countSprite.position = ccp(size.width/2, size.height/2-self.position.y);
    [self addChild:countSprite];

    
    //This is when we 'GO'
    if ([count intValue] == 0)
    {
        self.gameState = kGameStateStart;
        self.startDate = [NSDate date];
        [self performSelector:@selector(kickBall:) withObject:nil afterDelay:2];
        [self cleanup:self.menu];
//        [self.menu release];
        [countSprite runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.2],
                                [CCDelayTime actionWithDuration:0.3],
                                [CCDelayTime actionWithDuration:0.3],
                                [CCFadeOut actionWithDuration:0.2],
                                [CCCallFuncND actionWithTarget:self selector:@selector(cleanup:) data:countSprite],
                                nil]];
        
    }
    else
    {
        [countSprite runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.2],
                                [CCDelayTime actionWithDuration:0.3],
                                [CCRotateTo actionWithDuration:0.2 angle:180],
                                [CCDelayTime actionWithDuration:0.3],
                                [CCFadeOut actionWithDuration:0.2],
                                [CCCallFuncND actionWithTarget:self selector:@selector(cleanup:) data:countSprite],
                                nil]];
    }
}

- (void)kickBall:(id)success
{
    [self performSelector:@selector(decideWinner) withObject:nil afterDelay:2];
}

- (void)decideWinner
{
    self.touchEnabled = NO;
    NSString *resultString = @"..";
    NSLog(@"Comparing : %f and %f",self.playerOne.time,self.playerTwo.time);
    if (self.playerOne.time == -1)
    {
        self.playerOne.time = NSIntegerMax;
    }
    if (self.playerTwo.time == -1)
    {
        self.playerTwo.time = NSIntegerMax;
    }
    if ((self.playerOne.time < self.playerTwo.time) && self.playerOne.time != -1)
    {
        resultString = @"Player One WINS!!";
        if (self.playerOne.currentType == kPlayerShooter)
            [self.playerOne roundResult:[NSNumber numberWithInt:1]];
        else
            [self.playerTwo roundResult:[NSNumber numberWithInt:-1]];
    }
    else if (self.playerOne.time > self.playerTwo.time)
    {
        resultString = @"Player Two WINS!!";
        if (self.playerTwo.currentType == kPlayerShooter)
            [self.playerTwo roundResult:[NSNumber numberWithInt:1]];
        else
            [self.playerOne roundResult:[NSNumber numberWithInt:-1]];
    }
    else
    {
        if (self.playerOne.currentType == kPlayerShooter)
        {
            resultString = @"Player Two WINS!!";
            [self.playerOne roundResult:[NSNumber numberWithInt:-1]];
        }
        else
        {
            resultString = @"Player One WINS!!";
            [self.playerTwo roundResult:[NSNumber numberWithInt:-1]];
        }
    }
    CCLabelTTF *label = [CCLabelTTF labelWithString:resultString fontName:@"Marker Felt" fontSize:64];
    CGSize size = [[CCDirector sharedDirector] winSize];
    label.position =  ccp( size.width /2 , size.height/2 -self.position.y);
    [self addChild:label];
    [label runAction:[CCFadeTo actionWithDuration:1.9 opacity:0.0f]];
    [label runAction:[CCSequence actions:[CCFadeTo actionWithDuration:1.9 opacity:0.0f],
                      [CCCallFuncND actionWithTarget:self selector:@selector(cleanup:) data:label],
                      [CCCallFunc actionWithTarget:self selector:@selector(transitionToOppositeEnd)],
                      nil]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
//    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval touchTime = [currentDate timeIntervalSinceDate:self.startDate];
    if (location.y < size.height/2)
    {
        if (self.gameState == kGameStateCountdown)
        {
            self.playerOne.time = -1;
            if (self.playerOne.currentType == kPlayerKeeper)
            {
                [self.playerOne save];
                [self.playerTwo shoot];
            }
        }
        if (touchTime < self.playerOne.time && self.playerOne.time != -1)
        {
            self.playerOne.time = touchTime;
            if (touchTime < self.playerOne.time)
            {
                self.playerOne.time = touchTime;
            }
            if (self.playerOne.currentType == kPlayerKeeper)
            {
                [self.playerOne save];
                [self.playerTwo shoot];
            }
        }
    }
    else
    {
        if (self.playerTwo.currentType == kPlayerKeeper)
        {
            [self.playerTwo save];
            [self.playerOne shoot];
        }
        if (self.gameState == kGameStateCountdown)
        {
            self.playerTwo.time = -1;
        }
        if (touchTime < self.playerTwo.time && self.playerTwo.time != -1)
        {
            self.playerTwo.time = touchTime;
            if (touchTime < self.playerTwo.minTime)
            {
                self.playerTwo.minTime = touchTime;
            }
            NSLog(@"We are entering here");
        }
    }
    NSLog(@"We be touching in location : %@",NSStringFromCGPoint(location));
}


- (void)tapReady:(id)sender
{
    NSLog(@"%d",[(CCMenuItemImage *)sender tag]);
    [self dismissReadyButton:sender];
}

- (void)tapInfo:(id)sender
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    int tag = [sender tag];
    float animationDuration = 0.4;
    CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
    InfoLayer *infolayer;
    if (tag == 1)
    {
        infolayer = [[InfoLayer alloc] initWithColor:ccc4(0, 0, 0, 0) withPlayer:self.playerOne];
        
        infolayer.position = ccp(0, -size.height-self.position.y);
    }
    else
    {
        infolayer = [[InfoLayer alloc] initWithColor:ccc4(0, 0, 0, 0) withPlayer:self.playerTwo];
        infolayer.position = ccp(0, size.height-self.position.y);
        infolayer.rotation = 180;
    }
//    infolayer.position = ccp(0, 0-self.position.y);
    self.background = background;
    [self addChild:background];
    [self addChild:infolayer];
    [background runAction:[CCFadeTo actionWithDuration:animationDuration opacity:150]];
    [infolayer runAction:[CCMoveTo actionWithDuration:animationDuration position:ccp(0, 0-self.position.y)]];
    [infolayer release];
}

- (void)dismissBackground
{
    [self.background runAction:[CCFadeOut actionWithDuration:0.3]];
}

- (void)gotoMainMenu
{
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeDown transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
}

- (void)showfinalScore:(id)sender
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    int tag = [sender tag];
    EndgameLayer *endLayer;
    if (tag == 1 || true)
    {
        endLayer = [[EndgameLayer alloc] initWithColor:ccc4(0, 0, 0, 150) withPlayer:self.playerOne withOtherPlayer:self.playerTwo];
        endLayer.position = ccp(0, -size.height-self.position.y);
    }
    else
    {
        endLayer = [[EndgameLayer alloc] initWithColor:ccc4(0, 0, 0, 150) withPlayer:self.playerTwo withOtherPlayer:self.playerOne];
        endLayer.position = ccp(0, size.height-self.position.y);
        endLayer.rotation = 180;
    }
    [self addChild:endLayer];
    self.background = endLayer;
    [endLayer runAction:[CCMoveTo actionWithDuration:0.3 position:ccp(0, 0-self.position.y)]];
    [endLayer release];
}

- (void)tapDetails:(id)sender
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    int tag = [sender tag];
    CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
    Player *p = self.playerTwo;
    if (tag == 2)
    {
        p = self.playerOne;
    }
    EndgameLayer *infolayer = [[EndgameLayer alloc] initWithColor:ccc4(0, 0, 0, 100) withPlayer:p withOtherPlayer:self.playerTwo];
    if (tag == 1)
    {
        infolayer.position = ccp(0, -size.height-self.position.y);
    }
    else
    {
        infolayer.position = ccp(0, size.height-self.position.y);
        infolayer.rotation = 180;
    }
    [self addChild:background];
    [self addChild:infolayer];
    [background runAction:[CCFadeTo actionWithDuration:0.3 opacity:150]];
    [infolayer runAction:[CCMoveTo actionWithDuration:0.3 position:ccp(0, 0-self.position.y)]];
    [infolayer release];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    
    // don't forget to call "super dealloc"
    [super dealloc];
}


- (void)cleanup:(CCNode *)node
{
    [node.parent removeChild:node cleanup:YES];
//    node = nil;
}

#pragma mark GameKit delegate



@end
