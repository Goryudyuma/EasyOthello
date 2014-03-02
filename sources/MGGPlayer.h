

#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGPlayer : NSObject
{
    int turn; // 自分の手番 1:黒 2:白（MGGBoardなどに合わせている)
    BOOL isManual; // 手動かどうか
}

@property BOOL isManual;

- (id)initForFirstPlayer; // 先手用(手動)
- (id)initForSecondPlayer; // 後手用(手動)

- (NSNumber *)putOnThisCoordinate:(MGGBoard *)aBoard byAI:(id)myAI; // うつ場所を決定し座標を返す

@end
