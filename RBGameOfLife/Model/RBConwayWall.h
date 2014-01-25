//
//  RBConwayWall.h
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/25/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBConwayNode.h"

@interface RBConwayWall : RBConwayNode

- (BOOL)willBeAliveWithNumberOfAliveNeightbors:(NSUInteger)neightbors;

@end
