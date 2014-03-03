EasyOthello
===========

何がEasyなのかよくわからないがとりあえずオセロ

更新予定
===========
連戦機能の改善

AIの仕様
===========
独自クラス名.h .m ファイルの２種類を作る

.hファイル↓

#import <Foundation/Foundation.h>
#import "MGGAIDelegate.h"
#import "MGGBoard.h"

@class MGGBoard;

@interface 独自クラス名 : NSObject <MGGAIDelegate>
{
	// ここに値を保持したい変数を宣言（グローバル変数のような使い方ができます）
}

- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard;

@end



.mファイル↓

#import "独自クラス名.h"

@implementation 独自クラス名

- (NSNumber *)whereShouldIPutOn:(MGGBoard *)aBoard
{
	// ここに処理を記述


	return [NSNumber numberWithInt:y*10+x];
}

@end