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

- (id)createCopyOf:(MGGPiece *)aPiece
{
    int tmpBelong;
    BOOL tmpCanPut;
    tmpBelong=aPiece.belong;
    tmpCanPut=aPiece.canPut;
    
    belong=tmpBelong;
    canPut=tmpCanPut;
    
    return self;
}
@end
