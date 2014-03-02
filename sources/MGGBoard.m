//
//  MGGBoard.m
//  Easy Othello
//
//  Created by 藤森浩平 on 2014/02/27.
//  Copyright (c) 2014年 藤森浩平. All rights reserved.
//

#import "MGGBoard.h"
#import "MGGPiece.h"
#define WIDTH 8
#define EMPTY 0
#define BLACK 1
#define WHITE 2

@class MGGPiece;

@implementation MGGBoard

@synthesize turn;
@synthesize board;

- (id) initWithNewGame
{
    board=[NSMutableArray array];
    
    int i,j;
    for (i=0; i<WIDTH; i++) {
        NSMutableArray *tmpA=[NSMutableArray array];
        for (j=0; j<WIDTH; j++) {
            MGGPiece *tmpP=[[MGGPiece alloc] initWithNewGame];
            if ((i==-1+WIDTH/2 && i==j) || (i==WIDTH/2 && i==j)) { // 白
                tmpP.belong=2;
            } else if ((i==-1+WIDTH/2 && j==WIDTH/2) || (i==WIDTH/2 && j==-1+WIDTH/2)) { // 黒
                tmpP.belong=1;
            }
            // 追加
            [tmpA addObject:tmpP];
        }
        // board本体に追加
        [board addObject:tmpA];
    }
    
    turn=1;
    
    return self;
}

