
#import <Foundation/Foundation.h>

@interface MGGPiece : NSObject
{
    int belong; // 駒の所属 0:空白 1:黒 2:白
    BOOL canPut; // うてるかどうか
}

@property int belong;
@property BOOL canPut;

- (id)initWithNewGame; // 新規対局用に初期化（空白、うてない）

- (MGGPiece *)createCopy; // コピーを作る

@end
