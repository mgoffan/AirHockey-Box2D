//
//  SinglePlayerScene.m
//  RPS
//
//  Created by Martin Goffan on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SinglePlayerScene.h"

@implementation SinglePlayerScene

+(CCScene *) scene
{
    //    MainMenuScene* f = [self node];
    CCScene *scene = (SinglePlayerScene *)[self node];
	return scene;
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    [puck0 setPosition:location];
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"touch move");
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (location.x >= 240) location.x = 240;
    
    [puck0 setPosition:location];
}

BOOL backx = NO;
BOOL backy = NO;



- (void)resetGame {
    CGPoint nextPoint = CGPointMake(240, 160);
    [ball stopActionByTag:10];
    [ball runAction:[CCMoveTo actionWithDuration:2.5 position:nextPoint]];
}

- (void)somebodyWon:(BOOL)aYes {
    CCLabelTTF *label;
    if (aYes) {
        label = [CCLabelTTF labelWithString:@"YOU WON!!!" fontName:@"Marker Felt" fontSize:48.0];
        myScore++;
        [myScoreBoard setUserScore:[NSNumber numberWithInt:myScore]];
    }
    else {
        label = [CCLabelTTF labelWithString:@"YOU LOST!!!" fontName:@"Marker Felt" fontSize:48.0];
        iScore++;
        [myScoreBoard setCOMScore:[NSNumber numberWithInt:iScore]];
    }
    [label setColor:ccc3(0, 0, 0)];
    label.position = ccp(240, 160);
    label.scale = 0.0f;
    
    [label setTag:3];
    [gameLayer addChild:label z:1];
    
    CCAction *myAction = [CCSequence actions:[CCSpawn actions:[CCCallFunc actionWithTarget:self selector:@selector(resetGame)] , [CCFadeIn actionWithDuration:3.0], [CCScaleTo actionWithDuration:1.5 scale:1.0f], nil], [CCCallFunc actionWithTarget:self selector:@selector(removeLabel)], nil];
    [label runAction:myAction];
}

- (void)animateController {
    CGPoint nextPoint = CGPointMake(puck1.position.x, ball.position.y);
    CCAction *myAction = [CCSequence actions:[CCMoveTo actionWithDuration:0.22 position:nextPoint], [CCCallFunc actionWithTarget:self selector:@selector(animateController)], nil];
    [puck1 runAction:myAction];
}

- (void)animatePuck {
#ifndef kAccelXAxis
#define kAccelXAxis 4.0
#endif
    
#ifndef kAccelYAxis
#define kAccelYAxis 5.0
#endif
    
    CGPoint nextPoint;
        if (ball.position.x == 480.0) {
            nextPoint.x = ball.position.x - kAccelXAxis;
            backx = YES;
            [self somebodyWon:YES];
        }
        else {
            if (ball.position.x == 0.0) {
                nextPoint.x = ball.position.x + kAccelXAxis;
                backx = NO;
                [self somebodyWon:NO];
            }
            else {
                if (backx) {
                    nextPoint.x = ball.position.x - kAccelXAxis;
                }
                else nextPoint.x = ball.position.x + kAccelXAxis;
            }
        }
        
        if (ball.position.y == 0.0) {
            nextPoint.y = ball.position.y + kAccelYAxis;
           backy = YES;
        }
        else {
            if (ball.position.y == 320.0) {
                nextPoint.y = ball.position.y - kAccelYAxis;
                backy = NO;
            }
            else {
                if (backy) {
                    nextPoint.y = ball.position.y + kAccelYAxis;
                }
                else nextPoint.y = ball.position.y - kAccelYAxis;
            }
        }
    
    CCAction *myAction = [CCSequence actions:[CCMoveTo actionWithDuration:0.01 position:nextPoint], [CCCallFunc actionWithTarget:self selector:@selector(animatePuck)], [CCCallFunc actionWithTarget:self selector:@selector(collisionDetector)],nil];
    [myAction setTag:10];
    [ball runAction:myAction];
}

- (void)removeLabel {
    [gameLayer removeChildByTag:3 cleanup:NO];
    [self animatePuck];
}

- (void)collisionDetector {
    BOOL b0 = CGRectIntersectsRect(puck1.boundingBox, ball.boundingBox);
    BOOL b1 = CGRectIntersectsRect(puck0.boundingBox, ball.boundingBox);
    
    if (b0 || b1) {
        NSLog(@"collision");
        
        backy = (puck0.position.y < ball.position.y) ? YES : NO;
        backx = (b1) ? NO : YES;
    }
}

