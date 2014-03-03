
#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGPlayer : NSObject
{
    int turn; // 自分の手番 1:黒 2:白（MGGBoardなどに合わせている)
    BOOL isManual; // 手動かどうか
    id myAI; // 使うAI
}

@property BOOL isManual;
@property id myAI;

- (id)initForPlayer:(int)myTurn; // １：黒（先手）　２：白（後手）

- (NSNumber *)putOnThisCoordinate:(MGGBoard *)aBoard; // うつ場所を決定し座標を返す

@end
