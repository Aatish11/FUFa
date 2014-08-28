//
//  SettingsLayer.m
//  FUFA
//
//  Created by Aatish Molasi on 6/8/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import "SettingsLayer.h"
#import "ReadyScene.h"


@interface SettingsLayer()

@property (nonatomic, retain)UISlider *slider1;
@property (nonatomic, retain)UISlider *slider2;

@end

@implementation SettingsLayer

@synthesize slider1;
@synthesize slider2;

- (id)initWithColor:(ccColor4B)color forPlayer:(Player *)player
{
    self = [super initWithColor:color];
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCMenuItem *close = [CCMenuItemImage itemWithNormalImage:@"Button_Close_Pressed.png" selectedImage:@"Button_Close_Pressed.png" block:^(id sender){
        [(ReadyScene *)[self parent] dismissBackground];
    }];
    close.position = ccp(10,10);

    
    CCSprite *orangeBackground = [CCSprite spriteWithFile:@"base.png"];
    orangeBackground.position = ccp(self.contentSize.width/2, orangeBackground.boundingBox.size.height/2);
    [self addChild:orangeBackground];

    CCSprite *settingsText = [CCSprite spriteWithFile:@"header.png"];
    settingsText.position = ccp(self.contentSize.width/2, size.height - settingsText.boundingBox.size.height/2-35);
    [self addChild:settingsText];
    
    CCSprite *music = [CCSprite spriteWithFile:@"music_header.png"];
    music.position = ccp(self.contentSize.width/2, settingsText.position.y-130 - settingsText.boundingBox.size.height-15);
    [orangeBackground addChild:music];
    
    
    CCSprite *settingsIcon = [CCSprite spriteWithFile:@"icon_settings_main.png"];
    settingsIcon.position = ccp(self.contentSize.width/2, settingsText.position.y - settingsText.boundingBox.size.height-15);
    [self addChild:settingsIcon];
    
    CCControlSlider *controlSlider = [CCControlSlider sliderWithBackgroundFile:@"slider_base.png" progressFile:@"slider_base.png" thumbFile:@"btn_slider_normal.png"];
    controlSlider.position = ccp(self.contentSize.width/2, music.position.y - music.boundingBox.size.height-20);
    [orangeBackground addChild:controlSlider];
    
    music.position = ccp(controlSlider.boundingBox.origin.x + music.boundingBox.size.width/2, music.position.y);
    
    CCSprite *sfx = [CCSprite spriteWithFile:@"Sfx_header.png"];
    sfx.position = ccp(self.contentSize.width/2, controlSlider.position.y-controlSlider.boundingBox.size.height - 10);
    [orangeBackground addChild:sfx];
    
    
    CCControlSlider *controlSlider2 = [CCControlSlider sliderWithBackgroundFile:@"slider_base.png" progressFile:@"slider_base.png" thumbFile:@"btn_slider_normal.png"];
    controlSlider2.position = ccp(self.contentSize.width/2, sfx.position.y - sfx.boundingBox.size.height - 20);
    [orangeBackground addChild:controlSlider2];
    
    sfx.position = ccp(controlSlider2.boundingBox.origin.x + sfx.boundingBox.size.width/2, sfx.position.y);
    
    CCMenuItem *ok = [CCMenuItemImage itemWithNormalImage:@"btn_main_menu_normal.png" selectedImage:@"btn_main_menu_pressed.png" block:^(id sender){
        [(ReadyScene *)[self parent] gotoMainMenu];
    }];
    ok.position = ccp(size.width/2, ok.boundingBox.size.height);
    
    CCMenu *menu = [CCMenu menuWithItems:ok, nil];
    menu.position = ccp(0, 0);
    [self addChild:menu];
    
    return self;
}

- (void)sliderAction:(id)sender
{
    NSLog(@"Getting some slider action here ");
    
}

@end
