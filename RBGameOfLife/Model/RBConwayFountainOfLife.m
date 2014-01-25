//
//  RBConwayFountainOfLife.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/25/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBConwayFountainOfLife.h"

@implementation RBConwayFountainOfLife

- (id) init
{
    self = [super init];
    if (self)
    {
        self.isAlive = YES;
    }
    return self;
}
- (void) setIsAlive:(BOOL)isAlive{
    [super setIsAlive:YES];
}
-(BOOL) isAlive {return YES;};

- (BOOL)willBeAliveWithNumberOfAliveNeightbors:(NSUInteger)neightbors
{
    return YES;
}


@end
