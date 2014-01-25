//
//  RBConwayNode.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBConwayNode.h"

@implementation RBConwayNode

- (id) init
{
    self = [super init];
    if(self)
    {
        _isAlive = NO;
        _row = -1;
        _column = -1;
    }
    return self;
}

- (BOOL)willBeAliveWithNumberOfAliveNeightbors:(NSUInteger)neightbors
{
    if(neightbors == 3 || (_isAlive && neightbors == 2))
    {
        return YES;
    }
    return NO;
}


@end
