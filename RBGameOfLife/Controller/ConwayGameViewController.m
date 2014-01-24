//
//  ConwayGameViewController.m
//  RBGameOfLife
//
//  Created by Ryan Brooks on 1/24/14.
//  Copyright (c) 2014 Ryan Brooks. All rights reserved.
//

#import "ConwayGameViewController.h"
#import "RBConwayNode.h"

#define NODE_WIDTH 32
#define NODES_PER_ROW 10
#define NODES_PER_COLUMN 10

@interface ConwayGameViewController ()



@end

@implementation ConwayGameViewController{
    /* date for the view controller */
    NSMutableArray *_conwayBoard;  //list of cells
    NSMutableArray *_conwayButtons;  //listOfButtons
    
    /* Header area of the view Controller */
    UIView *_headerView;
    UILabel *_gameLabel;
    UISwitch *_playSwitch;
    
    /* Main Content area for the view controller */
    UIView *_contentView;
    
    BOOL _running;
    
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
    
    /* Header area of the view Controller */
    _headerView = [UIView new];
    _gameLabel = [UILabel new];
    _playSwitch = [[UISwitch alloc] init];
    
    [_headerView addSubview:_gameLabel];
    [_headerView addSubview: _playSwitch];
    
    [view addSubview:_headerView];
    
    /* Main Content area for the view controller */
    _contentView = [UIView new];
    
    [view addSubview:_contentView];
    
    
    
    
    
    self.view = view;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _conwayBoard = [NSMutableArray new];
    _conwayButtons = [NSMutableArray new];
    
    [_gameLabel setText:@"Conway's Game Of Life"];
    
    
    
    /* Header area of the view Controller */
    _headerView.frame = CGRectMake(0, 0, 320, 120);
    _gameLabel.frame = CGRectMake(10, 10, 220, 100);
    _playSwitch.frame = CGRectMake(230, 10, 80, 100);
    
    _contentView.frame = CGRectMake(0, 120, NODE_WIDTH * NODES_PER_ROW , NODE_WIDTH * NODES_PER_COLUMN);
    for(int row = 0; row < NODES_PER_COLUMN; row ++)
    {
        NSMutableArray *nodeRow = [NSMutableArray new];
        NSMutableArray *buttonRow = [NSMutableArray new];
        for(int col = 0; col < NODES_PER_ROW; col ++)
        {
            RBConwayNode *positionNode = [[RBConwayNode alloc ]init];
            [positionNode setRow:row];
            [positionNode setColumn:col];
            [positionNode setIsAlive:NO];
            
            UIButton *positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [positionButton setBackgroundColor:[UIColor colorWithRed:(row*13+26)/255.0 green:(row*6+col*7)/255.0 blue:(row*col)/255.0 alpha:1]];
            positionButton.frame = CGRectMake(col*NODE_WIDTH, row*NODE_WIDTH, NODE_WIDTH, NODE_WIDTH);
            [positionButton addTarget:self action:@selector(nodePushed:) forControlEvents:UIControlEventTouchUpInside];
            positionButton.tag = row;
            
            [_contentView addSubview:positionButton];
            [nodeRow addObject:positionNode];
            [buttonRow addObject:positionButton];
        }
        [_conwayBoard addObject:nodeRow];
        [_conwayButtons addObject:buttonRow];
    }
    
}

- (void) viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
}

- (void) nodePushed:(id)sender
{
    if(!_running)
    {
        NSUInteger row = ((UIButton *)sender).tag;
        NSUInteger column = [_conwayButtons[row] indexOfObject:(UIButton *)sender];
        
        ((RBConwayNode *)_conwayBoard[row][column]).isAlive = !((RBConwayNode *)_conwayBoard[row][column]).isAlive;
        NSLog(@"tapped: %i",((RBConwayNode *)_conwayBoard[row][column]).isAlive);

    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
