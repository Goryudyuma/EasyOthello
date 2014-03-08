

#import "MGGAppDelegate.h"
#import "MGGPiece.h"
#define BLACK 1
#define WHITE 2
#define WIDTH 8
#define LIMIT 200
#define GAMEOVER -1
#define PASS -2
#define MANUAL -3
#define END -4

@class MGGPiece;

@implementation MGGAppDelegate


@synthesize outlets;
@synthesize p00,p01,p02,p03,p04,p05,p06,p07,p10,p11,p12,p13,p14,p15,p16,p17,p20,p21,p22,p23,p24,p25,p26,p27,p30,p31,p32,p33,p34,p35,p36,p37,p40,p41,p42,p43,p44,p45,p46,p47,p50,p51,p52,p53,p54,p55,p56,p57,p60,p61,p62,p63,p64,p65,p66,p67,p70,p71,p72,p73,p74,p75,p76,p77;
@synthesize firstCounter,secondCounter;
@synthesize howManyGame;


// アプリ起動時の挙動
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // アウトレット集を作成
    outlets=[[NSMutableArray alloc] init];
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
    myGameController=[[MGGGameController alloc] initForLaunching];
    frequency=1;
    endNum=0;
    
    // プレーヤーの手番に入る
    [self startTurn];
}


// Dockからアプリの復帰
- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:nil];
    
    return NO;
}


// 手番の処理
- (void)startTurn
{
    
    // AI同士のとき
    if (!myGameController.firstPlayer.isManual && !myGameController.secondPlayer.isManual) {
        // 決められた回数だけ繰り返す
        NSNumber *judgement;
        while (endNum<frequency) {
            judgement=[myGameController playerTurnIsStarted];
            switch ([judgement intValue]) {
                case GAMEOVER:
                    [myGameController gameIsOverWithRemain:[NSNumber numberWithUnsignedInt:endNum]];
                    endNum++;
                    // ここで初期化をする
                    if (endNum!=frequency) {
                        myGameController=[myGameController initForSeriesGame];
                    }
                    break;
                case PASS:
                    [myGameController playerTurnWillBeFinishedWithCandidate:[NSNumber numberWithInt:-1]];
                    break;
                    
                default:
                    if ([judgement intValue]==END) return;
                    [myGameController playerTurnWillBeFinishedWithCandidate:judgement];
                    break;
            }
        }
        [self renewalImage];
    } else { // マニュアル操作を含むとき
        NSNumber *judgement=[myGameController playerTurnIsStarted];
        switch ([judgement intValue]) {
            case GAMEOVER:
                [myGameController gameIsOverWithRemain:[NSNumber numberWithInt:endNum]];
                break;
            case PASS:
                [myGameController playerTurnWillBeFinishedWithCandidate:[NSNumber numberWithInt:-1]];
                [self startTurn];
                break;
            case MANUAL:
                break;
                
            default:
                if ([judgement intValue]==END) return;
                [myGameController playerTurnWillBeFinishedWithCandidate:judgement];
                [self renewalImage];
                [self startTurn];
                break;
        }
        
    }
}

- (void)renewalImage
{
    NSArray *name=[NSArray arrayWithObjects:
                   @"green",@"black",@"white", nil];
    for (int i=0; i<WIDTH; i++) {
        for (int j=0; j<WIDTH; j++) {
            __weak MGGPiece *tmpP=[[myGameController.mainBoard.board objectAtIndex:i] objectAtIndex:j];
            __weak NSButton *tmpB=[[outlets objectAtIndex:i] objectAtIndex:j];
            [tmpB setImage:[NSImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[name objectAtIndex:tmpP.belong]]]];
        }
    }
    // 同時に枚数表示も更新する
    [firstCounter setIntValue:[myGameController.mainBoard countPieceOf:BLACK]];
    [secondCounter setIntValue:[myGameController.mainBoard countPieceOf:WHITE]];
    
}


// Manual,AIポップアップボタンが押されたとき
- (IBAction)changeManual:(id)sender
{
    __weak NSPopUpButton *button=sender;
    
    __weak MGGPlayer *thisPlayer= button.tag==BLACK ? myGameController.firstPlayer : myGameController.secondPlayer;
    // 選択されているAIとAIコレクションのインデックスを対応させる
    NSInteger selectedAI=[button indexOfSelectedItem]-1;
    thisPlayer.isManual = selectedAI==-1 ? YES : NO;
    [thisPlayer changeMyAIWithIndex:selectedAI];
    // マニュアル操作が入る時は連戦数を1にする
    if (thisPlayer.isManual) {
        [howManyGame setIntValue:1];
    }
}


// 盤面を押された時の挙動
- (IBAction)putPiece:(NSButton *)sender
{
    // 終局中はボタンを押されても無反応
    if (myGameController.ourMaster.isOnGame) {
        NSNumber *bTag=[NSNumber numberWithUnsignedInteger:sender.tag];
        // 押された場所はうてる場所かどうか確認
        // 不正な場所であれば再び入力待ちへ
        if ([myGameController.mainBoard canIPutOn:bTag]) { // 正しい場所なら
            // ターンの残りを処理して次のターンへ
            [myGameController playerTurnWillBeFinishedWithCandidate:bTag];
            [self renewalImage];
            [self startTurn];
        }

    }
}

// NewGameボタンが押されたとき
- (IBAction)startNewGame:(NSButton *)sender
{
    // 新規対局用にデータを初期化
    myGameController=[myGameController initForNewGame];
    myGameController.ourMaster.frequency=frequency;
    endNum=0;
    
    // 盤面の画像を初期化
    [self renewalImage];
    
    // 手番へ
    [self startTurn];
}


// ファイル生成ボタンが押されたとき
- (IBAction)createRecordFile:(NSButton *)sender
{
    // ゲーム中は動かないとする
    // AI同士の連戦後は動かないとする
    if (!myGameController.ourMaster.isOnGame && frequency==1) {
            NSString *text;
            // ファイル生成と報告
            if ([myGameController.ourStorage createRecordFile]) {
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
    frequency= [sender intValue]>0 ? [sender intValue] : 1;
    // マニュアル操作が入る時は連戦にしない
    if (myGameController.firstPlayer.isManual || myGameController.secondPlayer.isManual) {
        frequency=1;
    }
    [sender setIntValue:frequency];
}
@end
