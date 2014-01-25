//
//  ConwayGameRunner.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBConwayGameRunner.h"
#import "RBConwayNode.h"

@implementation RBConwayGameRunner{

    NSMutableArray *_conwayNodes;
    NSUInteger _rows;
    NSUInteger _columns;
}


- (id) initWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns
{
    self = [super init];
    if(self)
    {
        _conwayNodes = [NSMutableArray new];
        _rows = rows;
        _columns = columns;
        
        for(int row = 0; row < _rows; row ++)
        {
            NSMutableArray *nodeRow = [NSMutableArray new];
            for(int col = 0; col < _columns; col ++)
            {
                RBConwayNode *positionNode = [[RBConwayNode alloc ]init];
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
            if(node.isAlive != [node willBeAliveWithNumberOfAliveNeightbors:aliveNeightbors])
               [changedNodes addObject:node];

        }
    }
    
    if(!changedNodes)
    {
        //send out notification that game is kill
    }
    for(RBConwayNode *updatedNode in changedNodes)
    {
        updatedNode.isAlive = !updatedNode.isAlive;
    }
}

- (void) toggleNodeAtRow:(NSUInteger)row Column:(NSUInteger)column
{
    //check while not simulating use a semaphore
    if(true)
    {
        ((RBConwayNode *)_conwayNodes[row][column]).isAlive = !((RBConwayNode *)_conwayNodes[row][column]).isAlive;
    }
}


- (void) restartGame
{
    
    for(int row = 0; row < _rows; row ++)
    {
        for(int col = 0; col < _columns; col ++)
        {
            [_conwayNodes[row][col] setIsAlive:NO];
        }
    }
    

}
@end
