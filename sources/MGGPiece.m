

#import "MGGPiece.h"

@implementation MGGPiece

@synthesize belong;
@synthesize canPut;

- (id)initWithNewGame
{
    belong=0;
    canPut=NO;
    
    return self;
}

- (MGGPiece *)createCopy
{
    MGGPiece *newPiece=[[MGGPiece alloc] init];
    newPiece.belong=belong;
    newPiece.canPut=canPut;
    
    return newPiece;
}

@end
