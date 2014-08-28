//
//  SettingsLayer.h
//  FUFA
//
//  Created by Aatish Molasi on 6/8/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "CustomMenuItem.h"
#import "CCControlExtension.h"

@interface SettingsLayer : CCLayerColor {
    
}


- (id)initWithColor:(ccColor4B)color forPlayer:(Player *)player;

@end
