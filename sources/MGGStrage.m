

#import "MGGStrage.h"
#import "MGGSampleAI.h"
#import "MGG1AI.h"
#import "MGG2AI.h"
#import <stdio.h>

@class MGGSampleAI;
@class MGG1AI;
@class MGG2AI;

@implementation MGGStrage

@synthesize AIArray;
@synthesize gameRecord;
@synthesize freqRecord;

// 初期化
- (id)initWithNewGame
{
    gameRecord=[NSMutableArray array];
    freqRecord=[NSMutableArray array];
    AIArray=[NSArray arrayWithObjects:
             [MGGSampleAI new],[MGG1AI new],[MGG2AI new], nil];
    
    return self;
}


// 棋譜を記録する
- (void)addRecord:(NSNumber *)rec andBoard:(MGGBoard *)aBoard
{
    // index用に調整
    unsigned index=aBoard.turn-1;
    // ターン数を取得
    NSUInteger now=[gameRecord count]+1;
    
    NSArray *alpha=[NSArray arrayWithObjects:
                    @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h", nil];
    int y=[rec intValue]/10+1;
    int x=[rec intValue]%10;

    NSString *text=[NSString stringWithFormat:@"%2d %@ ",(unsigned)now,(index==0 ? @"●" : @"○")];
    text=[text stringByAppendingString:(rec==nil ? @"pass" : [NSString stringWithFormat:@"%@%d",[alpha objectAtIndex:x],y])];
    
    // 記録
    [gameRecord addObject:text];
}


// ファイルパス生成
- (NSString *)createFilePathWithExtension:(NSString *)aExtension
{
    // ドキュメントを保存する標準ディレクトリへのパスを生成する
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // ファイル名はEasyOthello+時刻とする
    NSString *fileName=@"EasyOthello";
    NSDateFormatter *fileDate=[NSDateFormatter new];
    [fileDate setDateFormat:@"yyyMMddHHmmssSSS."];
    fileName=[fileName stringByAppendingString:[fileDate stringFromDate:[NSDate date]]];
    fileName=[fileName stringByAppendingString:aExtension];
    
    return [filePath stringByAppendingPathComponent:fileName];
}


// csv生成
- (BOOL)write:(NSMutableArray *)aData ToCSV:(NSString *)filePath
{
    // csvの形式に則り記述する
    int i=1;
    FILE *fp=fopen([filePath UTF8String],"w");
    for (NSString *datum in aData) {
        // まずは分解
        // 境界を探す
        NSRange midium=[datum rangeOfString:(i%2==1 ? @" ● " : @" ○ ")];
        i++;
        // 書き出し
        if (midium.location==NSNotFound) { // 「まる」が見つからないなら結果
            midium=[datum rangeOfString:@" "];
            fprintf(fp,"\"%s\",\"%s\"\n",[[datum substringToIndex:midium.location] UTF8String],[[datum substringFromIndex:midium.location+midium.length] UTF8String]);
        } else {
            fprintf(fp,"\"%d\",\"%s\",\"%s\"\n",[[datum substringToIndex:midium.location] intValue],[[datum substringWithRange:midium] UTF8String],[[datum substringFromIndex:midium.location+midium.length] UTF8String]);
        }
    }
    
    return fclose(fp)!=EOF ? YES : NO;
}

// plistファイル生成
- (BOOL)writeToPlist:(NSString *)filePath
{
    return [gameRecord writeToFile:filePath atomically:YES];
}


// 棋譜を生成する
- (BOOL)createRecordFile
{
    BOOL comp=NO;
    
    // ファイル形式についての選択
    NSAlert *select=[NSAlert alertWithMessageText:@"SELECT" defaultButton:@".plist" alternateButton:@"Cancel" otherButton:@".csv" informativeTextWithFormat:@"Which file format will you use?"];
    
    NSModalResponse retValue=[select runModal];
    
    // キャンセル以外なら
    if (retValue!=NSAlertAlternateReturn) {
        // ファイルパス生成
        NSString *filePath=[self createFilePathWithExtension:(retValue==NSAlertDefaultReturn ? @"plist" : @"csv")];
        // ファイル書き出し
        if (retValue==NSAlertDefaultReturn) {
            comp=[self writeToPlist:filePath];
        } else {
            comp=[self write:gameRecord ToCSV:filePath];
        }
    }
    
    return comp;
}


// 棋譜の最後を編集
- (void)addFinalStringWithWinner:(int)winner
{
    NSString *text;
    if (winner==0) {
        text=@"Tied Game";
    } else {
        text=[NSString stringWithFormat:@"WINNER: %dP",winner];
    }
    
    NSUInteger last=[gameRecord count]-1; // 最後の要素番号
    // 最後はパスになっているのでそれと置き換える
    [gameRecord replaceObjectAtIndex:last withObject:text];
}


// 連戦時の勝敗表を生成(csv)
- (BOOL)writeAndOutputRecordOf:(int)winner andRemain:(int)freq
{
    
    return [self write:freqRecord ToCSV:[self createFilePathWithExtension:@"csv"]];
}

- (void)recordManyWithWinner:(int)winner andRemain:(int)remain
{
    [freqRecord addObject:[NSString stringWithFormat:@"%d %d",remain,winner]];
}
@end
