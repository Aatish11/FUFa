//
//  ScoreCard.m
//  FUFA
//
//  Created by Aatish Molasi on 5/25/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import "ScoreCard.h"


@interface ScoreCard ()

@property (nonatomic, retain)Player *player;

@end

@implementation ScoreCard

@synthesize player = _player;

+(id) itemWithTarget:(id)target selector:(SEL)selector player:(Player *)player turn:(int)turn
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCMenuItemImage *readyButton = nil;
    CCMenuItemImage *infoImage = nil;
    CCMenuItemImage *detailImage = nil;
    CCMenuItemImage *readyImage = nil;
    CCMenuItemImage *seperator = nil;
    CCMenuItemLabel *teamOne;
    CCMenuItemLabel *teamTwo;
    CCLabelTTF *label = nil;
    CCLabelTTF *labelTwo = nil;
    
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
    
    int offsety = 12;
    
    if (player.playerNumber == 1)
    {
        readyButton = [CCMenuItemImage itemWithNormalImage:@"Base_P1.png"
                                             selectedImage:@"Base_P1.png" target:nil selector:nil];
        readyButton.position = ccp(0, readyButton.boundingBox.size.height/2);
        
        infoImage = [CCMenuItemImage itemWithNormalImage:@"Button_Info_P1_Normal.png"
                                                            selectedImage:@"Button_Info_P1_Pressed.png" target:target selector:@selector(tapInfo:)];
        infoImage.position = ccp(size.width/2-infoImage.boundingBox.size.width/2-25, infoImage.boundingBox.size.height/2+offsety);
        
        detailImage = [CCMenuItemImage itemWithNormalImage:@"Button_Menu_P1_Normal.png"
                                           selectedImage:@"Button_Menu_P1_Pressed.png" target:target selector:@selector(tapDetails:)];
        detailImage.position = ccp(-size.width/2+infoImage.boundingBox.size.width/2+25, infoImage.boundingBox.size.height/2+offsety);
        
        readyImage = [CCMenuItemImage itemWithNormalImage:@"Button_next_normal_P1.png"
                                             selectedImage:@"Button_next_pressed_P1.png" target:target selector:@selector(tapReady:)];
        CGPoint pos = ccp(size.width/2-readyImage.boundingBox.size.width/2-8, infoImage.boundingBox.size.height/2+67);
        readyImage.position = pos;
        
        teamOne.position = ccp(detailImage.boundingBox.origin.x+detailImage.boundingBox.size.width+40, detailImage.boundingBox.origin.y+28);
        teamTwo.position = ccp(teamOne.boundingBox.origin.x+teamOne.boundingBox.size.width/2, teamOne.boundingBox.origin.y-teamOne.boundingBox.size.height/2-4);
        seperator.position = ccp(detailImage.boundingBox.origin.x+detailImage.boundingBox.size.width+100, teamOne.position.y-teamOne.boundingBox.size.height/2-2);
    }
    else if (player.playerNumber == 2)
    {
        readyButton = [CCMenuItemImage itemWithNormalImage:@"Base_P2.png"
                                                                 selectedImage:@"Base_P2.png" target:nil selector:nil];
        readyButton.position = ccp(0, -readyButton.boundingBox.size.height/2);
        
        infoImage = [CCMenuItemImage itemWithNormalImage:@"Button_Info_P2_Normal.png"
                                           selectedImage:@"Button_Info_P2_Pressed.png" target:target selector:@selector(tapInfo:)];
        infoImage.position = ccp(size.width/2-infoImage.boundingBox.size.width/2-25, -infoImage.boundingBox.size.height/2-offsety);
        
        detailImage = [CCMenuItemImage itemWithNormalImage:@"Button_Menu_P1_Normal.png"
                                             selectedImage:@"Button_Menu_P1_Pressed.png" target:target selector:@selector(tapDetails:)];
        detailImage.position = ccp(-size.width/2+infoImage.boundingBox.size.width/2+25, -infoImage.boundingBox.size.height/2-offsety);
        
        readyImage = [CCMenuItemImage itemWithNormalImage:@"Button_next_normal_P1.png"
                                            selectedImage:@"Button_next_pressed_P1.png" target:target selector:@selector(tapReady:)];
        readyImage.position = ccp(size.width/2-readyImage.boundingBox.size.width/2-8, -infoImage.boundingBox.size.height/2-67);
    
        teamOne.rotation = 180;
        teamTwo.rotation = 180;
        
        teamOne.position = ccp(infoImage.boundingBox.origin.x-infoImage.boundingBox.size.width, infoImage.boundingBox.origin.y+32);
        teamTwo.position = ccp(teamOne.boundingBox.origin.x+teamOne.boundingBox.size.width/2, teamOne.boundingBox.origin.y-teamOne.boundingBox.size.height/2-4);
        seperator.position = ccp(detailImage.boundingBox.origin.x+detailImage.boundingBox.size.width+90, teamOne.position.y-teamOne.boundingBox.size.height/2-2);
    }
    
    
    infoImage.tag = player.playerNumber;
    detailImage.tag = player.playerNumber;
    readyImage.tag = player.playerNumber;
    
    [readyButton setIsEnabled:NO];
    ScoreCard *item = [ScoreCard menuWithItems:readyButton,readyImage,detailImage,infoImage,teamOne,teamTwo,seperator, nil];
    item.player = player;
    item.enabled = YES;

    return item;
}

- (void)updateScorePlayerOne:(NSMutableArray *)scoreOne playerTwo:(NSMutableArray *)scoreTwo
{
    int counter;
    CCMenuItemLabel *teamOne= nil;
    CCMenuItemLabel *teamTwo = nil;
    int offset = 20;
    int initialOffset = 20;
    for (CCMenuItem *item in [self children])
    {
        if (item.tag == 100)
            teamOne = (CCMenuItemLabel *)item;
        else if (item.tag == 101)
            teamTwo = (CCMenuItemLabel *)item;
    }
    for (int i=0; i<2; i++)
    {
        CCMenuItemLabel *current;
        NSMutableArray *curretArray;
        if (i==0)
        {
            current = teamOne;
            curretArray = scoreOne;
        }
        else
        {
            current = teamTwo;
            curretArray = scoreTwo;
        }
        for (counter=1; counter<6; counter++)
        {
            float xSpot;
            if (self.player.playerNumber == 1)
            {
                xSpot= teamOne.boundingBox.origin.x+teamOne.boundingBox.size.width/2+(offset*counter)+initialOffset;
            }
            else
            {
                initialOffset = 0;
                xSpot= teamOne.boundingBox.origin.x-teamOne.boundingBox.size.width/2-(offset*counter)-initialOffset;
            }
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
}

@end
