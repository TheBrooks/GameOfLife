//
//  OptionsExpanderView.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBOptionsExpanderView.h"

@implementation RBOptionsExpanderView
{
    UITapGestureRecognizer *_tapperLeft;
    UITapGestureRecognizer *_tapperCenter;
    UITapGestureRecognizer *_tapperRight;
    UITapGestureRecognizer *_slideTapper;
    
    /* label views */
     UIView *_expandViewIcon;
     UIView *_retractViewIcon;
    
    
    /* view areas for the buttons */
    UIView *_exposedViewButtonArea;
    UIView *_leftOptionViewButtonArea;
    UIView *_centerOptionViewButtonArea;
    UIView *_rightOptionViewButtonArea;
    
    /* views for the "buttons" */
     UIView *_leftOptionViewButton;
     UIView *_centerOptionViewButton;
     UIView *_rightOptionViewButton;
    
    BOOL _expanded;
    
    double _overHang;
    
    /* which edge the options view is contained by */
     //ExpandFromEdgeDirection *_contentEdge;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _expanded = NO;
        _overHang = 320 - self.frame.origin.x;
        
        _tapperLeft = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(viewTapped:)];
        _tapperLeft.delegate = self;
        
        _tapperCenter = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(viewTapped:)];
        _tapperCenter.delegate = self;
        
        _tapperRight = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(viewTapped:)];
        _tapperRight.delegate = self;
        
        _slideTapper = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(expandRetractTapped:)];
        _slideTapper.delegate = self;
    
        _exposedViewButtonArea = [UIView new];
        
        _leftOptionViewButtonArea  = [UIView new];
        _leftOptionViewButton.tag = OptionExpanderViewLeft;
        
        _centerOptionViewButtonArea = [UIView new];
        _centerOptionViewButton.tag = OptionExpanderViewCenter;
        
        _rightOptionViewButtonArea = [UIView new];
        _rightOptionViewButton.tag = OptionExpanderViewRight;
        
        [_exposedViewButtonArea setFrame:CGRectMake(10, 10, 43, 43)];
        [_leftOptionViewButtonArea setFrame:CGRectMake(73, 10, 72, 43)];
        [_centerOptionViewButtonArea setFrame:CGRectMake(155, 10, 72, 43)];
        [_rightOptionViewButtonArea setFrame:CGRectMake(237, 10, 72, 43)];
        
        [self addSubview:_exposedViewButtonArea];
        [self addSubview:_leftOptionViewButtonArea];
        [self addSubview:_centerOptionViewButtonArea];
        [self addSubview:_rightOptionViewButtonArea];
        
        [_exposedViewButtonArea addGestureRecognizer:_slideTapper];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
    }
    return self;
}

- (void) viewTapped:(UITapGestureRecognizer *)gestureRecodniser
{
    [_delegate optionExpanderView:self didRecieveViewTouchAtPosition:(OptoionExpanderViewPosition)gestureRecodniser.view.tag];
}

- (void) setExpandViewIcon:(UIView *)expandViewIcon
{
    if(_expandViewIcon)
    {
        if(!_expanded)
        {
            [_expandViewIcon removeFromSuperview];
        }
    }
    _expandViewIcon = expandViewIcon;
    if(_expandViewIcon)
    {
        if(!_expanded)
        {
            
            [_exposedViewButtonArea addSubview:_expandViewIcon];
        }
    }

}

-(void) setRetractViewIcon:(UIView *)retractViewIcon
{
    if(_retractViewIcon)
    {
        if(_expanded)
        {
            [_retractViewIcon removeFromSuperview];
        }
    }
    else
    {
        
    }
    _retractViewIcon = retractViewIcon;
    if(_retractViewIcon)
    {
        if(_expanded)
        {
            
            [_exposedViewButtonArea addSubview:_retractViewIcon];
        }
    }
}

-(UIView *) expandViewIcon {return _leftOptionViewButton;}
-(UIView *) retractViewIcon { return _expandViewIcon;}


- (void) setLeftOptionViewButton:(UIView *)leftOptionView {
    if(_leftOptionViewButton)
    {
        [_leftOptionViewButtonArea removeGestureRecognizer:_tapperLeft];

        [_leftOptionViewButton removeFromSuperview];
    }
    
    _leftOptionViewButton = leftOptionView;
    if(_leftOptionViewButton){
        [_leftOptionViewButtonArea addSubview:_leftOptionViewButton];
        [_leftOptionViewButtonArea addGestureRecognizer:_tapperLeft];
    }
}

-(void) setCenterOptionViewButton:(UIView *)centerOptionView {
    if(_centerOptionViewButton)
    {
        [_centerOptionViewButton removeGestureRecognizer:_tapperCenter];
        [_centerOptionViewButton removeFromSuperview];
    }
    
    _centerOptionViewButton = centerOptionView;
    if(_centerOptionViewButton){
        [_centerOptionViewButtonArea addSubview:_centerOptionViewButton];
        [_centerOptionViewButton addGestureRecognizer:_tapperCenter];
    }
}

-(void) setRightOptionViewButton:(UIView *)rightOptionView {
    if(_rightOptionViewButton)
    {
        [_rightOptionViewButton removeGestureRecognizer:_tapperRight];
        [_rightOptionViewButton removeFromSuperview];
    }
    _rightOptionViewButton = rightOptionView;
    
    if(_rightOptionViewButton){
        [_rightOptionViewButtonArea addSubview:_rightOptionViewButton];
        [_rightOptionViewButton addGestureRecognizer:_tapperRight];
    }
}

-(UIView *) leftOptionViewButton {return _leftOptionViewButton;}
-(UIView *) centerOptionViewButton { return _centerOptionViewButton;}
-(UIView *) rightOptionViewButton {return _rightOptionViewButton;}



- (void)setExpanded:(BOOL)expand
{
    if(!_expanded && expand)
    {
        //maybe remove and re add gesture recognisers
        
        [UIView animateWithDuration:.5 animations:^{
            [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
            [_expandViewIcon removeFromSuperview];
            [_exposedViewButtonArea addSubview:_retractViewIcon];
        } completion:^(BOOL finished) {
            _expanded = YES;
        }];
    }
    else if(_expanded && !expand)
    {
        [UIView animateWithDuration:.5 animations:^{
            [self setFrame:CGRectMake(320 - _overHang, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        } completion:^(BOOL finished) {
            [_retractViewIcon removeFromSuperview];
            [_exposedViewButtonArea addSubview:_expandViewIcon];
            _expanded = NO;
        }];
    }
}

- (void) expandRetractTapped:(UIGestureRecognizer * )recognizer
{
    [_delegate optionExpanderViewdidRecieveExpanderTouch:self];
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
