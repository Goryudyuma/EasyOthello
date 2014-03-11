

#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@protocol MGGAIDelegate <NSObject>
@required
// このメソッド内でうつ場所を決定する
// MGGBoardクラスのオブジェクトとして現在の盤面を受け取る
// 最終的にうつと決定したY,X座標(y,x)を使って
// このメソッド内の最終行は、
// return [NSNumber numberWithInt:(y*10+x)]
// としてください。
- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard;

@end
