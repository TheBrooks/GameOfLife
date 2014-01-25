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
        _row = 0;
        _column = 0;
    }
    return self;
}


@end
