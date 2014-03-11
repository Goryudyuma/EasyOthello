#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGGameMaster : NSObject
{
    unsigned passCount; // 連続パスの回数
    BOOL isOnGame; // ゲーム中であるか
    int winner; // 勝者。０：引き分け 1:黒 2:白
    int frequency; // 連戦数
}

@property (readonly) BOOL isOnGame;
@property (readonly) unsigned passCount;
@property (readonly) int winner;
@property int frequency;

- (id)initWithNewGame; // 初期化

// 終局でないかどうかを返す(YESで終局)。
// 仮引数はこのターンのボード。
- (BOOL)shouldWeFinishGameWithBoard:(MGGBoard *)aBoard;

@end
