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

#define NODE_WIDTH 32.0
#define NODE_HEIGHT 33.0
#define NODES_PER_ROW 11
#define NODES_PER_COLUMN 18
#define WHITESPACE 0

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
    UIView *_stepButton;
    UIView *_runButton;
    UIView *_stopButton;
    UIView *_scatterButton;
    UIView *_restartButton;
    
    /* Main Content area for the view controller */
    UIView *_contentView;
    
    BOOL _running;
    BOOL _displayed;
    NSTimer *_runTimer;
    NSTimer *_slowDurationTimer;
    
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
    _optionsExtender = [[RBOptionsExpanderView alloc]initWithFrame: CGRectMake(320  - (NODE_WIDTH + WHITESPACE)*2 + .5 * NODE_WIDTH, 0, 320, 2*NODE_HEIGHT- .3 * NODE_HEIGHT)];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLife) name:kRBConwayGameRunnerReachedStasis object:_nodeData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillDisappear:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    _expandView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/optionsExpand.png",[[NSBundle mainBundle] bundlePath] ]]];
    [_expandView setBackgroundColor:[UIColor whiteColor]];
    [_expandView setContentMode:UIViewContentModeScaleAspectFit ];
    [_expandView setFrame:CGRectMake(0, 0, 44, 44)];
    
    _shrinkView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/optionsShrink.png",[[NSBundle mainBundle] bundlePath] ]]];
    [_shrinkView setContentMode:UIViewContentModeScaleAspectFit];
    [_shrinkView setBackgroundColor:[UIColor whiteColor]];
    [_shrinkView setFrame:CGRectMake(0, 0, 44, 44)];

    _stepButton = [[UIView alloc] init];
    UILabel *leftButtonLabel = [UILabel new];
    [leftButtonLabel setText:@"step"];
    [leftButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [_stepButton addSubview:leftButtonLabel];
    [_stepButton setFrame:CGRectMake(0, 0, 72, 44)];
    [leftButtonLabel setFrame:[_stepButton bounds]];
    
    _runButton = [[UIView alloc] init];
    UILabel *centerButtonLabel = [UILabel new];
    [centerButtonLabel setText:@"run"];
    [centerButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [_runButton addSubview:centerButtonLabel];
    [_runButton setFrame:CGRectMake(0, 0, 72, 44)];
    [centerButtonLabel setFrame:[_runButton bounds]];
    
    _restartButton = [[UIView alloc] init];
    UILabel *rightButtonLabel = [UILabel new];
    [rightButtonLabel setText:@"restart"];
    [rightButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [_restartButton addSubview:rightButtonLabel];
    [_restartButton setFrame:CGRectMake(0, 0, 72, 44)];
    [rightButtonLabel setFrame:[_restartButton bounds]];
    
    _stopButton = [[UIView alloc] init];
    UILabel *stopButtonLabel = [UILabel new];
    [stopButtonLabel setText:@"stop"];
    [stopButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [_stopButton addSubview:stopButtonLabel];
    [_stopButton setFrame:CGRectMake(0, 0, 72, 44)];
    [stopButtonLabel setFrame:[_stopButton bounds]];
    
    _scatterButton = [[UIView alloc] init];
    UILabel *scatterButtonLabel = [UILabel new];
    [scatterButtonLabel setText:@"scatter"];
    [scatterButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [_scatterButton addSubview:scatterButtonLabel];
    [_scatterButton setFrame:CGRectMake(0, 0, 72, 44)];
    [scatterButtonLabel setFrame:[_scatterButton bounds]];


    [_optionsExtender setExpandViewIcon: _expandView];
    [_optionsExtender setRetractViewIcon: _shrinkView];
    [_optionsExtender setLeftOptionViewButton:_stepButton];
    [_optionsExtender setCenterOptionViewButton: _runButton];
    [_optionsExtender setRightOptionViewButton:_restartButton];
    
    
    
    
    
    
    /* content area set up */
    _contentView.frame = CGRectMake(-0.5 * NODE_WIDTH,
                                    -0.3 * NODE_HEIGHT,
                                    NODE_WIDTH * NODES_PER_ROW + WHITESPACE * NODES_PER_ROW,
                                    NODE_HEIGHT * NODES_PER_COLUMN + WHITESPACE * NODES_PER_COLUMN);
    
    for(int row = 0; row < NODES_PER_COLUMN; row ++)
    {
        NSMutableArray *buttonRow = [NSMutableArray new];
        [_conwayNodeViews addObject:buttonRow];
        for(int col = 0; col < NODES_PER_ROW; col ++)
        {
            if((row == 0 || row == 1) && (col == NODES_PER_ROW-1 || col == NODES_PER_ROW-2))
               [_nodeData toggleNodeAlwaysOffAtRow:row Column:col];
            
            RBChangingColorView *positionView = [[RBChangingColorView alloc] initWithFrame:
                                                 CGRectMake(col * (NODE_WIDTH + WHITESPACE),
                                                row * (NODE_HEIGHT + WHITESPACE),
                                                NODE_WIDTH,
                                                NODE_HEIGHT)];

            positionView.tag = row;
            
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(nodeLongPushed:)];
            longPress.delegate = self;
            
            
            UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(nodePushed:)];
            tapper.delegate = self;
            
            [tapper requireGestureRecognizerToFail:longPress];
            [positionView addGestureRecognizer:longPress];
            [positionView addGestureRecognizer:tapper];
            
            [_contentView addSubview:positionView];
            [buttonRow addObject:positionView];
        }
    }
    [self randomizeBoard];
    
}

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopLife];
    
    if(!_nodeData.liveNodes)
    {
        [self randomizeBoard];
    }
}
- (void) nodePushed:(UIGestureRecognizer*)gestureRecognizer
{
    //set timer to slow down.  after a certain duration of slowing down speed up timer
    if(_runTimer)
        [self slowLifeTimerSpeed];
    
    if(!_nodeData.liveNodes && _optionsExtender.leftOptionViewButton != _restartButton)
    {
        [_optionsExtender setRightOptionViewButton:_restartButton];
    }
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
        [self toggleNode:(RBChangingColorView *)gestureRecognizer.view];
}
- (void) nodeLongPushed:(UIGestureRecognizer *) recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if(_runTimer)
            [self slowLifeTimerSpeed];
        RBChangingColorView *tappedView = (RBChangingColorView *)recognizer.view;
        NSUInteger row = tappedView.tag;
        NSUInteger column = [_conwayNodeViews[row] indexOfObject:tappedView];

        
        [_nodeData toggleNodeAlwaysOnAtRow:row Column:column];
        [(RBChangingColorView *)_conwayNodeViews[row][column] setActive:((RBConwayNode *)_nodeData.conwayNodes[row][column]).isAlive];
        
    }
}
- (void) toggleNode:(RBChangingColorView *)tappedView
{
    NSUInteger row = tappedView.tag;
    NSUInteger column = [_conwayNodeViews[row] indexOfObject:tappedView];
    
    [_nodeData toggleNodeAtRow:row Column:column];
    [(RBChangingColorView *)_conwayNodeViews[row][column] setActive:((RBConwayNode *)_nodeData.conwayNodes[row][column]).isAlive];
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
    [self normalLifeTimerSpeed];
    [_optionsExtender setCenterOptionViewButton:_stopButton];
}

