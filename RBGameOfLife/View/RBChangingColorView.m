//
//  RBAgingColorView.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBChangingColorView.h"

@implementation RBChangingColorView
{
    NSUInteger _age;
    
    NSUInteger _red;
    NSUInteger _green;
    NSUInteger _blue;
    
    double _redBaseFactor;
    double _greenBaseFactor;
    double _blueBaseFactor;
    
    UIColor *_color;
    BOOL _isActive;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _age = 0;
        _isActive = NO;
        
        _red = 255;
        _green = 255;
        _blue = 255;
        
        _redBaseFactor = 1;
        _greenBaseFactor = 1;
        _blueBaseFactor = 1;
        
        [self recalculateDisplayAgeColor];
        
    }
    return self;
}

- (void) setActive:(BOOL)updateActive
{
    if(_isActive && !updateActive) //if turning off
    {
        _age = 0;
        
        _red = 255;
        _green = 255;
        _blue = 255;
        
        _redBaseFactor = 1;
        _greenBaseFactor = 1;
        _blueBaseFactor = 1;
        [self recalculateDisplayAgeColor];
        
        _isActive = NO;
    }
    if(updateActive) // if staying on
    {
        _age += 1;
        [self recalculateDisplayAgeColor];
    }
    if(!_isActive && updateActive) //turning on
    {
        _age += 1;
        [self changeBaseColor];
        [self recalculateDisplayAgeColor];
    }
    _isActive = updateActive;

}

-(void) recalculateDisplayAgeColor
{
    double redChangeFactor = (arc4random() % 10)/100.0;
    double greenChangeFactor =  (arc4random() % 10)/100.0;
    double blueChangeFactor =  (arc4random() % 10)/100.0;
    
    redChangeFactor = (arc4random() % 3) ? 1 - redChangeFactor: 1 + redChangeFactor;
    greenChangeFactor = (arc4random() % 3) ? 1 - greenChangeFactor: 1 + greenChangeFactor;
    blueChangeFactor = (arc4random() % 3) ? 1 - blueChangeFactor: 1 + blueChangeFactor;
    
    _redBaseFactor *= redChangeFactor;
    _greenBaseFactor *= greenChangeFactor;
    _blueBaseFactor *= blueChangeFactor;
    
    _color = [UIColor colorWithRed:(_redBaseFactor + (1-_redBaseFactor)*(_red/255.0) )
                             green:(_greenBaseFactor + (1-_greenBaseFactor)*(_green/255.0))
                              blue:(_blueBaseFactor + (1-_blueBaseFactor)*(_blue/255.0))
                             alpha: 1 ];
    
    [self setBackgroundColor:_color];

}

- (void) changeBaseColor
{
    _red = arc4random() % 255;
    _blue = arc4random() % 255;
    _green = arc4random() % 255;
    
    _redBaseFactor = .1 + (arc4random() % 80)/100.0;
    _greenBaseFactor = .1 + (arc4random() % 80)/100.0;
    _blueBaseFactor = .1 + (arc4random() % 80)/100.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
