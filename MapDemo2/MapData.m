//
//  MapData.m
//  maptest
//
//  Created by Milos Jovanovic on 12-04-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MapTile.h"
#import "MapData.h"

static const int MAP_W = 100;
static const int MAP_H = 100;

@interface MapData(private)
-(float)perlinForX:(int)x andY:(int)y;
@end


@implementation MapData

@synthesize allTiles, rows, mapSize;

-(id)init {
    NSLog(@"Generating map...");
    if ((self = [super init])) {
        self.mapSize = CGSizeMake(MAP_W, MAP_H);
        self.rows = [NSMutableArray arrayWithCapacity:self.mapSize.height];
        self.allTiles = [NSMutableArray arrayWithCapacity:self.mapSize.width*self.mapSize.height];
        
        
        
        for (int y=0; y<self.mapSize.height; y++) {
            //NSString* line = @"";
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:self.mapSize.width];
            [self.rows insertObject:row atIndex:y];
            for (int x=0; x<self.mapSize.width; x++) {
                MapTile *tile = [MapTile tileWithCoordinates:CGPointMake(x, y)];
                [tile setHeight:[self perlinForX:x andY:y]*13.0f-3.25f];
                [row insertObject:tile atIndex:x];
                [allTiles addObject:tile];
                //line = [NSString stringWithFormat:@"%@ %f", line, tile.height];
            }
            //NSLog(line);
            if (y % (MAP_H/10) == 0) {
                NSLog(@"%d percent done.", y/(MAP_H/100));
            }
        }
        NSLog(@"Completed.\n");
        NSLog(@"Connecting tiles...");
        int i = 0;
        for (MapTile* tile in self.allTiles) {
            [tile connectWithTiles:self];
            if (i % (MAP_H*MAP_W/10) == 0) {
                NSLog(@"%d percent done.", i/(MAP_H*MAP_W/100));
            }
            
            i++;
        }
        NSLog(@"Smoothing terrain...");
        for (MapTile* tile in self.allTiles) {
            tile.texture = [tile calculateTexture];
        }
        NSLog(@"Completed.\n");
    }
    return self;
}

-(id)tileAtMapCoordinates:(CGPoint)coordinates {
    return [self tileAtMapX:coordinates.x andMapY:coordinates.y];
}

-(id)tileAtMapX:(int)x andMapY:(int)y {
    return [[self.rows objectAtIndex:y] objectAtIndex:x];
}

-(float)noiseForX:(float)x andY:(float)y {
    int n = x*y+10*x-y;
    srand(n*log(n));
    float z = (rand()%100)/100.0f;
    return z;
}

-(float)smoothNoiseForX:(float)x andY:(float)y {
    float corners = ( [self noiseForX:x-1 andY:y-1]+[self noiseForX:x+1 andY:y-1]+[self noiseForX:x-1 andY:y+1]+[self noiseForX:x+1 andY:y+1] )/4.0f;
    float sides   = ( [self noiseForX:x-1 andY:y] +[self noiseForX:x+1 andY: y]  +[self noiseForX:x andY:y-1]  +[self noiseForX:x andY:y+1] )/4.0f;
    float center  =  [self noiseForX:x andY:y];
    return 0.15f*corners + 0.35f*sides + 0.5f*center;
}

-(float)interpolateForX:(float)x andY:(float)y andTheta:(float)theta {
    float ft = theta * M_PI;
    float f = (1 - cos(ft)) * .5f;
	return  x*(1-f) + y*f;    
}

-(float)interpolateNoiseForX:(float)x andY:(float)y {
    int integer_X    = round(x);
    float fractional_X = x - integer_X;
    
    int integer_Y    = round(y);
    float fractional_Y = y - integer_Y;
    
    float v1 = [self smoothNoiseForX:integer_X andY:integer_Y];
    float v2 = [self smoothNoiseForX:integer_X + 1 andY:integer_Y];
    float v3 = [self smoothNoiseForX:integer_X andY:integer_Y + 1];
    float v4 = [self smoothNoiseForX:integer_X + 1 andY:integer_Y + 1];

    float i1 = [self interpolateForX:v1 andY:v2 andTheta:fractional_X];
    float i2 = [self interpolateForX:v3 andY:v4 andTheta:fractional_X];

    return [self interpolateForX:i1 andY:i2 andTheta:fractional_Y];
}

-(float)perlinForX:(int)x andY:(int)y {
    float total = 0;

    for (int i=1; i<4; i++) {
        float frequency = pow(2, i);
        float amplitude = pow(0.5f, i);
        total += [self interpolateNoiseForX:(x/10.0f)*frequency andY:(y/10.0f)*frequency] * amplitude;
    }

    return total;
}
@end
