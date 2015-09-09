//
//  AnimationTester2Tests.m
//  AnimationTester2Tests
//
//  Created by James Carlson on 6/30/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GridModel.h"
#define DELTA 0.001

@interface AnimationTester2Tests : XCTestCase

@property (strong, nonatomic) GridModel *gm;



@end

@implementation AnimationTester2Tests

- (GridModel *)gm {
    if (!_gm) {
        _gm = [[GridModel alloc] initWithSize:CGSizeMake(30, 55)];
    }
    return _gm;
}

- (void)compareColors:(UIColor *)c1 and:(UIColor *)c2 {
    CGFloat r,g,b,a,r2,g2,b2,a2;
    [c1 getRed:&r green:&g blue:&b alpha:&a];
    [c2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    XCTAssertEqualWithAccuracy(r, r2, DELTA, @"Colors' red doesn't match");
    XCTAssertEqualWithAccuracy(g, g2, DELTA, @"Colors' green doesn't match");
    XCTAssertEqualWithAccuracy(b, b2, DELTA, @"Colors' blue doesn't match");
    XCTAssertEqualWithAccuracy(a, a2, DELTA, @"Colors' alpha doesn't match");
}



- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    [self.gm setGridValueR:1 G:1 B:1 A:1 atX:1 Y:1];
    /*
    CGFloat kernel[3][3][4] =
    {{{0, 0, 0, 0}, {1, 0, 0, 0}, {0, 0, 0, 0}},
        {{0, 1, 0, 0}, {0, 0, 0, 1}, {0, 1, 0, 0}},
        {{0, 0, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 0}}};
    [self.gm updateWithConvKernel:kernel ofSize:CGSizeMake(3, 3)];
     */
    [self.gm update];
    UIColor* checkColor1 = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1];
    UIColor* checkColor2 = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1];
    UIColor* checkColor3 = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:1];
    UIColor* checkColor4 = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1];
    UIColor* gridColorUp = [self.gm getUIColorForX:1 Y:0];
    UIColor* gridColorLeft = [self.gm getUIColorForX:0 Y:1];
    UIColor* gridColorDown = [self.gm getUIColorForX:1 Y:2];
    UIColor* gridColorRight = [self.gm getUIColorForX:2 Y:1];
    UIColor* gridColorUpRight = [self.gm getUIColorForX:2 Y:0];
    //UIColor* gridColorCenter = [self.gm getUIColorForX:1 Y:1];
    [self compareColors:checkColor1 and:gridColorUp];
    [self compareColors:checkColor2 and:gridColorRight];
    [self compareColors:checkColor2 and:gridColorLeft];
    [self compareColors:checkColor3 and:gridColorDown];
    [self compareColors:checkColor4 and:gridColorUpRight];
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
