//
//  RBConwayWall.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/25/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBConwayWall.h"

@implementation RBConwayWall

- (id) init
{
    self = [super init];
    if (self)
    {
        self.isAlive = NO;
    }
    return self;
}
- (void) setIsAlive:(BOOL)isAlive{
    [super setIsAlive:NO];
}
-(BOOL) isAlive {return NO;};

- (BOOL)willBeAliveWithNumberOfAliveNeightbors:(NSUInteger)neightbors
{
    return NO;
}

@end
