#import <Cocoa/Cocoa.h>
#import "MGGBoard.h"
#import "MGGPlayer.h"
#import "MGGGameMaster.h"
#import "MGGStrage.h"
#import "MGGGameController.h"

@class MGGGameController;
@class MGGBoard;
@class MGGPlayer;
@class MGGGameMaster;
@class MGGStrage;

@interface MGGAppDelegate : NSObject <NSApplicationDelegate>
{
    NSMutableArray *outlets; // 盤面のアウトレット集（可変二次配列)
    MGGGameController *myGameController; // ゲームの進行部分のコントローラ
    int frequency; // 何連戦するか
    int endNum; // 何回連続でゲームが終了したのか。
}

@property (assign) IBOutlet NSWindow *window;
@property (readonly) NSMutableArray *outlets;

// 盤面のアウトレット
@property (weak) IBOutlet NSButton *p00;
@property (weak) IBOutlet NSButton *p01;
@property (weak) IBOutlet NSButton *p02;
@property (weak) IBOutlet NSButton *p03;
@property (weak) IBOutlet NSButton *p04;
@property (weak) IBOutlet NSButton *p05;
@property (weak) IBOutlet NSButton *p06;
@property (weak) IBOutlet NSButton *p07;
@property (weak) IBOutlet NSButton *p10;
@property (weak) IBOutlet NSButton *p11;
@property (weak) IBOutlet NSButton *p12;
@property (weak) IBOutlet NSButton *p13;
@property (weak) IBOutlet NSButton *p14;
@property (weak) IBOutlet NSButton *p15;
@property (weak) IBOutlet NSButton *p16;
@property (weak) IBOutlet NSButton *p17;
@property (weak) IBOutlet NSButton *p20;
@property (weak) IBOutlet NSButton *p21;
@property (weak) IBOutlet NSButton *p22;
@property (weak) IBOutlet NSButton *p23;
@property (weak) IBOutlet NSButton *p24;
@property (weak) IBOutlet NSButton *p25;
@property (weak) IBOutlet NSButton *p26;
@property (weak) IBOutlet NSButton *p27;
@property (weak) IBOutlet NSButton *p30;
@property (weak) IBOutlet NSButton *p31;
@property (weak) IBOutlet NSButton *p32;
@property (weak) IBOutlet NSButton *p33;
@property (weak) IBOutlet NSButton *p34;
@property (weak) IBOutlet NSButton *p35;
@property (weak) IBOutlet NSButton *p36;
@property (weak) IBOutlet NSButton *p37;
@property (weak) IBOutlet NSButton *p40;
@property (weak) IBOutlet NSButton *p41;
@property (weak) IBOutlet NSButton *p42;
@property (weak) IBOutlet NSButton *p43;
@property (weak) IBOutlet NSButton *p44;
@property (weak) IBOutlet NSButton *p45;
@property (weak) IBOutlet NSButton *p46;
@property (weak) IBOutlet NSButton *p47;
@property (weak) IBOutlet NSButton *p50;
@property (weak) IBOutlet NSButton *p51;
@property (weak) IBOutlet NSButton *p52;
@property (weak) IBOutlet NSButton *p53;
@property (weak) IBOutlet NSButton *p54;
@property (weak) IBOutlet NSButton *p55;
@property (weak) IBOutlet NSButton *p56;
@property (weak) IBOutlet NSButton *p57;
@property (weak) IBOutlet NSButton *p60;
@property (weak) IBOutlet NSButton *p61;
@property (weak) IBOutlet NSButton *p62;
@property (weak) IBOutlet NSButton *p63;
@property (weak) IBOutlet NSButton *p64;
@property (weak) IBOutlet NSButton *p65;
@property (weak) IBOutlet NSButton *p66;
@property (weak) IBOutlet NSButton *p67;
@property (weak) IBOutlet NSButton *p70;
@property (weak) IBOutlet NSButton *p71;
@property (weak) IBOutlet NSButton *p72;
@property (weak) IBOutlet NSButton *p73;
@property (weak) IBOutlet NSButton *p74;
@property (weak) IBOutlet NSButton *p75;
@property (weak) IBOutlet NSButton *p76;
@property (weak) IBOutlet NSButton *p77;

// 枚数を表示
@property (weak) IBOutlet NSTextField *firstCounter;
@property (weak) IBOutlet NSTextField *secondCounter;

// 連戦数テキストフィールド
@property (weak) IBOutlet NSTextField *howManyGame;


- (void)startTurn; // 手番の処理
- (void)renewalImage; // 盤面の画像更新

- (IBAction)changeManual:(id)sender; // 手動かAIか切り替える tag==1:黒 2:白
- (IBAction)putPiece:(NSButton *)sender; //手動時の駒おき
- (IBAction)startNewGame:(NSButton *)sender; // NewGameボタンを押した時の挙動
- (IBAction)createRecordFile:(NSButton *)sender; // 棋譜をplist or csvファイル形式で生成する
- (IBAction)doManyGames:(id)sender;

@end
