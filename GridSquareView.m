//
//  GridSquareView.m
//  AnimationTester2
//
//  Created by James Carlson on 8/9/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import "GridSquareView.h"

@interface GridSquareView ()

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer* tapRec;

@end

@implementation GridSquareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receivedTouch:)];
    self.tapRec.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:self.tapRec];
    return self;
}

- (IBAction)receivedTouch:(id)sender {
    [self.delegate squarePushedAtX:self.x Y:self.y];
}

- (void)callControllerForUpdate {
    [self.delegate updateMe:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
