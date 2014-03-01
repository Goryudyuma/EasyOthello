//
//  MGGPlayer.m
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import "MGGPlayer.h"
#import "MGGSampleAI.h"

@class MGGSampleAI;

@implementation MGGPlayer

@synthesize isManual;

- (id)initForFirstPlayer
{
    turn=1;
    isManual=YES;
    
    return self;
}

- (id)initForSecondPlayer
{
    turn=2;
    isManual=YES;
    
    return self;
}

- (NSNumber *)putOnThisCoordinate:(MGGBoard *)aBoard byAI:(id)myAI
{
    NSNumber *myCoordinate;
    
    myCoordinate=[myAI whereShouldIPutOn:aBoard]; // 書き換え部分
    
    return myCoordinate;
}
@end
