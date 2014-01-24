//
//  RBConwayNode.h
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBConwayNode : NSObject

@property BOOL isAlive;
@property NSUInteger row;
@property NSUInteger column;

@end
