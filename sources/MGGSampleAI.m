

#import "MGGSampleAI.h"
#import <time.h>
#import <stdlib.h>

@implementation MGGSampleAI

- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard
{
    // うてる場所一覧を取得
    NSArray *cndt=[aBoard whereCanIPut];
    
    // 同じ乱数を防ぐ
    if (!srandFlag) {
        srand((unsigned)time(NULL));
        srandFlag=YES;
    }
    
    NSUInteger n=[cndt count];
    
    // うつ場所をランダムで決める
    return [cndt objectAtIndex:rand()%n];
}
@end
