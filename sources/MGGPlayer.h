
#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGPlayer : NSObject
{
    int turn; // 自分の手番 1:黒 2:白（MGGBoardなどに合わせている)
    BOOL isManual; // 手動かどうか
    NSArray *myAI; // 使うAI
    NSUInteger AIIndex; // AIのindex
}

@property BOOL isManual;
@property (readonly) NSArray *myAI;
@property (readonly) NSUInteger AIIndex;

- (id)initForPlayer:(int)myTurn; // １：黒（先手）　２：白（後手）

- (void)changeMyAIWithIndex:(NSUInteger)index; // isManualがYESならnilを、NOなら配列をつくる。NOなら使うAIも指定する。YESのとき仮引数はなんでもよい

- (NSNumber *)putOnThisCoordinate:(MGGBoard *)aBoard; // うつ場所を決定し座標を返す

@end