- (void)setUpBackground {
    CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
    bg.position = ccp(240, 160);
    bgLayer.isTouchEnabled = NO;
    [bgLayer addChild:bg];
}

- (void)tick:(ccTime)dt {
    int32 velocityIterations = 4;
	int32 positionIterations = 1;
    
    world->Step(dt, velocityIterations, positionIterations);
    world->ClearForces();
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
//    b2Vec2 gravity(world->GetGravity().x * -(arc4random() % 2 == 0) ? -2:1, world->GetGravity().y * (arc4random() % 2 == 0) ? -1:2);
//    world->SetGravity(gravity);
//    if (b2TestOverlap(world->GetGravity(), <#const b2Shape *shapeB#>, <#const b2Transform &xfA#>, <#const b2Transform &xfB#>))
}

- (void)setUpGameLayer {
    puck0 = [CCSprite spriteWithFile:@"puck.png"];
    puck1 = [CCSprite spriteWithFile:@"puck.png"];
//    puck0.position = ccp(20, 160);
//    puck1.position = ccp(460, 160);
    [puck0 setTag:0];
    [puck1 setTag:1];
    gameLayer.isTouchEnabled = YES;
    [gameLayer addChild:puck0 z:0];
    [gameLayer addChild:puck1 z:0];
    
    ball = [CCSprite spriteWithFile:@"g.png"];
    [ball setTag:2];
    [gameLayer addChild:ball z:0];
    ball.position = ccp(240, 160);
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    world->SetContinuousPhysics(true);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    b2Body *groundBody = world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &groundBox;
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
    groundBody->CreateFixture(&boxShapeDef);
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    groundBody->CreateFixture(&boxShapeDef);
    groundBox.SetAsEdge(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO));
    groundBody->CreateFixture(&boxShapeDef);
    groundBox.SetAsEdge(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, 0));
    groundBody->CreateFixture(&boxShapeDef);
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set((winSize.width/2)/PTM_RATIO, (winSize.height/2)/PTM_RATIO);
    ballBodyDef.userData = ball;
    body = world->CreateBody(&ballBodyDef);
    
    b2PolygonShape circle;
    circle.SetAsBox(26.0f/PTM_RATIO, 26.0f/PTM_RATIO);
//    circle.m_radius = 26.0/PTM_RATIO;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.2f;
    ballShapeDef.restitution = 1.0f;
    body->CreateFixture(&ballShapeDef);
    
    //
    
    b2BodyDef puckBodyDef1, puckBodyDef0;
    
//    puckBodyDef0.type = b2_dynamicBody;
//    puckBodyDef0.position.Set(80/PTM_RATIO, (winSize.height / 2)/PTM_RATIO);
//    puckBodyDef0.userData = puck0;
    
    puckBodyDef1.type = b2_dynamicBody;
    puckBodyDef1.position.Set((winSize.height - 20)/PTM_RATIO, (winSize.height / 2)/PTM_RATIO);
    puckBodyDef1.userData = puck1;
    
//    body = world->CreateBody(&puckBodyDef0);
    body = world->CreateBody(&puckBodyDef1);
    
    b2CircleShape puckShape0, puckShape1;
//    puckShape0.m_radius = 27.5/PTM_RATIO;
    puckShape1.m_radius = 27.5/PTM_RATIO;
    
    b2FixtureDef puckShapeDef1, puckShapeDef0;
    
    
//    puckShapeDef0.shape = &puckShape0;
//    puckShapeDef0.density = 1.0f;
//    puckShapeDef0.friction = 0.2f;
//    puckShapeDef0.restitution = 0.1f;
    
    puckShapeDef1.shape = &puckShape1;
    puckShapeDef1.density = 1.0f;
    puckShapeDef1.friction = 0.2f;
    puckShapeDef1.restitution = 0.1f;
    
    
//    body->CreateFixture(&puckShapeDef0);
    body->CreateFixture(&puckShapeDef1);
    
    [self schedule:@selector(tick:)];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSLog(@"init");
        
        iScore = 0;
        myScore = 0;
        
        myScoreBoard = [[ScoreBoard alloc] init];
        myScoreBoard.position = ccp(240, 305);
        
        [self registerWithTouchDispatcher];
        
        bgLayer = [CCLayer node];
        gameLayer = [CCLayer node];
        
        [gameLayer addChild:myScoreBoard z:99];
        
        [self setUpBackground];
        [self setUpGameLayer];
        
//        [self animatePuck];
//        [self animateController];
        
        [self addChild:bgLayer z:0];
        [self addChild:gameLayer z:1];
        
    }
    
    return self;
}

@end
