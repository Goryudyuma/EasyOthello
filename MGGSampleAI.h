//
//  MGGSampleAI.h
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGGAIDelegate.h"

// サンプルAI
// うてる候補のなかからランダムでおいていく
@interface MGGSampleAI : NSObject <MGGAIDelegate>

- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard;

@end
