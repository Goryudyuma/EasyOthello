#import <Foundation/Foundation.h>

@interface MGGBoard : NSObject
{
    NSMutableArray *board; // 盤面(可変二次配列)
    int turn; // 誰の手番か。1:黒 2:白
}

@property (readonly) int turn;
@property (readonly,strong) NSMutableArray *board;

- (MGGBoard *)initWithNewGame; // 新規対局用に初期化

- (MGGBoard *)createCopy; // コピーを作る(-copyとは違う)

- (BOOL)whosePiece:(int)whose atCoordinate:(NSNumber *)aCoordinate; // 受け取った座標の駒の所属を返す
- (id)omitProcessWithCoordinate:(NSNumber *)aCoordinate andFlag:(BOOL)flag; // 部品です。
- (BOOL)canIPutOn:(NSNumber *)aCoordinate; // NSNumberクラスのオブジェクト(y*10+x)として渡された座標にうてるかどうかを返す
- (NSArray *)whereCanIPut; // うてる場所一覧を返す。うてなければ空の配列がかえる
- (NSMutableArray *)putPieceAt:(NSNumber *)aCoordinate; // 受け取った座標に駒をうつ。それによってひっくり返した位置をまとめて配列にして返す
- (void)changeTurn; // 手番交代
- (int)countPieceOf:(int)whom; // whose(0:空白 1:黒 2:白)の駒の数を調べて返す
@end
