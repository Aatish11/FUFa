//
//  EndgameLayer.h
//  FUFA
//
//  Created by Aatish Molasi on 6/8/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "cocos2d.h"

@interface EndgameLayer : CCLayerColor
{
    
}

- (id)initWithColor:(ccColor4B)color withPlayer:(Player *)player withOtherPlayer:(Player *)playerTwo;

@end
