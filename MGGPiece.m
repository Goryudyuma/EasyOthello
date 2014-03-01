//
//  MGGPiece.m
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import "MGGPiece.h"

@implementation MGGPiece

@synthesize belong;
@synthesize canPut;

- (id)initWithNewGame
{
    belong=0;
    canPut=NO;
    
    return self;
}

@end
