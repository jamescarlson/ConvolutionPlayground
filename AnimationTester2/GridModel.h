//
//  GridModel.h
//  AnimationTester2
//
//  Created by James Carlson on 8/8/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridModel : UIDynamicBehavior

@property (readonly) CGSize gridSize;
@property CGFloat decayFactor;

- (instancetype)initWithSize:(CGSize) size;

- (void)setGridValue:(UIColor *)color atX:(int)x Y:(int)y;
- (void)setGridValueR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a atX:(int)x Y:(int)y;
- (UIColor *)getUIColorForX:(int)x Y:(int)y;
- (void)getGridValueR:(CGFloat *)r G:(CGFloat *)g B:(CGFloat *)b A:(CGFloat *)a ForX:(int)x Y:(int)y;

- (void) update;
- (void) updateWithConvKernel:(CGFloat ***)kernel ofSize:(CGSize)size;



@end
