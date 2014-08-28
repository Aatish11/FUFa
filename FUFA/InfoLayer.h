//
//  InfoLayer.h
//  FUFA
//
//  Created by Aatish Molasi on 6/7/14.
//  Copyright 2014 Aatish Molasi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

@interface InfoLayer : CCLayerColor
{
    id _delegate;
}

@property(nonatomic, assign)id delegate;

@end

@protocol infoLayerDelegate <NSObject>

- (void)infoLayerDismissed;
- (id)initWithColor:(ccColor4B)color withPlayer:(Player *)player;

@end