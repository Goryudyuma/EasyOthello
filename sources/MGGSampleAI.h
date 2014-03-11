

#import <Foundation/Foundation.h>
#import "MGGAIDelegate.h"

// サンプルAI
// うてる候補のなかからランダムでおいていく
@interface MGGSampleAI : NSObject <MGGAIDelegate>

- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard;

@end