- (BOOL)canIPutOn:(NSNumber *)aCoordinate
{
    // 座標を取得
    int y=[aCoordinate intValue]/10;
    int x=[aCoordinate intValue]%10;
    
    BOOL poss=NO; // うてるかどうか
    
    // 誰の駒であるかYES,NOで返すブロック
    // 仮引数は順に,Y座標,X座標,誰(0:空白 1:黒 2:白)
    BOOL (^whoseBlock)(int,int,int)=^(int a, int b, int whose) {
        __block BOOL isWho=NO;
        MGGPiece *tmpP2=[[board objectAtIndex:a] objectAtIndex:b];
        if (tmpP2.belong==whose) {
            isWho=YES;
        }
        return isWho;
    };
    
    // そもそも受け取った座標のところは空白かどうか
    if (whoseBlock(y,x,EMPTY)) {
        // 相手
        int enemy=(turn==BLACK ? WHITE : BLACK);
        
        NSMutableArray *cooArray=[NSMutableArray array]; // うてる方向セット
        
        int i,j,k=0;
        // まずは周囲１マスを調べる
        for (i=y-1; i<=y+1; i++) {
            for (j=x-1; j<=x+1; j++,k++) {
                // 盤面に収まっていることを確認、y,xの部分はのぞく
                if (i>=0 && i<WIDTH && j>=0 && j<WIDTH && !(i==y && j==x)) {
                    if (whoseBlock(i,j,enemy)) {
                        // cooArrayに追加
                        [cooArray addObject:[NSNumber numberWithInt:k]];
                    }
                }
            }
        }
        
        // cooArrayを高速列挙する
        // myCooに代入される値について:
        // 左上から右方向へ0,1,2,次の列左から3,4,5(ただし4は必ず入っていない),最終列左から6,7,8
        NSMutableArray *cooArray2=[NSMutableArray array];
        for (NSNumber *myCoo in cooArray) {
            switch ([myCoo intValue]) {
                case 0:
                    // 左上方向
                    for (i=y-2,j=x-2; i>=0 && j>=0; i--,j--) {
                        if (whoseBlock(i,j,EMPTY)) { // 空白なら
                            break;
                        } else if (whoseBlock(i,j,turn)) { // 自分の駒なら
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
                case 1:
                    // 上方向
                    for (i=y-2,j=x; i>=0; i--) {
                        if (whoseBlock(i,j,EMPTY)) {
                            break;
                        } else if (whoseBlock(i,j,turn)) {
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
                case 2:
                    // 右上
                    for (i=y-2,j=x+2; i>=0 && j<WIDTH; i--,j++) {
                        if (whoseBlock(i,j,EMPTY)) {
                            break;
                        } else if (whoseBlock(i,j,turn)) {
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
                case 3:
                    // 左
                    for (i=y,j=x-2; j>=0; j--) {
                        if (whoseBlock(i,j,EMPTY)) {
                            break;
                        } else if (whoseBlock(i,j,turn)) {
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
                case 5:
                    // 右
                    for (i=y,j=x+2; j<WIDTH; j++) {
                        if (whoseBlock(i,j,EMPTY)) {
                            break;
                        } else if (whoseBlock(i,j,turn)) {
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
                case 6:
                    // 左下
                    for (i=y+2,j=x-2; i<WIDTH && j>=0; i++,j--) {
                        if (whoseBlock(i,j,EMPTY)) {
                            break;
                        } else if (whoseBlock(i,j,turn)) {
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
                case 7:
                    // 下
                    for (i=y+2,j=x; i<WIDTH; i++) {
                        if (whoseBlock(i,j,EMPTY)) {
                            break;
                        } else if (whoseBlock(i,j,turn)) {
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
                case 8:
                    // 右下
                    for (i=y+2,j=x+2; i<WIDTH && j<WIDTH; i++,j++) {
                        if (whoseBlock(i,j,EMPTY)) {
                            break;
                        } else if (whoseBlock(i,j,turn)) {
                            [cooArray2 addObject:[NSNumber numberWithBool:YES]];
                            break;
                        }
                    }
                    break;
            }
        }
        
        // cooArray2の要素数を数える
        // もしうてるのならば要素数は０でない
        NSUInteger n=[cooArray2 count];
        if (n!=0) {
            poss=YES;
        }

    }
    
    return poss;
}

- (NSArray *)whereCanIPut
{
    // うてる座標を格納する配列の元
    NSMutableArray *myCandidate=[NSMutableArray array];
    
    // 盤面左上から順に更新して行く
    int i,j;
    for (i=0; i<WIDTH; i++) {
        NSMutableArray *tmpCol=[board objectAtIndex:i];
        for (j=0; j<WIDTH; j++) {
            MGGPiece *tmpPiece=[tmpCol objectAtIndex:j];
            tmpPiece.canPut=[self canIPutOn:[NSNumber numberWithInt:(i*10+j)]]; // 更新
            if (tmpPiece.canPut) {
                [myCandidate addObject:[NSNumber numberWithInt:(i*10+j)]];
            }
            // 更新したものに置き換える
            [tmpCol replaceObjectAtIndex:j withObject:tmpPiece];
        }
        // 更新したものに置き換える
        [board replaceObjectAtIndex:i withObject:tmpCol];
    }
    
    // うてる場所がなかった場合、空の配列がかえる
    return [myCandidate copy];
}

- (NSArray *)putPieceAt:(NSNumber *)aCoordinate
{
    int y=[aCoordinate intValue]/10;
    int x=[aCoordinate intValue]%10;
    
    int enemy=(turn==BLACK ? WHITE : BLACK);
    
    // 駒をおく
    NSMutableArray *tmpA=[board objectAtIndex:y];
    MGGPiece *tmpP=[tmpA objectAtIndex:x];
    
    tmpP.belong=turn;
    tmpP.canPut=NO;
    
    [tmpA replaceObjectAtIndex:x withObject:tmpP];
    [board replaceObjectAtIndex:y withObject:tmpA];
    
    // 上から時計回りに走査してひっくり返していく
    BOOL (^whoseBlock)(int,int,int)=^(int a, int b, int whose) {
        __block BOOL isWho=NO;
        MGGPiece *tmpP2=[[board objectAtIndex:a] objectAtIndex:b];
        if (tmpP2.belong==whose) {
            isWho=YES;
        }
        return isWho;
    };
    
    NSMutableArray *reverse=[NSMutableArray array];
    NSMutableArray *cndt=[NSMutableArray array];
    int i,j,k=0;
    // まずは周囲１マスを調べる
    for (i=y-1; i<=y+1; i++) {
        for (j=x-1; j<=x+1; j++,k++) {
            if (i>=0 && j>=0 && i<WIDTH && j<WIDTH && !(i==y && j==x)) {
                if (whoseBlock(i,j,enemy)) {
                    [cndt addObject:[NSNumber numberWithInt:k]];
                }
            }
        }
    }
    
    // 走査しきったあと、戻りながらひっくり返し、かつ記録していく
    for (NSNumber *tmpnum in cndt) {
        switch ([tmpnum intValue]) {
            case 0:
                // 左上
                for (i=y-2,j=x-2,k=0; i>=0 && j>=0; i--,j--) {
                    if (whoseBlock(i,j,EMPTY)) { // 途中空白があればひっくり返せない
                        k--; // フラグとして利用
                        break;
                    } else if (whoseBlock(i,j,turn)) { // 自分の駒に出会った時点で引き返す
                        break;
                    }
                }
                if (k==0 && i>=0 && j>=0) { // ひっくり返せるとき
                    for (i++,j++; i<y; i++,j++) {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]]; // ひっくり返したところリストに追加
                        // board更新
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
            case 1:
                // 上
                for (i=y-2,j=x,k=0; i>=0; i--) {
                    if (whoseBlock(i,j,EMPTY)) {
                        k--;
                        break;
                    } else if (whoseBlock(i,j,turn)) {
                        break;
                    }
                }
                if (k==0 && i>=0) {
                    for (i++; i<y; i++) {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]];
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
            case 2:
                // 右上
                for (i=y-2,j=x+2,k=0; i>=0 && j<WIDTH; i--,j++) {
                    if (whoseBlock(i,j,EMPTY)) {
                        k--;
                        break;
                    } else if (whoseBlock(i,j,turn)) {
                        break;
                    }
                }
                if (k==0 && i>=0 && j<WIDTH) {
                    for (i++,j--; i<y; i++,j--) {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]];
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
            case 3:
                // 左
                for (i=y,j=x-2,k=0; j>=0; j--) {
                    if (whoseBlock(i,j,EMPTY)) {
                        k--;
                        break;
                    } else if (whoseBlock(i,j,turn)) {
                        break;
                    }
                }
                if (k==0 && j>=0) {
                    for (j++; j<x; j++) {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]];
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
            case 5:
                //右
                for (i=y,j=x+2,k=0; j<WIDTH; j++) {
                    if (whoseBlock(i,j,EMPTY)) {
                        k--;
                        break;
                    } else if (whoseBlock(i,j,turn)) {
                        break;
                    }
                }
                if (k==0 && j<WIDTH) {
                    for (j--; j>x; j--) {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]];
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
            case 6:
                // 左下
                for (i=y+2,j=x-2,k=0; i<WIDTH && j>=0; i++,j--) {
                    if (whoseBlock(i,j,EMPTY)) {
                        k--;
                        break;
                    } else if (whoseBlock(i,j,turn)) {
                        break;
                    }
                }
                if (k==0 && i<WIDTH && j>=0) {
                    for (i--,j++; i>y; i--,j++) {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]];
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
            case 7:
                // 下
                for (i=y+2,j=x,k=0; i<WIDTH; i++) {
                    if (whoseBlock(i,j,EMPTY)) {
                        k--;
                        break;
                    } else if (whoseBlock(i,j,turn)) {
                        break;
                    }
                }
                if (k==0 && i<WIDTH) {
                    for (i--; i>y; i--)  {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]];
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
            case 8:
                // 右下
                for (i=y+2,j=x+2,k=0; i<WIDTH && j<WIDTH; i++,j++) {
                    if (whoseBlock(i,j,EMPTY)) {
                        k--;
                        break;
                    } else if (whoseBlock(i,j,turn)) {
                        break;
                    }
                }
                if (k==0 && i<WIDTH && j<WIDTH) {
                    for (i--,j--; i>y; i--,j--) {
                        tmpA=[board objectAtIndex:i];
                        tmpP=[tmpA objectAtIndex:j];
                        tmpP.belong=turn;
                        tmpP.canPut=NO;
                        [reverse addObject:[NSNumber numberWithInt:(i*10+j)]];
                        [tmpA replaceObjectAtIndex:j withObject:tmpP];
                        [board replaceObjectAtIndex:i withObject:tmpA];
                    }
                }
                break;
        }
        
    }
    
    return [reverse copy];
}

- (void)changeTurn
{
    turn=2/turn;
}

- (int)countPieceOf:(int)whom
{
    int counter=0;
    
    // 盤面を走査してカウント
    int i,j;
    for (i=0; i<WIDTH; i++) {
        for (j=0; j<WIDTH; j++) {
            MGGPiece *tmp=[[board objectAtIndex:i] objectAtIndex:j];
            if (tmp.belong==whom) {
                counter++;
            }
        }
    }
    
    return counter;
}

@end
