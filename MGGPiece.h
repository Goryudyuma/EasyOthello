//
//  MGGPiece.h
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGGPiece : NSObject
{
    int belong; // 駒の所属 0:空白 1:黒 2:白
    BOOL canPut; // うてるかどうか
}

@property int belong;
@property BOOL canPut;

- (id)initWithNewGame; // 新規対局用に初期化（空白、うてない）

@end
