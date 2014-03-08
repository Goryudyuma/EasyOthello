

#import "MGGPlayer.h"
#import "MGGSampleAI.h"
#import "MGG1AI.h"
#import "MGG2AI.h"
#define END -4

@class MGGSampleAI;
@class MGG1AI;
@class MGG2AI;

@implementation MGGPlayer

@synthesize isManual;
@synthesize myAI;
@synthesize AIIndex;

- (id)initForPlayer:(int)myTurn
{
    turn=myTurn;
    isManual=YES;
    myAI=nil;
    AIIndex=0;
    
    return self;
}

- (void)changeMyAIWithIndex:(NSUInteger)index
{
    if (isManual) {
        myAI=nil;
    } else {
        // まだ配列が作られていない時だけ配列を作る
        if ([myAI count]==0) {
            myAI=[NSArray arrayWithObjects:
                  [MGGSampleAI new],[MGG1AI new],[MGG2AI new], nil];
        }
        AIIndex=index;
    }
}


- (NSNumber *)putOnThisCoordinate:(MGGBoard *)aBoard
{
    NSNumber *myCoordinate=[[myAI objectAtIndex:AIIndex] whereShouldIPutOn:[aBoard createCopy]];
    
    // 不正な場所をAIが指定した場合は-4を返す
    return [aBoard canIPutOn:myCoordinate] ? myCoordinate : [NSNumber numberWithInt:-4];
}

@end
