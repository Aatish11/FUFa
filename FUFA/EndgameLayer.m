//
//  EndgameLayer.m
//  FUFA
//
//  Created by Aatish Molasi on 6/8/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import "EndgameLayer.h"
#import "ReadyScene.h"


@implementation EndgameLayer


- (id)initWithColor:(ccColor4B)color withPlayer:(Player *)player withOtherPlayer:(Player *)playerTwo
{
    self = [super initWithColor:color];
    
    CCSprite *replayBase = [CCSprite spriteWithFile:@"Base_P1.png"];
    replayBase.position = ccp(self.position.x+self.boundingBox.size.width/2,replayBase.boundingBox.size.height/2);
    [self addChild:replayBase];
    float finalTime = player.minTime;
    if (playerTwo.minTime < player.minTime)
    {
        finalTime = playerTwo.minTime;
    }
    CCMenuItemImage *facebookButton = [CCMenuItemImage itemWithNormalImage:@"btn_facebook_normal.png" selectedImage:@"btn_facebook_pressed.png" block:^(id sender){
        
    }];
    CCMenuItemImage *twitterButton = [CCMenuItemImage itemWithNormalImage:@"btn_twitter_normal.png" selectedImage:@"btn_twitter_pressed.png" block:^(id sender){
        
    }];
    CCMenuItemImage *googlePlus = [CCMenuItemImage itemWithNormalImage:@"btn_google+_normal.png" selectedImage:@"btn_google+_pressed.png" block:^(id sender){
        
    }];
    CCMenuItemImage *pinterestButton = [CCMenuItemImage itemWithNormalImage:@"btn_path_normal.png" selectedImage:@"btn_path_pressed.png" block:^(id sender){
        
    }];
    
    facebookButton.position = ccp(facebookButton.boundingBox.size.width, replayBase.position.y-25);
    twitterButton.position = ccp(facebookButton.boundingBox.size.width*2+20, replayBase.position.y-25);
    googlePlus.position = ccp(facebookButton.boundingBox.size.width*3+40, replayBase.position.y-25);
    pinterestButton.position = ccp(facebookButton.boundingBox.size.width*4+60, replayBase.position.y-25);
    
//    [self addChild:facebookButton];
//    [self addChild:twitterButton];
//    [self addChild:googlePlus];
//    [self addChild:pinterestButton];
    
    
    CCMenuItem *close = [CCMenuItemImage itemWithNormalImage:@"btn_close_pressed.png" selectedImage:@"btn_close_pressed.png" block:^(id sender){
        [(ReadyScene *)[self parent] dismissBackground];
    }];
    close.position = ccp(30,self.boundingBox.size.height-30);
    //[self addChild:close];
    CCLabelTTF *labelWin = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ wins",player.teamName] fontName:@"Marker Felt" fontSize:60];
    
    labelWin.position = ccp(self.position.x+self.boundingBox.size.width/2, self.boundingBox.size.height-110);
    [self addChild:labelWin];

    CCLabelTTF *time = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Fastest goal: %.03fs",finalTime] fontName:@"Marker Felt" fontSize:20];
    time.color = ccc3(126, 176, 8);
    time.position = ccp(labelWin.position.x, labelWin.position.y-50);
    [self addChild:time];
    
    CCSprite *winner = [CCSprite spriteWithSpriteFrameName:@"Heavybreathe1001.png"];
    winner.position = ccp(self.boundingBox.size.width/2, time.boundingBox.origin.y - time.boundingBox.size.height-35);
    [self addChild:winner];
    
//    CCMenuItem *replay = [CCMenuItemImage itemWithNormalImage:@"Button_Replay_P1_Normal.png" selectedImage:@"Button_Replay_P1_Pressed.png" block:^(id sender){
//        //        [self runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.3],[CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)], nil]];
//        [self removeFromParent];
//    }];
//    replay.position = ccp(size.width/2, size.height/2 + replay.boundingBox.size.height);
//
//    CCMenuItem *exit = [CCMenuItemImage itemWithNormalImage:@"Button_Quit_P1_Normal.png" selectedImage:@"Button_Quit_P1_Pressed.png" block:^(id sender){
//        //        [self runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.3],[CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)], nil]];
//        [self removeFromParent];
//    }];
//    exit.position = ccp(size.width/2, size.height/2 - replay.boundingBox.size.height);
//    
//    
    CCMenu *menu = [CCMenu menuWithItems:close,facebookButton,twitterButton,googlePlus,pinterestButton, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
//
    CCLabelTTF *label = nil;
    CCLabelTTF *labelTwo = nil;
    CCMenuItemImage *seperator = nil;
    CCMenuItemLabel *teamOne;
    CCMenuItemLabel *teamTwo;
    
    seperator = [CCMenuItemImage itemWithNormalImage:@"Seperator.png"
                                       selectedImage:@"Seperator.png" target:nil selector:nil];
    if (player.playerNumber == 1)
    {
        label = [CCLabelTTF labelWithString:@"ESP" fontName:@"Marker Felt" fontSize:16];
        labelTwo = [CCLabelTTF labelWithString:@"BRA" fontName:@"Marker Felt" fontSize:16];
    }
    else
    {
        label = [CCLabelTTF labelWithString:@"BRA" fontName:@"Marker Felt" fontSize:16];
        labelTwo = [CCLabelTTF labelWithString:@"ESP" fontName:@"Marker Felt" fontSize:16];
    }
    
    teamOne = [CCMenuItemLabel itemWithLabel:label];
    teamOne.tag = 100;
    
    teamTwo = [CCMenuItemLabel itemWithLabel:labelTwo];
    teamTwo.tag = 101;
    
    
    teamOne.position = ccp(labelWin.position.x-60, winner.position.y-100);
    teamTwo.position = ccp(teamOne.boundingBox.origin.x+teamOne.boundingBox.size.width/2, teamOne.boundingBox.origin.y-teamOne.boundingBox.size.height/2-4);
    seperator.position = ccp(labelWin.position.x, teamOne.position.y-teamOne.boundingBox.size.height/2-2);
    
    [self addChild:teamOne];
    [self addChild:teamTwo];
    [self addChild:seperator];
    int counter;
    NSMutableArray *scoreOne = player.score;
    NSMutableArray *scoreTwo = playerTwo.score;
    int offset = 20;
    int initialOffset = 20;

    for (int i=0; i<2; i++)
    {
        CCMenuItemLabel *current;
        NSMutableArray *curretArray;
//        float ySpot = self.boundingBox.origin.y+self.boundingBox.size.height/2;
        if (i==0)
        {
            current = teamOne;
            curretArray = scoreOne;
        }
        else
        {
            current = teamTwo;
            curretArray = scoreTwo;
//            ySpot = ySpot+20;
        }
        for (counter=1; counter<6; counter++)
        {
            float xSpot;
            xSpot= teamOne.boundingBox.origin.x+teamOne.boundingBox.size.width/2+(offset*counter)+initialOffset;

            CCMenuItemImage *blob = nil;
            if (counter > [curretArray count])
            {
                blob = [CCMenuItemImage itemWithNormalImage:@"Shot_Normal_P1.png" selectedImage:@"Shot_Normal_P1.png"];
            }
            else
            {
                if ([[curretArray objectAtIndex:counter-1] intValue] == 1)
                {
                    blob = [CCMenuItemImage itemWithNormalImage:@"Shot_Goal_P1.png" selectedImage:@"Shot_Normal_P1.png"];
                }
                else
                {
                    blob = [CCMenuItemImage itemWithNormalImage:@"Shot_miss_P1.png" selectedImage:@"Shot_Normal_P1.png"];
                }
            }
            blob.position = ccp(xSpot, current.boundingBox.origin.y+current.boundingBox.size.height/2);
            [self addChild:blob];
        }
    }
    
    return self;
}


@end
