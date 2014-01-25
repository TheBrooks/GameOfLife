//
//  ConwayGameRunner.h
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRBConwayGameRunnerReachedStasis;

@interface RBConwayGameRunner : NSObject

- (id) initWithRows:(NSUInteger)rows andColumns:(NSUInteger)columns;

- (void) simulateConwayYear;
- (void) toggleNodeAtRow:(NSUInteger)row Column:(NSUInteger)column;
- (void) toggleActiveOnNodeAtRow:(NSUInteger)row Column:(NSUInteger)column;
- (void) restartGame;

@property (readonly) NSMutableArray *conwayNodes;

@end
