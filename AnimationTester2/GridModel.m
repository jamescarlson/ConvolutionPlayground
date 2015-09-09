
//
//  GridModel.m
//  AnimationTester2
//
//  Created by James Carlson on 8/8/15.
//  Copyright (c) 2015 dimnsionofsound. All rights reserved.
//

#import "GridModel.h"

static CGSize DEFAULT_SIZE = {20.0, 20.0};
CGFloat*** grid;
CGFloat*** grid2;
CGFloat*** defaultKernel;
static BOOL whatGrid = YES;

@interface GridModel ()
@property (readwrite) CGSize gridSize;

- (void)changeSizeTo:(CGSize) size; 

@end

@implementation GridModel

- (instancetype)init {
    return [self initWithSize:DEFAULT_SIZE];
}

- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    self.gridSize = size;
    grid = makeArrayOfSize(size.width, size.height, 4); //RGBA
    grid2 = makeArrayOfSize(size.width, size.height, 4); //RGBA
    defaultKernel = makeArrayOfSize(3, 3, 4);
    fillArrayOfSizeWithValues(defaultKernel, 3, 3, 0, 0, 0, 0);
    
    /* Default kernel for testing purposes. */
    defaultKernel[1][0][0] = .33;
    defaultKernel[0][1][1] = .33;
    defaultKernel[2][1][1] = .33;
    defaultKernel[2][1][0] = .33;
    defaultKernel[1][2][2] = .66;
    defaultKernel[1][1][3] = 1;
    defaultKernel[1][1][1] = .33;
    defaultKernel[1][1][2] = .33;
    defaultKernel[1][1][0] = .33;
    
    
    fillArrayOfSizeWithValues(grid, size.width, size.height, 0, 0, 0, 1);
    fillArrayOfSizeWithValues(grid2, size.width, size.height, 0, 0, 0, 1);
    self.decayFactor = 0.9;
    return self;
}

- (UIColor *)getUIColorForX:(int)x Y:(int)y {
    CGFloat*** g = whatGrid ? grid : grid2;
    return [UIColor colorWithRed:g[x][y][0]
                           green:g[x][y][1]
                            blue:g[x][y][2]
                           alpha:g[x][y][3]];
}

- (void)setGridValue:(UIColor *)color atX:(int)x Y:(int)y{
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    [self setGridValueR:r G:g B:b A:a atX:x Y:y];
}

- (void)getGridValueR:(CGFloat *)r G:(CGFloat *)g B:(CGFloat *)b A:(CGFloat *)a ForX:(int)x Y:(int)y {
    CGFloat*** myGrid = whatGrid ? grid : grid2;
    *r = myGrid[x][y][0];
    *g = myGrid[x][y][1];
    *b = myGrid[x][y][2];
    *a = myGrid[x][y][3];
}

- (void)setGridValueR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a atX:(int)x Y:(int)y{
    CGFloat*** myGrid = whatGrid ? grid : grid2;
    myGrid[x][y][0] = r;
    myGrid[x][y][1] = g;
    myGrid[x][y][2] = b;
    myGrid[x][y][3] = a;
}


- (void) update {
    [self updateWithConvKernel:defaultKernel ofSize:CGSizeMake(3, 3)];
    [self decayNonAlphaWithFactor:self.decayFactor];
    
}

- (void)decayNonAlphaWithFactor:(CGFloat)factor {
    for (int i = 0; i < 3; i += 1) {
        [self decayChannel:i withFactor:factor];
    }
}

- (void)decayChannel:(int)channel withFactor:(CGFloat)factor {
    int x = self.gridSize.width;
    int y = self.gridSize.height;
    CGFloat*** array = whatGrid ? grid : grid2;
    for (int over_x = 0; over_x < x; over_x += 1) {
        for (int over_y = 0; over_y < y; over_y += 1) {
            array[over_x][over_y][channel] = array[over_x][over_y][channel] * factor;
        }
    }
}

- (void) updateWithConvKernel:(CGFloat ***)kernel ofSize:(CGSize)size {
    CGFloat*** in = whatGrid ? grid : grid2;
    CGFloat*** out = whatGrid ? grid2 : grid;
    whatGrid = !whatGrid;
    int rows = self.gridSize.width;
    int cols = self.gridSize.height;
    int kCols = (int)size.width;
    int kRows = (int)size.height;
    int kCenterX = kCols / 2;
    int kCenterY = kRows / 2;


    for (int d = 0; d < 4; d += 1) {
        for(int i=0; i < rows; i += 1) {              // rows
            for(int j=0; j < cols; j += 1) {          // columns
                for(int m=0; m < kRows; m += 1) {     // kernel rows
                    
                    int mm = kRows - 1 - m;           // row index of flipped kernel

                    for(int n=0; n < kCols; n += 1) { // kernel column index
                        int nn = kCols - 1 - n;       // column index of flipped kernel
                        
                        // index of input signal, used for checking boundary
                        int ii = i + (m - kCenterY);
                        int jj = j + (n - kCenterX);
                        
                        // ignore input samples which are out of bound
                        if( ii >= 0 && ii < rows && jj >= 0 && jj < cols )
                            out[i][j][d] += in[ii][jj][d] * kernel[mm][nn][d];
                    }
                }
            }
        }
    }
    fillArrayOfSizeWithValues(in, self.gridSize.width, self.gridSize.height, 0, 0, 0, 0);
    
}

void fillArrayOfSizeWithValues(CGFloat*** array, int x, int y, CGFloat r,
                               CGFloat g, CGFloat b, CGFloat a) {
    for (int over_x = 0; over_x < x; over_x += 1) {
        for (int over_y = 0; over_y < y; over_y += 1) {
            array[over_x][over_y][0] = r;
            array[over_x][over_y][1] = g;
            array[over_x][over_y][2] = b;
            array[over_x][over_y][3] = a;
        }
    }
}


CGFloat*** makeArrayOfSize(int x, int y, int z) {
    CGFloat*** rv = malloc(sizeof(CGFloat**) * x);
    for (int over_x = 0; over_x < x; over_x += 1) {
        rv[over_x] = malloc(sizeof(CGFloat*) * y);
        for (int over_y = 0; over_y < y; over_y +=1 ) {
            rv[over_x][over_y] = malloc(sizeof(CGFloat) * z);
        }
    }
    return rv;
}

void destroyArrayOfSize(CGFloat*** array, int x, int y, int z) {
    for (int over_x = 0; over_x < x; over_x += 1) {
        for (int over_y = 0; over_y < y; over_y +=1 ) {
            free(array[over_x][over_y]);
        }
        free(array[over_x]);
    }
    free(array);
}

- (void)changeSizeTo:(CGSize)size {
    destroyArrayOfSize(grid, self.gridSize.width, self.gridSize.height, 4);
    destroyArrayOfSize(grid2, self.gridSize.width, self.gridSize.height, 4);
    grid = makeArrayOfSize(size.width, size.height, 4); //RGBA
    grid2 = makeArrayOfSize(size.width, size.height, 4); //RGBA
    fillArrayOfSizeWithValues(grid, size.width, size.height, 0, 0, 0, 1);
    fillArrayOfSizeWithValues(grid2, size.width, size.height, 0, 0, 0, 1);
    self.gridSize = size;
}

- (void)dealloc {
    destroyArrayOfSize(grid, self.gridSize.width, self.gridSize.height, 4);
    destroyArrayOfSize(grid2, self.gridSize.width, self.gridSize.height, 4);
    destroyArrayOfSize(defaultKernel, 3, 3, 4);
}





@end
