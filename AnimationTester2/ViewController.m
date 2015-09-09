//
//  ViewController.m
//  AnimationTester2
//
//  Created by James Carlson on 6/30/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import "ViewController.h"

#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "GridModel.h"
#import "GridSquareView.h"


const CGSize BOX_SIZE = {128, 128};

@interface ViewController ()

@property (strong, nonatomic) UIView *innerView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *snapper;
@property (strong, nonatomic) GridModel* gm;
@property (nonatomic) CGSize gridSize;
@property (strong, nonatomic) NSMutableArray *myViews;
@property (strong ,nonatomic) UIColor *strokeColor;
@property CGFloat red;
@property CGFloat green;
@property CGFloat blue;
@property CGFloat alpha;
@property (weak, nonatomic) IBOutlet UILabel *frameRateLabel;
@property CGFloat frameRate;
@property CADisplayLink *displayLink;
@property (weak, nonatomic) IBOutlet UISwitch *doUpdate;

@end

@implementation ViewController

- (UIColor *)strokeColor {
    if (!_strokeColor) {
        _strokeColor = [UIColor colorWithRed:.1 green:0 blue:.03 alpha:1];
    }
    return _strokeColor;
}

- (NSMutableArray *)myViews {
    if (!_myViews) {
        _myViews = [[NSMutableArray alloc] init];
    }
    return _myViews;
}

- (GridModel *)gm {
    if (!_gm) {
        _gm = [[GridModel alloc] initWithSize:self.gridSize];
    }
    return _gm;
}


- (void)createSquares
{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height - 100;
    CGFloat dx = width / self.gridSize.width;
    CGFloat dy = height / self.gridSize.height;
    for (int x = 0; x < self.gridSize.width; x += 1) {
        for (int y = 0; y < self.gridSize.height; y += 1) {
            CGRect myFrame = CGRectMake(x * dx, y * dy, dx, dy);
            GridSquareView *willInsert = [[GridSquareView alloc] initWithFrame:myFrame];
            willInsert.x = x;
            willInsert.y = y;
            willInsert.delegate = self;
            willInsert.backgroundColor = [UIColor blackColor];
            willInsert.layer.borderColor = [[self strokeColor] CGColor];
            willInsert.layer.borderWidth = 1.5f;
            [self.view addSubview:willInsert];
            [self.myViews addObject:willInsert];
        }
    }
}

- (void)squarePushedAtX:(int)x Y:(int)y {
    [self.gm setGridValueR:self.red G:self.green B:self.blue A:self.alpha atX:x Y:y];
    [self iterate];
}

- (void)updateMe:(GridSquareView *)me {
    me.backgroundColor = [self.gm getUIColorForX: me.x Y: me.y];
}


- (IBAction)updateRequested:(UIButton *)sender {
    [self iterateAndUpdate];
}

- (IBAction)decayFactorChanged:(UISlider *)sender {
    self.gm.decayFactor = sender.value;
}

- (IBAction)frameRateChanged:(UISlider *)sender {
    self.frameRate = 10*sender.value;
    self.displayLink.frameInterval = (int)(60.0 / self.frameRate);
}

- (void)dispUpdate:(CADisplayLink *)sender {
    if (self.doUpdate.on) {
    [self iterateAndUpdate];
    }
}

- (void)iterate {
    [self.myViews makeObjectsPerformSelector:@selector(callControllerForUpdate)];

}

- (void)iterateAndUpdate {
    [self.gm update];
    [self iterate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridSize = CGSizeMake(20, 32);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [self createSquares];
    self.red = 1;
    self.blue = 1;
    self.green = 1;
    self.alpha = 1;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dispUpdate:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink.frameInterval = 2;
}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dispUpdate:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink.frameInterval = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.displayLink invalidate];
}

@end
