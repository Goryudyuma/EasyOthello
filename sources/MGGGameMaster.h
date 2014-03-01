//
//  MGGGameMaster.h
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/28.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGGameMaster : NSObject
{
    unsigned passCount; // 連続パスの回数
    BOOL isOnGame; // ゲーム中であるか
    int winner; // 勝者。０：引き分け 1:黒 2:白
}

@property (readonly) BOOL isOnGame;
@property (readonly) unsigned passCount;
@property (readonly) int winner;

- (id)initWithNewGame; // 初期化

// 終局でないかどうかを返す(YESで終局)。
// 仮引数はこのターンにうてる場所の一覧と現在のボード。うてない場合は空の配列がくる
- (BOOL)shouldWeFinishGameWithCandidate:(NSArray *)aCand andWithBoard:(MGGBoard *)aBoard;

// ポップアップ表示で結果を表示する
- (void)announceResult:(NSString *)text;

@end
