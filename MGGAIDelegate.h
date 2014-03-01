//
//  MGGAIDelegate.h
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGGBoard.h"

@class MGGBoard;

@protocol MGGAIDelegate <NSObject>
@required
// このメソッド内でうつ場所を決定する
// MGGBoardクラスのオブジェクトとして現在の盤面を受け取る
// 最終的にうつと決定したY,X座標(y,x)を使って
// このメソッド内の最終行は、
// return [NSNumber numberWithInt:(y*10+x)]
// としてください。
- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard;

@end
