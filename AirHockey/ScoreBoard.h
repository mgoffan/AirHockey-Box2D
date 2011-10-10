//
//  ScoreBoard.h
//  AirHockey
//
//  Created by Martin Goffan on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreBoard : CCLayer {
    NSNumber *userScore, *COMScore;
    
    CCLabelTTF *Score1, *Score2;
}

- (void)setUserScore:(NSNumber *)aScore;
- (void)setCOMScore:(NSNumber *)aScore;

@end