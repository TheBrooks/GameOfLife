//
//  RBConwayCell.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/25/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBConwayCell.h"

@implementation RBConwayCell


- (BOOL)willBeAliveWithNumberOfAliveNeightbors:(NSUInteger)neightbors
{
    if(neightbors == 3 || (self.isAlive && neightbors == 2))
    {
        return YES;
    }
    return NO;
}


@end
