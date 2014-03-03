

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
    
    for (int i=0; i<WIDTH; i++) {
        NSMutableArray *tmpA=[NSMutableArray array];
        for (int j=0; j<WIDTH; j++) {
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
    
    turn=BLACK;
    
    return self;
}


- (id)createCopyOf:(MGGBoard *)aBoard
{
    turn=aBoard.turn;
    board=[NSMutableArray array];
    for (NSMutableArray *row in aBoard.board) {
        NSMutableArray *tmpA=[NSMutableArray array];
        for (MGGPiece *origin in row) {
            MGGPiece *tmpP=[[MGGPiece alloc] createCopyOf:origin];
            [tmpA addObject:tmpP];
        }
        [board addObject:tmpA];
    }
    
    return self;
}

- (BOOL)whosePiece:(int)whose atCoordinate:(NSNumber *)aCoordinate
{
    int y=[aCoordinate intValue]/10;
    int x=[aCoordinate intValue]%10;
    
    MGGPiece *tmp=[[board objectAtIndex:y] objectAtIndex:x];
    
    return tmp.belong==whose ? YES : NO;
}


// flag==YESでひっくり返す、NOで走査のみ
- (id)omitProcessWithCoordinate:(NSNumber *)aCoordinate andMore:(id)something andFlag:(BOOL)flag
{
    // y,x座標からNSNumberクラスのオブジェクトで表された座標に変換するブロック
    NSNumber *(^makeCooBlock)(int,int)=^(int s, int t) {
        return [NSNumber numberWithInt:s*10+t];
    };
    
    int enemy = turn==BLACK ? WHITE : BLACK;
    // 座標を取得
    int y=[aCoordinate intValue]/10;
    int x=[aCoordinate intValue]%10;
    
    // 左上から調べていく
    for (int i=y-1; i<=y+1; i++) {
        for (int j=x-1; j<=x+1; j++) {
            // おこうとしている場所と盤面外はのぞく
            if ((i==y && j==x) || i<0 || j<0 || i>=WIDTH || j>=WIDTH) continue;
            
            // まずは周囲１マスに相手の駒があるか走査、あれば引き続き調べる
            if ([self whosePiece:enemy atCoordinate:makeCooBlock(i,j)]) {
                for (int a=i,b=j,dy=i-y,dx=j-x; a>=0 && a<WIDTH && b>=0 && b<WIDTH; a+=dy,b+=dx) {
                    // flag==YESのときひっくり返す
                    // flag==NOのとき走査のみ
                    if (flag) {
                        if ([self whosePiece:EMPTY atCoordinate:makeCooBlock(a,b)]) { // 空白ならbreak
                            break;
                        } else if ([self whosePiece:turn atCoordinate:makeCooBlock(a,b)]) { // 自分の駒なら
                            // ひっくり返しながらかえる
                            MGGPiece *tmpP;
                            for (a-=dy,b-=dx; a!=y || b!=x; a-=dy,b-=dx) {
                                tmpP=[[board objectAtIndex:a] objectAtIndex:b];
                                tmpP.belong=turn;
                                tmpP.canPut=NO;
                                [something addObject:makeCooBlock(a,b)];
                            }
                            break;

                        }
                    } else {
                        if (![self whosePiece:enemy atCoordinate:makeCooBlock(a,b)]) {
                            if ([something boolValue]==YES) continue;
                            something=[NSNumber numberWithBool:[self whosePiece:turn atCoordinate:makeCooBlock(a,b)]];
                            break;
                        }
                    }
                }
            }
        }
    }
    return something;
}

- (BOOL)canIPutOn:(NSNumber *)aCoordinate
{
    BOOL poss=NO; // うてるかどうか
    
    if ([self whosePiece:EMPTY atCoordinate:aCoordinate]) { // そもそもその座標は空白か
        id tmp=[self omitProcessWithCoordinate:aCoordinate andMore:[NSNumber numberWithBool:poss] andFlag:NO];
        poss=[tmp boolValue];
    }

    
    return poss;
}


- (NSArray *)whereCanIPut
{
    // y,x座標からNSNumberクラスのオブジェクトの座標に変換するブロック
    NSNumber *(^makeCooBlock)(int,int)=^(int s,int t) {
        return [NSNumber numberWithInt:s*10+t];
    };
    
    // うてる座標を格納する配列の元
    NSMutableArray *myCandidate=[NSMutableArray array];
    
    // 盤面左上から順に更新して行く
    for (int i=0; i<WIDTH; i++) {
        for (int j=0; j<WIDTH; j++) {
            MGGPiece *tmpPiece=[[board objectAtIndex:i] objectAtIndex:j];
            tmpPiece.canPut=[self canIPutOn:makeCooBlock(i,j)]; // 更新
            if (tmpPiece.canPut) {
                [myCandidate addObject:makeCooBlock(i,j)];
            }
        }
    }
    
    // うてる場所がなかった場合、空の配列がかえる
    return [myCandidate copy];
}


- (NSArray *)putPieceAt:(NSNumber *)aCoordinate
{
    // ひっくり返したところ一覧
    // もしAIが不正な場所を指定した場合、空の配列がかえる
    NSMutableArray *reverse=[NSMutableArray array];
    if ([self canIPutOn:aCoordinate]) {

        int y=[aCoordinate intValue]/10;
        int x=[aCoordinate intValue]%10;

        // 駒をおく
        MGGPiece *tmpP=[[board objectAtIndex:y] objectAtIndex:x];
        tmpP.belong=turn;
        tmpP.canPut=NO;
        id tmp=[self omitProcessWithCoordinate:aCoordinate andMore:[NSMutableArray array] andFlag:YES];
        reverse=[NSMutableArray arrayWithArray:tmp];

    }
    
    return [reverse copy];
}


- (void)changeTurn
{
    turn=turn==BLACK ? WHITE : BLACK;
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
