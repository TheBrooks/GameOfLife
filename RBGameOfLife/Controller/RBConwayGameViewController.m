//
//  ConwayGameViewController.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "RBConwayGameViewController.h"
#import "RBConwayNode.h"
#import "RBConwayGameRunner.h"
#import "RBChangingColorView.h"

#define NODE_WIDTH 30
#define NODE_HEIGHT 31
#define NODES_PER_ROW 10
#define NODES_PER_COLUMN 17
#define WHITESPACE 2

@interface RBConwayGameViewController ()



@end

@implementation RBConwayGameViewController{
    /* date for the view controller */
    RBConwayGameRunner *_nodeData;
    
    NSMutableArray *_conwayNodeViews;  //listOfButtons
    
    /* Header area of the view Controller */
    RBOptionsExpanderView *_optionsExtender;
    
    UIImageView *_expandView;
    UIImageView *_shrinkView;
    UIView *_leftButton;
    UIView *_centerButton;
    UIView *_rightButton;
    
    /* Main Content area for the view controller */
    UIView *_contentView;
    
    BOOL _running;
    
    BOOL _displayed;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) loadView{
    
    /* date for the view controller */
    UIView *view = [UIView new];
    
    /* Main Content area for the view controller */
    _contentView = [UIView new];
    [view addSubview:_contentView];
    
    
    
    /* Header area of the view Controller */
    _optionsExtender = [[RBOptionsExpanderView alloc]initWithFrame: CGRectMake(320-63, 0, 320, 65)];
    [view addSubview:_optionsExtender];
    _optionsExtender.delegate = self;
    
    self.view = view;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _nodeData = [[RBConwayGameRunner alloc] initWithRows:NODES_PER_COLUMN andColumns:NODES_PER_ROW];
    _conwayNodeViews = [NSMutableArray new];
    
    _expandView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/optionsExpand.png",[[NSBundle mainBundle] bundlePath] ]]];
    [_expandView setBackgroundColor:[UIColor whiteColor]];
    [_expandView setFrame:CGRectMake(0, 0, 44, 44)];
    
    _shrinkView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/optionsShrink.png",[[NSBundle mainBundle] bundlePath] ]]];
    [_shrinkView setBackgroundColor:[UIColor whiteColor]];
    [_shrinkView setFrame:CGRectMake(0, 0, 44, 44)];

    _leftButton = [[UIView alloc] init];
    UILabel *leftButtonLabel = [UILabel new];
    [leftButtonLabel setText:@"step"];
    [_leftButton addSubview:leftButtonLabel];
    [_leftButton setFrame:CGRectMake(0, 0, 72, 44)];
    [leftButtonLabel setFrame:[_leftButton bounds]];
    
    _centerButton = [[UIView alloc] init];
    UILabel *centerButtonLabel = [UILabel new];
    [centerButtonLabel setText:@"run"];
    [_centerButton addSubview:centerButtonLabel];
    [_centerButton setFrame:CGRectMake(0, 0, 72, 44)];
    [centerButtonLabel setFrame:[_centerButton bounds]];
    
    _rightButton = [[UIView alloc] init];
    UILabel *rightButtonLabel = [UILabel new];
    [rightButtonLabel setText:@"restart"];
    [_rightButton addSubview:rightButtonLabel];
    [_rightButton setFrame:CGRectMake(0, 0, 72, 44)];
    [rightButtonLabel setFrame:[_rightButton bounds]];
    
    [_optionsExtender setExpandViewIcon: _expandView];
    [_optionsExtender setRetractViewIcon: _shrinkView];
    [_optionsExtender setLeftOptionViewButton:_leftButton];
    [_optionsExtender setCenterOptionViewButton: _centerButton];
    [_optionsExtender setRightOptionViewButton:_rightButton];

    
    
    [_contentView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    
    /* content area set up */
    _contentView.frame = CGRectMake(0,
                                    0,
                                    NODE_WIDTH * NODES_PER_ROW + WHITESPACE * NODES_PER_ROW,
                                    NODE_HEIGHT * NODES_PER_COLUMN + WHITESPACE * NODES_PER_COLUMN);
    
    for(int row = 0; row < NODES_PER_COLUMN; row ++)
    {
        NSMutableArray *buttonRow = [NSMutableArray new];
        for(int col = 0; col < NODES_PER_ROW; col ++)
        {
            RBChangingColorView *positionView = [[RBChangingColorView alloc] initWithFrame:CGRectMake(1+col * (NODE_WIDTH + WHITESPACE),
                                                                                                1+row * (NODE_HEIGHT + WHITESPACE),
                                                                                                NODE_WIDTH,
                                                                                                NODE_HEIGHT)];
            positionView.tag = row;

            UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(nodePushed:)];
            tapper.delegate = self;
            [positionView addGestureRecognizer:tapper];
            
            [_contentView addSubview:positionView];
            [buttonRow addObject:positionView];
        }
        [_conwayNodeViews addObject:buttonRow];
    }
    
}

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
}

- (void) nodePushed:(UIGestureRecognizer*)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        [self toggleNode:gestureRecognizer.view];
}
- (void) toggleNode:(RBChangingColorView *)tappedView
{
    if(!_running)
    {
        
        NSUInteger row = tappedView.tag;
        NSUInteger column = [_conwayNodeViews[row] indexOfObject:tappedView];
        
        [_nodeData toggleNodeAtRow:row Column:column];
        [(RBChangingColorView *)_conwayNodeViews[row][column] setActive:((RBConwayNode *)_nodeData.conwayNodes[row][column]).isAlive];
    }
}

- (void) updateNodeViews
{
    for(int row = 0; row < [_nodeData.conwayNodes count]; row++)
    {
        for(int col = 0; col < [_nodeData.conwayNodes[row] count]; col++)
        {
            [(RBChangingColorView *)_conwayNodeViews[row][col] setActive:((RBConwayNode *)_nodeData.conwayNodes[row][col]).isAlive];
        }
    }
}

- (void) runLife
{
    [_nodeData simulateConwayYear];
    [self updateNodeViews];
}

- (void) displayOptions
{
    NSLog(@"tapped");
   if(_optionsExtender.expanded)
   {
       [_optionsExtender setExpanded:NO];
   }
   else{
       [_optionsExtender setExpanded:YES];
   }
}

- (void) optionExpanderView:(RBOptionsExpanderView *)expanderView didRecieveViewTouchAtPosition:(OptoionExpanderViewPosition)touchPosition
{
   if(touchPosition == OptionExpanderViewLeft)
   {
       [self runLife];
   }
   else if(touchPosition == OptionExpanderViewCenter)
   {
       
   }
   else if(touchPosition == OptionExpanderViewRight)
   {
       [_nodeData restartGame];
       [self updateNodeViews];
   }
}

- (void) optionExpanderViewdidRecieveExpanderTouch:(RBOptionsExpanderView *)expanderView
{
    if(expanderView.expanded)
    {
        [expanderView setExpanded:NO];
    }
    else{
        [expanderView setExpanded:YES];
    }
}


- (BOOL) prefersStatusBarHidden{return YES;}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
