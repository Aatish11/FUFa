//
//  InfoLayer.m
//  FUFA
//
//  Created by Aatish Molasi on 6/7/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import "InfoLayer.h"
#import "ReadyScene.h"


@implementation InfoLayer

@synthesize delegate = _delegate;

- (id)initWithColor:(ccColor4B)color withPlayer:(Player *)player
{
    self = [super initWithColor:color];
    //CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLayerColor *base = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 0)];
    [self addChild:base];
    
    
    CCLayerColor *blackBackground = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0,225)];
    blackBackground.position = ccp(0, 0);
    blackBackground.contentSize = CGSizeMake(self.boundingBox.size.width, self.boundingBox.size.height/2);
    [base addChild:blackBackground];
//
//    CCLayerColor *blackBackground2 = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0,225)];
//    blackBackground2.position = ccp(0, 0);
//    blackBackground2.contentSize = CGSizeMake(self.boundingBox.size.width, self.boundingBox.size.height/2);
//    [base addChild:blackBackground2];
    
    CCSprite *orangeLine = [CCSprite spriteWithFile:@"Orange_line.png"];
    orangeLine.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [base addChild:orangeLine];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap anywhere below the orange line as soon as you hear the whistle or see 'Go'.\n\n Just make sure you are faster than your opponent. But tap too early and you will miss" fontName:@"Marker Felt" fontSize:20 dimensions:CGSizeMake(250, blackBackground.boundingBox.size.height-150) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    label.position = ccp(orangeLine.position.x, orangeLine.position.y-100);
    [base addChild:label];
    
    CCMenuItem *ok = [CCMenuItemImage itemWithNormalImage:@"Button_OkGotIt_P1_Normal.png" selectedImage:@"Button_OkGotIt_P1_Pressed.png" block:^(id sender){
        int tra = -blackBackground.boundingBox.size.height;
        if (player.playerNumber == 2)
        {
            tra = blackBackground.boundingBox.size.height;
        }
        [self runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3 position:ccp(self.position.x, tra)],[CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)], nil]];
        [(ReadyScene*)[self parent] dismissBackground];
    }];
    ok.position = ccp(orangeLine.boundingBox.size.width/2, ok.boundingBox.size.height);
    
    CCMenu *menu = [CCMenu menuWithItems:ok, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    [blackBackground release];
    return self;
}

@end
