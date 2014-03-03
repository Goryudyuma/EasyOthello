﻿#import "MGGAppDelegate.h"
#import "MGGPiece.h"
#define BLACK 1
#define WHITE 2
#define WIDTH 8

@class MGGPiece;

@implementation MGGAppDelegate


@synthesize outlets;
@synthesize p00,p01,p02,p03,p04,p05,p06,p07,p10,p11,p12,p13,p14,p15,p16,p17,p20,p21,p22,p23,p24,p25,p26,p27,p30,p31,p32,p33,p34,p35,p36,p37,p40,p41,p42,p43,p44,p45,p46,p47,p50,p51,p52,p53,p54,p55,p56,p57,p60,p61,p62,p63,p64,p65,p66,p67,p70,p71,p72,p73,p74,p75,p76,p77;
@synthesize firstCounter,secondCounter;


// アプリ起動時の挙動
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // アウトレット集を作成
    outlets=[NSMutableArray array];
    NSMutableArray *tmpRow;
    tmpRow=[NSMutableArray arrayWithObjects:p00,p01,p02,p03,p04,p05,p06,p07, nil];
    [outlets addObject:tmpRow];
    tmpRow=[NSMutableArray arrayWithObjects:p10,p11,p12,p13,p14,p15,p16,p17, nil];
    [outlets addObject:tmpRow];
    tmpRow=[NSMutableArray arrayWithObjects:p20,p21,p22,p23,p24,p25,p26,p27, nil];
    [outlets addObject:tmpRow];
    tmpRow=[NSMutableArray arrayWithObjects:p30,p31,p32,p33,p34,p35,p36,p37, nil];
    [outlets addObject:tmpRow];
    tmpRow=[NSMutableArray arrayWithObjects:p40,p41,p42,p43,p44,p45,p46,p47, nil];
    [outlets addObject:tmpRow];
    tmpRow=[NSMutableArray arrayWithObjects:p50,p51,p52,p53,p54,p55,p56,p57, nil];
    [outlets addObject:tmpRow];
    tmpRow=[NSMutableArray arrayWithObjects:p60,p61,p62,p63,p64,p65,p66,p67, nil];
    [outlets addObject:tmpRow];
    tmpRow=[NSMutableArray arrayWithObjects:p70,p71,p72,p73,p74,p75,p76,p77, nil];
    [outlets addObject:tmpRow];
    
    // 新規対局用に初期化
    mainBoard=[[MGGBoard alloc] initWithNewGame];
    firstPlayer=[[MGGPlayer alloc] initForPlayer:BLACK];
    secondPlayer=[[MGGPlayer alloc] initForPlayer:WHITE];
    ourMaster=[[MGGGameMaster alloc] initWithNewGame];
    ourStrage=[[MGGStrage alloc] initWithNewGame];
    frequency=0;
    isFreq=NO;
    
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
    // 枚数表示を更新
    [firstCounter setIntValue:[mainBoard countPieceOf:BLACK]];
    [secondCounter setIntValue:[mainBoard countPieceOf:WHITE]];
    
    // GameMasterの判断を仰ぐ部分
    if (![ourMaster shouldWeFinishGameWithCandidate:candidate andWithBoard:mainBoard]) {
        if (ourMaster.passCount==0) { // パスでなければ
            // このターンのプレイヤーが手動かどうかで分岐
            MGGPlayer *thisPlayer= mainBoard.turn==BLACK ? firstPlayer : secondPlayer;
            if (!thisPlayer.isManual) { // AIを使う場合
                // 入力待ちを飛ばして手番終了処理へ
                [self playerTurnWillBeFinishedWithCandidate:[thisPlayer putOnThisCoordinate:mainBoard]];
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
        int remTurn=frequency-ourMaster.frequency;
        if (remTurn==frequency && isFreq) { // 連戦終了
            [ourStrage writeAndOutputRecordOf:ourMaster.winner andRemain:remTurn];
        } else if (isFreq) {
            // まだ続行のとき
            [ourStrage recordManyWithWinner:ourMaster.winner andRemain:remTurn];
            mainBoard=[[MGGBoard alloc] initWithNewGame];
            int tmp=ourMaster.frequency;
            ourMaster=[[MGGGameMaster alloc] initWithNewGame];
            ourMaster.frequency=tmp;
            ourStrage.gameRecord=[NSMutableArray array];
            [self playerTurnIsStarted];
        }

            // 棋譜の最後を編集
            [ourStrage addFinalStringWithWinner:ourMaster.winner];
    }
}


// 手番終了の処理
// 仮引数にnilがくる場合、アプリを強制停止
- (void)playerTurnWillBeFinishedWithCandidate:(NSNumber *)aCand
{
    if (aCand!=nil) {
        int y=[aCand intValue]/10;
        int x=[aCand intValue]%10;
        
        // 盤面の画像を更新した後、駒をおく
        NSButton *here=[[outlets objectAtIndex:y] objectAtIndex:x];
        NSImage *hImage = [NSImage imageNamed:(mainBoard.turn==BLACK ? @"black.jpg" : @"white.jpg")];
        [here setImage:hImage];
        
        // 駒をひっくり返す
        NSArray *reverse=[mainBoard putPieceAt:aCand];
        NSUInteger max=[reverse count];
        for (int i=0; i<max; i++) {
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

    } else {
        // 強制停止
        return;
    }
    
}


// Manual,AIポップアップボタンが押されたとき
- (IBAction)changeManual:(id)sender
{
    NSPopUpButton *button=sender;
    
    MGGPlayer *thisPlayer= button.tag==BLACK ? firstPlayer : secondPlayer;
    // 選択されているAIとストレージのAIコレクションのインデックスを対応させる
    NSInteger selectedAI=[button indexOfSelectedItem]-1;
    if (selectedAI==-1) {
        thisPlayer.isManual=YES;
    } else {
        thisPlayer.isManual=NO;
        thisPlayer.myAI=[ourStrage.AIArray objectAtIndex:selectedAI];
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
    ourMaster.frequency=frequency;
    [firstCounter setIntValue:2];
    [secondCounter setIntValue:2];
    
    // 盤面の画像を初期化
    NSImage *tmpImage=[NSImage imageNamed:@"green.jpg"];
    int i,j;
    for (i=0; i<WIDTH; i++) {
        for (j=0; j<WIDTH; j++) {
            NSButton *tmpButton=[[outlets objectAtIndex:i] objectAtIndex:j];
            if ((i==WIDTH/2 || i==WIDTH/2-1) && i==j) {
                [tmpButton setImage:[NSImage imageNamed:@"white.jpg"]];
            } else if ((i==WIDTH/2 && j==WIDTH/2-1) || (i==WIDTH/2-1 && j==WIDTH/2)) {
                [tmpButton setImage:[NSImage imageNamed:@"black.jpg"]];
            } else {
                [tmpButton setImage:tmpImage];
            }
        }
    }
    
    // 手番へ
    [self playerTurnIsStarted];
}


// ファイル生成ボタンが押されたとき
- (IBAction)createRecordFile:(NSButton *)sender
{
    // ゲーム中は動かないとする
    if (!ourMaster.isOnGame) {
            NSString *text;
            // ファイル生成と報告
            if ([ourStrage createRecordFile]) {
                text=[NSString stringWithFormat:@"A record file is created at your documents directory."];
            } else {
                text=@"Creating a record file is failed.";
            }
            
            NSAlert *attention=[NSAlert alertWithMessageText:@"Attention" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@",text];
            
            [attention runModal];
    }
}

- (IBAction)doManyGames:(id)sender
{
    frequency=[sender intValue];
    isFreq = frequency>0 ? YES : NO;
}
@end
