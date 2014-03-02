//
//  MGGAppDelegate.m
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import "MGGAppDelegate.h"
#import "MGGPiece.h"
#define BLACK 1
#define WHITE 2
#define WIDTH 8

@class MGGPiece;

@implementation MGGAppDelegate

@synthesize outlets;
@synthesize p00,p01,p02,p03,p04,p05,p06,p07,p10,p11,p12,p13,p14,p15,p16,p17,p20,p21,p22,p23,p24,p25,p26,p27,p30,p31,p32,p33,p34,p35,p36,p37,p40,p41,p42,p43,p44,p45,p46,p47,p50,p51,p52,p53,p54,p55,p56,p57,p60,p61,p62,p63,p64,p65,p66,p67,p70,p71,p72,p73,p74,p75,p76,p77;

// アプリ起動時の挙動
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    // アウトレット集を作成
    NSMutableArray *col0=[NSMutableArray arrayWithObjects:
                          p00,p01,p02,p03,p04,p05,p06,p07, nil];
    NSMutableArray *col1=[NSMutableArray arrayWithObjects:
                          p10,p11,p12,p13,p14,p15,p16,p17, nil];
    NSMutableArray *col2=[NSMutableArray arrayWithObjects:
                          p20,p21,p22,p23,p24,p25,p26,p27, nil];
    NSMutableArray *col3=[NSMutableArray arrayWithObjects:
                          p30,p31,p32,p33,p34,p35,p36,p37, nil];
    NSMutableArray *col4=[NSMutableArray arrayWithObjects:
                          p40,p41,p42,p43,p44,p45,p46,p47, nil];
    NSMutableArray *col5=[NSMutableArray arrayWithObjects:
                          p50,p51,p52,p53,p54,p55,p56,p57, nil];
    NSMutableArray *col6=[NSMutableArray arrayWithObjects:
                          p60,p61,p62,p63,p64,p65,p66,p67, nil];
    NSMutableArray *col7=[NSMutableArray arrayWithObjects:
                          p70,p71,p72,p73,p74,p75,p76,p77, nil];
    outlets=[NSMutableArray arrayWithObjects:
             col0,col1,col2,col3,col4,col5,col6,col7, nil];
    
    // 新規対局用に初期化
    mainBoard=[[MGGBoard alloc] initWithNewGame];
    firstPlayer=[[MGGPlayer alloc] initForFirstPlayer];
    secondPlayer=[[MGGPlayer alloc] initForSecondPlayer];
    ourMaster=[[MGGGameMaster alloc] initWithNewGame];
    ourStrage=[[MGGStrage alloc] initWithNewGame];
    
    // プレーヤーの手番に入る
    [self playerTurnIsStarted];
}


// Dockからアプリの復帰
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:nil];
    
    return NO;
}


// アプリ終了時の挙動
- (void)applicationWillTerminate:(NSNotification *)notification
{
}


// プレイヤーの手番の開始部分
- (void)playerTurnIsStarted
{
    // 盤面にうてる場所の情報を更新させて、その情報を得る
    candidate=[NSArray arrayWithArray:[mainBoard whereCanIPut]];
    
    // GameMasterの判断を仰ぐ部分
    if (![ourMaster shouldWeFinishGameWithCandidate:candidate andWithBoard:mainBoard]) {
        if (ourMaster.passCount==0) { // パスでなければ
            // このターンのプレイヤーが手動かどうかで分岐
            if (mainBoard.turn==1 && !firstPlayer.isManual) { // 先手の番でかつ先手がAIを使う場合
                // 入力待ちを飛ばして手番終了処理へ
                [self playerTurnWillBeFinishedWithCandidate:[firstPlayer putOnThisCoordinate:mainBoard byAI:[ourStrage.AIArray objectAtIndex:0]]];
            } else if (mainBoard.turn==2 && !secondPlayer.isManual) {
                [self playerTurnWillBeFinishedWithCandidate:[secondPlayer putOnThisCoordinate:mainBoard byAI:[ourStrage.AIArray objectAtIndex:0]]];
            }
            
            // 手動の場合このままて入力待ちへ
        } else { // パスだったら
            // 記録して
            [ourStrage addRecord:nil andBoard:mainBoard];
            // 次のプレイヤーへ
            [mainBoard changeTurn];
            [self playerTurnIsStarted];
        }
    } else { // ゲーム終了
        // 棋譜の最後を編集
        [ourStrage addFinalStringWithWinner:ourMaster.winner];
    }
}


