
#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGStrage : NSObject
{
    NSMutableArray *gameRecord; // 棋譜の記録のための可変配列
    NSMutableArray *freqRecord; // 連戦時の勝敗記録
    NSArray *AIArray; // AI集
}

@property (readonly) NSArray *AIArray;
@property NSMutableArray *gameRecord;
@property (readonly) NSMutableArray *freqRecord;

- (id)initWithNewGame; // 新規対局用の初期化

// このターンの棋譜を追加する。パスの時はrecをnilにしてください
- (void)addRecord:(NSNumber *)rec andBoard:(MGGBoard *)aBoard;

// 終了時の棋譜への編集
// 仮引数はGameMasterの勝敗フラグ
- (void)addFinalStringWithWinner:(int)winner;

// 標準ドキュメントディレクトリへのパスを生成する。
// 仮引数は拡張子（plist または csv)
- (NSString *)createFilePathWithExtension:(NSString *)aExtension;

// csvファイルを生成する
// 生成に成功すればYESを返す
- (BOOL)write:(NSMutableArray *)aData ToCSV:(NSString *)filePath;

// plistファイル生成の独自メソッド
- (BOOL)writeToPlist:(NSString *)filePath;

// 棋譜ファイルを生成する。
// 成功するとYESを返す
- (BOOL)createRecordFile;

// 連戦時の勝敗記録、書き出し
- (BOOL)writeAndOutputRecordOf:(int)winner andRemain:(int)freq;

// 連戦時の記録
- (void)recordManyWithWinner:(int)winner andRemain:(int)remain;

@end
