

#import "MGGStrage.h"
#import "MGGSampleAI.h"
#import "MGG1AI.h"
#import <stdio.h>

@class MGGSampleAI;
@class MGG1AI;

@implementation MGGStrage

@synthesize AIArray;
@synthesize gameRecord;
@synthesize freqRecord;

- (id)initWithNewGame
{
    gameRecord=[NSMutableArray array];
    freqRecord=[NSMutableArray array];
    AIArray=[NSArray arrayWithObjects:
             [MGGSampleAI new],[MGG1AI new], nil];
    
    return self;
}

- (void)addRecord:(NSNumber *)rec andBoard:(MGGBoard *)aBoard
{
    // index用に調整
    unsigned index=aBoard.turn-1;
    // ターン数を取得
    NSUInteger now=[gameRecord count]+1;
    NSArray *alpha=[NSArray arrayWithObjects:
                    @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h", nil];
    NSString *text;
    if (rec==nil) { // パスのとき
        text=[NSString stringWithFormat:@"%02u %@ %@",(unsigned)now,(index==0 ? @"●" : @"○"),@"pass"];
    } else {
        int y=[rec intValue]/10+1;
        int x=[rec intValue]%10;
        text=[NSString stringWithFormat:@"%02u %@ %@%d",(unsigned)now,(index==0 ? @"●" : @"○"),[alpha objectAtIndex:x],y];
    }
    
    // 記録
    [gameRecord addObject:text];
}

- (BOOL)createRecordFileAt:(NSString *)pass withFormat:(NSModalResponse)format
{
    BOOL comp=NO;
    
    if (format==NSAlertDefaultReturn) { // .plist
        comp=[gameRecord writeToFile:pass atomically:YES];
    } else if (format==NSAlertOtherReturn) { // .csv
        FILE *fp;
        fp=fopen([pass UTF8String],"w");
        fprintf(fp," \n");
        fclose(fp);
        fp=fopen([pass UTF8String],"a");
        NSUInteger turnIndex; // ターン数の部分
        NSRange playerRange; // 黒、白の部分
        NSUInteger posIndex; // 残り
        NSString *turn,*player,*other;
        int i;
        NSUInteger max=[gameRecord count]-1;
        for (i=0; i<max; i++) {
            NSString *tmp=[gameRecord objectAtIndex:i];
            
            // まずはレンジを取得
            playerRange=[tmp rangeOfString:@"●"];
            if (playerRange.location==NSNotFound) {
                playerRange=[tmp rangeOfString:@"○"];
            }
            turnIndex=playerRange.location-1;
            posIndex=playerRange.location+2;
            
            // もう一度分解
            turn=[tmp substringToIndex:turnIndex];
            player=[tmp substringWithRange:playerRange];
            other=[tmp substringFromIndex:posIndex];
            // csvの形式に則り記述していく
            fprintf(fp,"\"%d\",\"%s\",\"%s\"\n",[turn intValue],[player UTF8String],[other UTF8String]);
        }
        // 最後は結果を入れる
        NSRange space;
        NSString *tmp=[gameRecord objectAtIndex:max];
        space=[tmp rangeOfString:@" "];
        NSString *before,*after;
        before=[tmp substringToIndex:space.location];
        after=[tmp substringFromIndex:space.location+1];
        fprintf(fp,"\"%s\",\"%s\"",[before UTF8String],[after UTF8String]);
        comp=fclose(fp)==EOF ? NO : YES;
    }
    
    return comp;
}

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

- (BOOL)writeAndOutputRecordOf:(int)winner andRemain:(int)freq
{
    BOOL comp=NO;
    
        NSString *text=[NSString stringWithFormat:@"\"%d\",\"%d\"",freq,winner];
        [freqRecord addObject:text];
    if (freq<=1) {
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSDateFormatter *fileDF=[NSDateFormatter new];
        [fileDF setDateFormat:@"yyyMMddHHmmssSSS"];
        NSString *filename=@"EasyOthello";
        filename=[filename stringByAppendingString:[fileDF stringFromDate:[NSDate date]]];
        filename=[filename stringByAppendingString:@".csv"];
        path=[path stringByAppendingPathComponent:filename];
        FILE *fp;
        fp=fopen([path UTF8String],"w");
        fprintf(fp," \n");
        fclose(fp);
        fp=fopen([path UTF8String],"a");
        for (NSString *tmp in freqRecord) {
            fprintf(fp,"%s\n",[tmp UTF8String]);
        }
        comp=YES;
        fclose(fp);
    }
    
    return comp;
}
@end
