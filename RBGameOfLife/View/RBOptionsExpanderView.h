//
//  OptionsExpanderView.h
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RBOptionsExpanderView;

@protocol RBOptionExpanderViewDelegate <NSObject>

typedef enum OptoionExpanderViewPosition{
    OptionExpanderViewLeft,
    OptionExpanderViewCenter,
    OptionExpanderViewRight
}OptoionExpanderViewPosition;


- (void) optionExpanderView:(RBOptionsExpanderView *)expanderView didRecieveViewTouchAtPosition:(OptoionExpanderViewPosition)touchPosition;

- (void) optionExpanderViewdidRecieveExpanderTouch:(RBOptionsExpanderView *)expanderView;

@end

typedef enum ExpandFromEdgeDirection{
    ExpandFromTopEdge,
    ExpandFromLeftEdge,
    ExpandFromBottomEdge,
    ExpandFromRightEdge
}ExpandFromEdgeDirection;


@interface RBOptionsExpanderView : UIView <UIGestureRecognizerDelegate>

/* label views */
@property UIView *expandViewIcon;
@property UIView *retractViewIcon;

/* views for the "buttons" */
@property UIView *leftOptionViewButton;
@property UIView *centerOptionViewButton;
@property UIView *rightOptionViewButton;

@property (readonly) BOOL expanded;
/* which edge the options view is contained by */
//@property ExpandFromEdgeDirection *contentEdge;


/* expand and contract the options */
- (void) setExpanded:(BOOL)expanded;


@property id <RBOptionExpanderViewDelegate> delegate;

@end