// 手番終了の処理
- (void)playerTurnWillBeFinishedWithCandidate:(NSNumber *)aCand
{
    int y=[aCand intValue]/10;
    int x=[aCand intValue]%10;
    
    // 盤面の画像を更新した後、駒をおく
    NSButton *here=[[outlets objectAtIndex:y] objectAtIndex:x];
    NSImage *hImage;
    if (mainBoard.turn==BLACK) {
        hImage=[NSImage imageNamed:@"black.jpg"];
    } else {
        hImage=[NSImage imageNamed:@"white.jpg"];
    }
    [here setImage:hImage];
    
    // 駒をひっくり返す
    NSArray *reverse=[mainBoard putPieceAt:aCand];
    NSUInteger max=[reverse count];
    int i;
    for (i=0; i<max; i++) {
        int a=[[reverse objectAtIndex:i] intValue]/10;
        int b=[[reverse objectAtIndex:i] intValue]%10;
        here=[[outlets objectAtIndex:a] objectAtIndex:b];
        [here setImage:hImage];
    }
    
    // このターンの記録をする
    [ourStrage addRecord:aCand andBoard:mainBoard];
    // ターンの変更
    [mainBoard changeTurn];
    // 次の手番へ
    [self playerTurnIsStarted];
    
}


// Manual チェックボックスを操作された時の挙動
- (IBAction)changeManual:(NSButton *)sender
{
    if (sender.tag==1) { // 黒
        firstPlayer.isManual=!firstPlayer.isManual;
    } else {
        secondPlayer.isManual=!secondPlayer.isManual;
    }
}


// 盤面を押された時の挙動
- (IBAction)putPiece:(NSButton *)sender
{
    // 終局中はボタンを押されても無反応
    if (ourMaster.isOnGame) {
        NSNumber *bTag=[NSNumber numberWithUnsignedInteger:sender.tag];
        // 押された場所はうてる場所かどうか確認
        // 不正な場所であれば再び入力待ちへ
        if ([mainBoard canIPutOn:bTag]) { // 正しい場所なら
            // このまま-playerTurnWillBeFinishedWithCoordinate:へ
            [self playerTurnWillBeFinishedWithCandidate:bTag];
        }

    }
}

// NewGameボタンが押されたとき
- (IBAction)startNewGame:(NSButton *)sender
{
    // 新規対局用にデータを初期化
    mainBoard=[[MGGBoard alloc] initWithNewGame];
    ourMaster=[[MGGGameMaster alloc] initWithNewGame];
    ourStrage=[[MGGStrage alloc] initWithNewGame];
    
    // 盤面の画像を初期化
    NSImage *tmpI=[NSImage imageNamed:@"green.jpg"];
    int i,j;
    for (i=0; i<WIDTH; i++) {
        NSMutableArray *tmpA=[outlets objectAtIndex:i];
        for (j=0; j<WIDTH; j++) {
            NSButton *tmpB=[tmpA objectAtIndex:j];
            if ((i==WIDTH/2 || i==WIDTH/2-1) && (j==WIDTH/2 || j==WIDTH/2-1)) {
                [tmpB setImage:[NSImage imageNamed:@"black.jpg"]];
                if(i==j){
                    [tmpB setImage:[NSImage imageNamed:@"white.jpg"]];
                }
            } else {
                [tmpB setImage:tmpI];
            }
            [tmpA replaceObjectAtIndex:j withObject:tmpB];
        }
        [outlets replaceObjectAtIndex:i withObject:tmpA];
    }
    
    // 手番へ
    [self playerTurnIsStarted];
}


// ファイル生成ボタンが押されたとき
- (IBAction)createRecordFile:(NSButton *)sender
{
    // ゲーム中は動かないとする
    if (!ourMaster.isOnGame) {
        // ドキュメントを保存する標準ディレクトリへのパスを生成する
        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        // フィアル名はEasyOhtello+時刻にする
        NSString *fileName=@"EasyOhello";
        NSDateFormatter *tmpDF=[NSDateFormatter new];
        [tmpDF setDateFormat:@"yyyMMddHHmmssSSS"];
        fileName=[fileName stringByAppendingString:[tmpDF stringFromDate:[NSDate date]]];
        // ファイル形式についての選択
        NSAlert *select=[NSAlert alertWithMessageText:@"SELECT" defaultButton:@".plist" alternateButton:@".csv" otherButton:nil informativeTextWithFormat:@"Which file format will you use?"];
        NSModalResponse retValue=[select runModal];
        if (retValue==NSAlertDefaultReturn) {
            fileName=[fileName stringByAppendingString:@".plist"];
        } else if (retValue==NSAlertAlternateReturn) {
            fileName=[fileName stringByAppendingString:@".csv"];
        }
        filePath=[filePath stringByAppendingPathComponent:fileName];
        
        NSString *text;
        // ファイル生成と報告
        if ([ourStrage createRecordFileAt:filePath withFormat:retValue]) {
            text=[NSString stringWithFormat:@"A record file is created at %@",filePath];
        } else {
            text=@"Creating a record file is failed.";
        }
        
        NSAlert *attention=[NSAlert alertWithMessageText:@"Attention" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@",text];
        
        [attention runModal];

    }
}

@end