- (void) slowLifeTimerSpeed
{
    if(_runTimer.timeInterval != .5 )
    {
        [_runTimer invalidate];
        _runTimer = nil;
        
        _runTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(stepLife) userInfo:nil repeats:YES];
        
    }
    
    if(_slowDurationTimer)
    {
        [_slowDurationTimer invalidate];
        _slowDurationTimer = nil;
    }
    
    _slowDurationTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(normalLifeTimerSpeed) userInfo:nil repeats:NO];
}

- (void) normalLifeTimerSpeed
{
    if(_slowDurationTimer)
    {
        [_slowDurationTimer invalidate];
        _slowDurationTimer = nil;
    }
    
    if(_runTimer)
    {
        [_runTimer invalidate];
        _runTimer = nil;
    }
    
    _runTimer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(stepLife) userInfo:nil repeats:YES];
}

- (void) stepLife
{
    [_nodeData simulateConwayYear];
    [self updateNodeViews];
}

-(void) stopLife
{
    if(_runTimer)
    {
        [_runTimer invalidate];
        _runTimer = nil;
    }
    if(_slowDurationTimer)
    {
        [_slowDurationTimer invalidate];
        _slowDurationTimer = nil;
    }
    
    if(!_nodeData.liveNodes)
    {
        [_optionsExtender setRightOptionViewButton:_scatterButton];
    }
    
    [_optionsExtender setExpanded:YES];
    [_optionsExtender setCenterOptionViewButton:_runButton];
    
}

- (void) optionExpanderView:(RBOptionsExpanderView *)expanderView didRecieveViewTouchAtPosition:(OptoionExpanderViewPosition)touchPosition
{
   if(touchPosition == OptionExpanderViewLeft)
   {
       [self stopLife];
       [self stepLife];
   }
   else if(touchPosition == OptionExpanderViewCenter)
   {
       if(!_runTimer)
       {
           [self runLife];
           [_optionsExtender setExpanded:NO];
       }
       else
           [self stopLife];
   }
   else if(touchPosition == OptionExpanderViewRight)
   {
       if(!_nodeData.liveNodes)
       {
           [self randomizeBoard];
           [_optionsExtender setRightOptionViewButton:_restartButton];
       }
       else
       {
           [self stopLife];
           [_nodeData restartGame];
           [self updateNodeViews];
           
           if(!_nodeData.liveNodes)
               [_optionsExtender setRightOptionViewButton:_scatterButton];
       }
    }
}

- (void) optionExpanderViewDidRecieveExpanderTouch:(RBOptionsExpanderView *)expanderView
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

-(void) randomizeBoard
{
    for(int row = 0; row < [_nodeData.conwayNodes count]; row++)
    {
        for(int col = 0; col < [_nodeData.conwayNodes[row] count]; col++)
        {
            if(arc4random()%2)
                [self toggleNode:(RBChangingColorView *)_conwayNodeViews[row][col]];
        }
    }
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}
@end
