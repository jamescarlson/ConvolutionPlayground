//
//  GridSquareViewDelegate.h
//  AnimationTester2
//
//  Created by James Carlson on 8/9/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GridSquareViewDelegate <NSObject>

- (void)squarePushedAtX:(int)x Y:(int)y;
- (void)updateMe:(id)me;

@end
