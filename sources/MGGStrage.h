
#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@interface MGGStrage : NSObject
{
    NSMutableArray *gameRecord; // 棋譜の記録のための可変配列
    NSMutableArray *freqRecord; // 連戦時の勝敗記録
    NSString *title; // 連戦時の記録ファイル名保持用
}

@property NSMutableArray *gameRecord;
@property NSMutableArray *freqRecord;

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
// filePathがnilを受け取った場合はtitleへの追記とする
- (BOOL)write:(NSMutableArray *)aData ToCSV:(NSString *)filePath;

// plistファイル生成の独自メソッド
- (BOOL)writeToPlist:(NSString *)filePath;

// 棋譜ファイルを生成する。
// 成功するとYESを返す
- (BOOL)createRecordFile;

// 連戦時の記録
- (void)recordManyWithWinner:(int)winner andRemain:(int)remain;

// AI同士の連戦データの書き出しファイル名の決定
// ファイル名はEasyOthello+1PのAIindex+vs+2PのAIindex+in+ファイル名作成時の時間.csvとする
// 仮引数は順に1PのAIのindex,2PのAIのindex
// 同時にファイルも作成する
- (void)makeTitle;

// 連戦時の記録をファイルへ書き出す
// 書き出したあとにデータを保持していた配列を初期化する
- (void)outputSeriesOfGame;
@end
