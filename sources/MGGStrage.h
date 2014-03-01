//
//  MGGStrage.h
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/28.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGStrage : NSObject
{
    NSMutableArray *gameRecord; // 棋譜の記録のための可変配列
    NSArray *AIArray; // AI集
}

@property (readonly) NSArray *AIArray;
@property (readonly) NSMutableArray *gameRecord;

- (id)initWithNewGame; // 新規対局用の初期化

// このターンの棋譜を追加する。パスの時はrecをnilにしてください
- (void)addRecord:(NSNumber *)rec andBoard:(MGGBoard *)aBoard;
// 終了時の棋譜への編集
// 仮引数はGameMasterの勝敗フラグ
- (void)addFinalStringWithWinner:(int)winner;
// 棋譜ファイルを生成する。
// 仮引数に保存場所へのパスを受け取る
// 成功するとYESを返す
// 最後の仮引数はファイル形式について。NSAlertDefaultReturn:.plist NSAlertAlternateReturn:.csv
- (BOOL)createRecordFileAt:(NSString *)pass withFormat:(NSModalResponse)format;
@end
