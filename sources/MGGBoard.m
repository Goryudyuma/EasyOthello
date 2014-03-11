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
    if (self=[super init]) {
        board=[[NSMutableArray alloc] init];
        
        for (int i=0; i<WIDTH; i++) {
            NSMutableArray *tmpA=[[NSMutableArray alloc] init];
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
    }
    
    return self;
}


- (MGGBoard *)createCopy
{
    MGGBoard *newBoard=[[MGGBoard alloc] initWithNewGame];
    [newBoard.board removeAllObjects];
    for (int i=0; i<WIDTH; i++) {
        NSMutableArray *tmp=[[NSMutableArray alloc] init];
        for (int j=0; j<WIDTH; j++) {
            __weak MGGPiece *tmpP=[[board objectAtIndex:i] objectAtIndex:j];
            MGGPiece *tmpPiece=[tmpP createCopy];
            [tmp addObject:tmpPiece];
        }
        [newBoard.board addObject:tmp];
    }
    
    if (turn!=newBoard.turn) {
        [newBoard changeTurn];
    }
    
    return newBoard;
}

- (BOOL)whosePiece:(int)whose atCoordinate:(NSNumber *)aCoordinate
{
    int y=[aCoordinate intValue]/10;
    int x=[aCoordinate intValue]%10;
    
    __weak MGGPiece *tmp=[[board objectAtIndex:y] objectAtIndex:x];
    
    return tmp.belong==whose ? YES : NO;
}


// flag==YESでひっくり返す、NOで走査のみ
- (id)omitProcessWithCoordinate:(NSNumber *)aCoordinate andFlag:(BOOL)flag
{
    // y,x座標からNSNumberクラスのオブジェクトで表された座標に変換するブロック
    NSNumber *(^makeCooBlock)(int,int)=^(int s, int t) {
        return [NSNumber numberWithInt:s*10+t];
    };
    
    NSMutableArray *report=[[NSMutableArray alloc] init];
    NSNumber *canPut=[[NSNumber alloc] initWithBool:NO];
    
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
                            for (a-=dy,b-=dx; a!=y || b!=x; a-=dy,b-=dx) {
                                __weak MGGPiece *tmpP=[[board objectAtIndex:a] objectAtIndex:b];
                                tmpP.belong=turn;
                                tmpP.canPut=NO;
                                [report addObject:makeCooBlock(a,b)];
                            }
                            break;

                        }
                    } else {
                        if (![self whosePiece:enemy atCoordinate:makeCooBlock(a,b)]) {
                            if ([canPut boolValue]) continue;
                            canPut=[NSNumber numberWithBool:[self whosePiece:turn atCoordinate:makeCooBlock(a,b)]];
                            break;
                        }
                    }
                }
            }
        }
    }
    return flag ? report : canPut;
}

- (BOOL)canIPutOn:(NSNumber *)aCoordinate
{
    BOOL poss=NO; // うてるかどうか
    
    if ([self whosePiece:EMPTY atCoordinate:aCoordinate]) { // そもそもその座標は空白か
        NSNumber *tmp=[self omitProcessWithCoordinate:aCoordinate andFlag:NO];
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
    NSMutableArray *myCandidate=[[NSMutableArray alloc] init];
    
    // 盤面左上から順に更新して行く
    for (int i=0; i<WIDTH; i++) {
        for (int j=0; j<WIDTH; j++) {
            __weak MGGPiece *tmpPiece=[[board objectAtIndex:i] objectAtIndex:j];
            tmpPiece.canPut=[self canIPutOn:makeCooBlock(i,j)]; // 更新
            if (tmpPiece.canPut) {
                [myCandidate addObject:makeCooBlock(i,j)];
            }
        }
    }
    
    // うてる場所がなかった場合、空の配列がかえる
    return myCandidate;
}


- (NSMutableArray *)putPieceAt:(NSNumber *)aCoordinate
{
    NSMutableArray *tmp=[[NSMutableArray alloc] init];
    NSNumber *tmpNum=aCoordinate;
    
    if ([self canIPutOn:tmpNum]) {

        int y=[tmpNum intValue]/10;
        int x=[tmpNum intValue]%10;

        // 駒をおく
        __weak MGGPiece *tmpP=[[board objectAtIndex:y] objectAtIndex:x];
        tmpP.belong=turn;
        tmpP.canPut=NO;
        tmp=[self omitProcessWithCoordinate:tmpNum andFlag:YES];

    }
    
    // ひっくり返したところ一覧
    // もしAIが不正な場所を指定した場合、空の配列がかえる
    return tmp;
}


- (void)changeTurn
{
<<<<<<< HEAD
    turn=2/turn;
=======
    turn=turn==BLACK ? WHITE : BLACK;
>>>>>>> a40dec057093d9cfd606f4ae09d3f2652909070a
}


- (int)countPieceOf:(int)whom
{
    int counter=0;
    
    // 盤面を走査してカウント
    int i,j;
    for (i=0; i<WIDTH; i++) {
        for (j=0; j<WIDTH; j++) {
            __weak MGGPiece *tmp=[[board objectAtIndex:i] objectAtIndex:j];
            if (tmp.belong==whom) {
                counter++;
            }
        }
    }
    
    return counter;
}

@end
