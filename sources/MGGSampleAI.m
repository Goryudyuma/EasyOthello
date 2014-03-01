//
//  MGGSampleAI.m
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import "MGGSampleAI.h"
#import <time.h>
#import <stdlib.h>

@implementation MGGSampleAI

- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard
{
    // うてる場所一覧を取得
    NSArray *cndt=[aBoard whereCanIPut];
    
    srand((unsigned)time(NULL));
    
    NSUInteger n=[cndt count]; // 要素数を取得
    
    // うつ場所をランダムで決める
    return [cndt objectAtIndex:rand()%n];
}
@end
