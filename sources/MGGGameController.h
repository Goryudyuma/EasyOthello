
#import <Foundation/Foundation.h>
#import "MGGBoard.h"
#import "MGGPlayer.h"
#import "MGGGameMaster.h"
#import "MGGStrage.h"

@class MGGBoard;
@class MGGPlayer;
@class MGGGameMaster;
@class MGGStrage;

@interface MGGGameController : NSObject
{
    MGGBoard *mainBoard; // 試合に使う盤面
    MGGPlayer *firstPlayer, *secondPlayer; // 先手、後手
    MGGGameMaster *ourMaster; // ゲームの状況判断を司る
    MGGStrage *ourStorage; // 各種記録を格納する為のオブジェクト
    
}

@property (readonly,nonatomic) MGGBoard *mainBoard;
@property (readonly,nonatomic) MGGPlayer *firstPlayer;
@property (readonly,nonatomic) MGGPlayer *secondPlayer;
@property (readonly,nonatomic) MGGGameMaster *ourMaster;
@property (readonly,nonatomic) MGGStrage *ourStorage;


// アプリ起動時の初期化処理
- (id)initForLaunching;

// NewGameボタンが押された時の初期化処理
// 指名イニシャライザ
- (id)initForNewGame;

// 連戦途中の初期化
- (id)initForSeriesGame;

// 手番開始の処理
// 戻り値は-1で終了、-2でパス、-3で手動、それ以外はAIの決定した座標
- (NSNumber *)playerTurnIsStarted;

// 手番終了の処理
// 戻り値は画像を更新すべき箇所の一覧
- (NSArray *)playerTurnWillBeFinishedWithCandidate:(NSNumber *)aCand;

// 対局終了処理
// 主に棋譜の編集
- (void)gameIsOverWithRemain:(NSNumber *)remain;

@end
