

#import "MGGPlayer.h"
#import "MGGSampleAI.h"

@class MGGSampleAI;

@implementation MGGPlayer

@synthesize isManual;
@synthesize myAI;

- (id)initForPlayer:(int)myTurn
{
    turn=myTurn;
    isManual=YES;
    myAI=nil;
    
    return self;
}


- (NSNumber *)putOnThisCoordinate:(MGGBoard *)aBoard
{
    NSNumber *myCoordinate;
    //MGGBoard *AIBoard=[[MGGBoard alloc] createCopyOf:aBoard];
    
    myCoordinate=[myAI whereShouldIPutOn:[[MGGBoard alloc] createCopyOf:aBoard]];
    
    // 不正な場所をAIが指定した場合はnilを返す
    return [aBoard canIPutOn:myCoordinate] ? myCoordinate : nil;
}
@end
