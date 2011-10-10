//
//  ScoreBoard.m
//  AirHockey
//
//  Created by Martin Goffan on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreBoard.h"

@implementation ScoreBoard

- (id)init
{
    self = [super init];
    if (self) {
        userScore = [NSNumber numberWithInt:0];
        COMScore  = [NSNumber numberWithInt:0];
        
        [self addChild:[CCSprite spriteWithFile:@"scoreboard.png"] z:0];
        
        Score1 = [CCLabelTTF labelWithString:[userScore stringValue] fontName:@"Marker Felt" fontSize:24.0];
        Score2 = [CCLabelTTF labelWithString:[COMScore stringValue] fontName:@"Marker Felt" fontSize:24.0];
        Score1.position = ccp(-16.5, 0);
        Score2.position = ccp(17, 0);
        Score1.color = ccc3(255, 255, 255);
        Score2.color = ccc3(255, 255, 255);
        
        [self addChild:Score1 z:1];
        [self addChild:Score2 z:2];
    }
    
    return self;
}

- (void)setUserScore:(NSNumber *)aScore {
    [Score1 setString:[aScore stringValue]];
}

- (void)setCOMScore:(NSNumber *)aScore {
    [Score2 setString:[aScore stringValue]];
}

@end
