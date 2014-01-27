//
//  ConwayGameRunner.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBConwayGameRunner.h"
#import "RBConwayNode.h"
#import "RBConwayWall.h"
#import "RBConwayCell.h"
#import "RBConwayFountainOfLife.h"

NSString * const kRBConwayGameRunnerReachedStasis = @"run out of move";

@implementation RBConwayGameRunner{

    NSMutableArray *_conwayNodes;
    NSUInteger _rows;
    NSUInteger _columns;
    NSUInteger _liveNodes;
    
    dispatch_queue_t _changingConwayNodesQueue;
}


- (id) initWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns
{
    self = [super init];
    if(self)
    {
        _conwayNodes = [NSMutableArray new];
        _rows = rows;
        _columns = columns;
        _liveNodes = 0;
        
        _changingConwayNodesQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
        
        for(int row = 0; row < _rows; row ++)
        {
            NSMutableArray *nodeRow = [NSMutableArray new];
            for(int col = 0; col < _columns; col ++)
            {
                RBConwayNode *positionNode = [[RBConwayCell alloc ]init];
                [positionNode setRow:row];
                [positionNode setColumn:col];
                
                [nodeRow addObject:positionNode];
            }
            [_conwayNodes addObject:nodeRow];
        }
        [self restartGame];
    }
    return self;
}

- (void) simulateConwayYear
{
    dispatch_sync(_changingConwayNodesQueue, ^{
        NSMutableArray *changedNodes = [NSMutableArray new];
        NSUInteger aliveNeightbors = 0;
        for(NSArray *row in _conwayNodes)
        {
            for(RBConwayNode *node in row)
            {
                aliveNeightbors = 0;
                NSUInteger nodeRow = node.row;
                NSUInteger nodeCol = node.column;
                
                /* calculate the number of neightbors */
                if(nodeRow != 0 && nodeCol != 0)
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow-1][nodeCol-1]).isAlive;
                if(nodeRow != 0)
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow-1][nodeCol]).isAlive;
                if(nodeRow != 0 && nodeCol != (_columns-1))
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow-1][nodeCol+1]).isAlive;
                
                if(nodeCol != 0)
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow][nodeCol-1]).isAlive;
                if(nodeCol != (_columns-1))
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow][nodeCol+1]).isAlive;
                
                if(nodeRow != (_rows-1) && nodeCol != 0)
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow+1][nodeCol-1]).isAlive;
                if(nodeRow != (_rows-1))
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow+1][nodeCol]).isAlive;
                if(nodeRow != (_rows-1) && nodeCol != (_columns-1))
                    aliveNeightbors += ((RBConwayNode *)_conwayNodes[nodeRow+1][nodeCol+1]).isAlive;
                
                /* checking if need update */
                BOOL posNextLife = [node willBeAliveWithNumberOfAliveNeightbors:aliveNeightbors];
                if(node.isAlive != posNextLife)
                {
                    if(posNextLife)
                        _liveNodes++;
                    else
                        _liveNodes--;
                    
                    [changedNodes addObject:node];
                }
            }
        }
        
        if(![changedNodes count])
        {
            //send out notification that game is kill
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRBConwayGameRunnerReachedStasis object:self];
        }
        for(RBConwayNode *updatedNode in changedNodes)
        {
            [updatedNode setIsAlive:!updatedNode.isAlive];
        }
    });
}

- (void) toggleNodeAtRow:(NSUInteger)row Column:(NSUInteger)column
{
    //check while not simulating use a semaphore
    dispatch_sync(_changingConwayNodesQueue, ^{
        BOOL wasAlive = ((RBConwayNode *)_conwayNodes[row][column]).isAlive;
        ((RBConwayNode *)_conwayNodes[row][column]).isAlive = !wasAlive;
        BOOL curAlive = ((RBConwayNode *)_conwayNodes[row][column]).isAlive;
        if(!wasAlive && curAlive)
        { _liveNodes++;}
        else if(wasAlive && !curAlive)
        { _liveNodes--;}
    });
}


- (void) toggleNodeAlwaysOnAtRow:(NSUInteger)row Column:(NSUInteger)column
{
    dispatch_sync(_changingConwayNodesQueue, ^{
        RBConwayNode *positionNode = _conwayNodes[row][column];
        BOOL posNodeLive = positionNode.isAlive;
        
        if(![positionNode isKindOfClass:[RBConwayFountainOfLife class]]) //if its a wall
        {
            positionNode = [[RBConwayFountainOfLife alloc] init];
            positionNode.isAlive = YES;
            positionNode.row = row;
            positionNode.column = column;
            
            [_conwayNodes[row] replaceObjectAtIndex:column withObject:positionNode];
            
            if(!posNodeLive)
            {
                _liveNodes++;
            }
            
        }
        else
        {
            positionNode = [[RBConwayCell alloc] init];
            positionNode.isAlive = NO;
            positionNode.row = row;
            positionNode.column = column;
            
            [_conwayNodes[row] replaceObjectAtIndex:column withObject:positionNode];
            
            _liveNodes--;
        }
    });
}

-(void) toggleNodeAlwaysOffAtRow:(NSUInteger)row Column:(NSUInteger)column
{
    dispatch_sync(_changingConwayNodesQueue, ^{
        RBConwayNode *positionNode = _conwayNodes[row][column];
        BOOL posNodeLive = positionNode.isAlive;
        
        if(![positionNode isKindOfClass:[RBConwayWall class]]) //if its a wall
        {
            positionNode = [[RBConwayWall alloc] init];
            positionNode.isAlive = NO;
            positionNode.row = row;
            positionNode.column = column;
            
            [_conwayNodes[row] replaceObjectAtIndex:column withObject:positionNode];
            
            if(posNodeLive)
            {
                _liveNodes--;
            }
            
        }
        else
        {
            positionNode = [[RBConwayCell alloc] init];
            positionNode.isAlive = NO;
            positionNode.row = row;
            positionNode.column = column;
            
            [_conwayNodes[row] replaceObjectAtIndex:column withObject:positionNode];
            
            _liveNodes++;
        }
    });

}

- (void) setNodeActivityToNormalAtRow:(NSUInteger)row Column:(NSUInteger)column
{
    dispatch_sync(_changingConwayNodesQueue, ^{
        RBConwayNode *positionNode = _conwayNodes[row][column];
        if(![positionNode isKindOfClass:[RBConwayCell class]]) //if its a wall
        {
            BOOL pastAlive = positionNode.isAlive;
            positionNode = [[RBConwayCell alloc] init];
            positionNode.isAlive = pastAlive;
            positionNode.row = row;
            positionNode.column = column;
            
            [_conwayNodes[row] replaceObjectAtIndex:column withObject:positionNode];
        }
    });
}




- (void) restartGame
{
    dispatch_sync(_changingConwayNodesQueue, ^{
        for(int row = 0; row < _rows; row ++)
        {
            for(int col = 0; col < _columns; col ++)
            {
                //need to make them all cells again
                BOOL preAlive = ((RBConwayNode*)_conwayNodes[row][col]).isAlive;
                [_conwayNodes[row][col] setIsAlive:NO];
                
                if(preAlive && !((RBConwayNode*)_conwayNodes[row][col]).isAlive)
                    _liveNodes--;
            }
        }
    });
}



@end
