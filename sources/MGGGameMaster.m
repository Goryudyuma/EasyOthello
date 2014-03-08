

#import "MGGGameMaster.h"
#define BLACK 1
#define WHITE 2

@implementation MGGGameMaster

@synthesize isOnGame;
@synthesize passCount;
@synthesize  winner;
@synthesize frequency;

- (id)initWithNewGame
{
    passCount=0;
    isOnGame=YES;
    winner=0;
    frequency=1;
    
    return self;
}

- (BOOL)shouldWeFinishGameWithBoard:(MGGBoard *)aBoard
{
    // 受け取った配列の要素数を調べる
    // 要素数が0==パス
    NSUInteger n=[[aBoard whereCanIPut] count];
    if (n==0) {
        passCount++;
        if (passCount==2) { // ２連続パスで終局
            isOnGame=NO;
            
            // 勝者を決めるため盤面上の駒の数を数える
            int black=[aBoard countPieceOf:BLACK];
            int white=[aBoard countPieceOf:WHITE];
            winner=black>white ? BLACK : WHITE;

            if (frequency==1) {
                NSString *text;
                if (black==white) { // 引き分け
                    text=@"A tied game.";
                } else {
                    text=[NSString stringWithFormat:@"WINNER : %dP",winner];
                }
                NSAlert *result=[NSAlert alertWithMessageText:@"RESULT" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@",text];
                
                [result runModal];
            }
        }
    } else { // パスでない
        passCount=0; // カウンタリセット
    }
    
    return !isOnGame;
}
@end
