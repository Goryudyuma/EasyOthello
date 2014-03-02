

#import "MGGPlayer.h"
#import "MGGSampleAI.h"

@class MGGSampleAI;

@implementation MGGPlayer

@synthesize isManual;

- (id)initForFirstPlayer
{
    turn=1;
    isManual=YES;
    
    return self;
}

- (id)initForSecondPlayer
{
    turn=2;
    isManual=YES;
    
    return self;
}

- (NSNumber *)putOnThisCoordinate:(MGGBoard *)aBoard byAI:(id)myAI
{
    NSNumber *myCoordinate;
    //MGGBoard *AIBoard=[[MGGBoard alloc] createCopyOf:aBoard];
    
    myCoordinate=[myAI whereShouldIPutOn:[[MGGBoard alloc] createCopyOf:aBoard]]; // 書き換え部分
    
    return myCoordinate;
}
@end
