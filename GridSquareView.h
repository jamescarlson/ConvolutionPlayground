//
//  GridSquareView.h
//  AnimationTester2
//
//  Created by James Carlson on 8/9/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridSquareViewDelegate.h"

@interface GridSquareView : UIView

@property int x;
@property int y;
@property (nonatomic, weak) id <GridSquareViewDelegate> delegate;

- (void)callControllerForUpdate;


@end
