//
//  MGGGameMaster.m
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/28.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import "MGGGameMaster.h"
#define BLACK 1
#define WHITE 2

@implementation MGGGameMaster

@synthesize isOnGame;
@synthesize passCount;
@synthesize  winner;

- (id)initWithNewGame
{
    passCount=0;
    isOnGame=YES;
    winner=0;
    
    return self;
}

- (BOOL)shouldWeFinishGameWithCandidate:(NSArray *)aCand andWithBoard:(MGGBoard *)aBoard
{
    // 受け取った配列の要素数を調べる
    // 要素数が0==パス
    if ([aCand count]==0) {
        passCount++;
        if (passCount==2) { // ２連続パスで終局
            isOnGame=NO;
            
            // 勝者を決めるため盤面上の駒の数を数える
            int black=[aBoard countPieceOf:BLACK];
            int white=[aBoard countPieceOf:WHITE];
            NSString *text;
            if (black==white) { // 引き分け
                text=@"A tied game.";
            } else {
                text=[NSString stringWithFormat:@"WINNER : %dP",(black>white ? BLACK : WHITE)];
                winner=black>white ? BLACK : WHITE;
            }
            [self announceResult:text];
        }
    } else { // パスでない
        passCount=0; // カウンタリセット
    }
    
    return !isOnGame;
}

- (void)announceResult:(NSString *)text
{
    NSAlert *result=[NSAlert alertWithMessageText:@"RESULT" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@",text];
    
    [result runModal];
}
@end
