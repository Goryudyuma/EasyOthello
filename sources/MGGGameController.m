

#import "MGGGameController.h"
#import "MGGPiece.h"
#define BLACK 1
#define WHITE 2
#define GAMEOVER -1
#define PASS -2
#define MANUAL -3
#define END -4

@class MGGPiece;

@implementation MGGGameController

@synthesize mainBoard;
@synthesize firstPlayer;
@synthesize secondPlayer;
@synthesize ourMaster;
@synthesize ourStorage;

- (id)initForLaunching
{
    if (self=[self initForNewGame]) {
        firstPlayer=[[MGGPlayer alloc] initForPlayer:BLACK];
        secondPlayer=[[MGGPlayer alloc] initForPlayer:WHITE];
    }
    
    return self;
}

- (id)initForNewGame
{
    if (self=[super init]) {
        mainBoard=[[MGGBoard alloc] initWithNewGame];
        ourMaster=[[MGGGameMaster alloc] initWithNewGame];
        ourStorage=[[MGGStrage alloc] initWithNewGame];
    }
    
    return self;
}

- (id)initForSeriesGame
{
    NSMutableArray *tmp=ourStorage.freqRecord;
    int tmpNum=ourMaster.frequency;
    if (self=[self initForNewGame]) {
        ourStorage.freqRecord=tmp;
        ourMaster.frequency=tmpNum;
    }
    
    return self;
}

- (NSNumber *)playerTurnIsStarted
{
    // メインボードの盤面情報を更新する
    [mainBoard whereCanIPut];
    __weak MGGPlayer *thisPlayer = mainBoard.turn==BLACK ? firstPlayer : secondPlayer;
    NSNumber *judgement;
    // GameMasterにゲームの今後の進行をどうするか尋ねる
    if ([ourMaster shouldWeFinishGameWithBoard:mainBoard]) {
        // ゲーム終了なら
        judgement=[[NSNumber alloc] initWithInt:GAMEOVER];
    } else if (ourMaster.passCount!=0) {
        // パスなら
        judgement=[[NSNumber alloc] initWithInt:PASS];
    } else if (thisPlayer.isManual) {
        // 手動なら
        judgement=[[NSNumber alloc] initWithInt:MANUAL];
    } else {
        // AIなら
        // AIにうつ場所を決定させ、その座標を入れる
        judgement=[thisPlayer putOnThisCoordinate:mainBoard];
    }
    
    return judgement;
}

- (NSArray *)playerTurnWillBeFinishedWithCandidate:(NSNumber *)aCand
{
    NSNumber *tmpNum=aCand;
    NSMutableArray *reverse=[[NSMutableArray alloc] init];
    // nil（不正な場所を指定された）なら空の配列を返す(パスでも空の配列)
    if (tmpNum!=nil) {
        if ([tmpNum intValue]>=0) { // パスでないなら
            reverse=[mainBoard putPieceAt:tmpNum];
            // うった場所も加えておく
            [reverse addObject:tmpNum];
        }
        // 棋譜に記録
        [ourStorage addRecord:([tmpNum intValue]>=0 ? tmpNum : nil) andBoard:mainBoard];
    }
    
    // ターン変更
    [mainBoard changeTurn];
    
    return [reverse copy];
}

- (void)gameIsOverWithRemain:(NSNumber *)remain
{
    int rem=[remain intValue];
    
    // 棋譜の最後はパスになっているので置き換える
    [ourStorage addFinalStringWithWinner:ourMaster.winner];
    // 勝敗表に追記
    [ourStorage recordManyWithWinner:ourMaster.winner andRemain:rem+1];
    
    // 連戦が終了したら勝敗表を生成
    if (rem==ourMaster.frequency-1 && ourMaster.frequency!=1) {
        [ourStorage makeTitle];
        [ourStorage outputSeriesOfGame];
    }
    
}
@end
