//
//  SinglePlayerScene.h
//  RPS
//
//  Created by Martin Goffan on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreBoard.h"
#import "Box2D.h"

@interface SinglePlayerScene : CCScene <CCTargetedTouchDelegate> {
    CCLayer *bgLayer;
    CCLayer *gameLayer;
    
    CCSprite *puck0, *puck1;
    CCSprite *ball;
    
    ScoreBoard* myScoreBoard;
    
    int myScore, iScore;
    
    b2World *world;
    b2Body *body;
}
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@end
