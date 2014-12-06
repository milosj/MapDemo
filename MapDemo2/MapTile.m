//
//  MapTile.m
//  maptest
//
//  Created by Milos Jovanovic on 12-04-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MapTile.h"
#import "MapData.h"
#import <QuartzCore/QuartzCore.h>

#define ARC4RANDOM_MAX      0x100000000


static MapTile* nilTileSingleton = nil;

@interface MapTile(private)
-(CGColorRef)backgroundColor;
-(id)initWithCoordinates:(CGPoint)coordinates;
-(id)init;
@end

@implementation MapTile

@synthesize coordinates, surroundingTiles, height;

-(id)init {
    if (self = [super initWithColor:[UIColor whiteColor] size:CGSizeMake(25.0f, 25.0f)]) {
        
    }
    return [self initWithCoordinates:CGPointMake(0, 0)];
}

-(id)initWithCoordinates:(CGPoint)coordinatesLocal {
    if ((self = [super initWithTexture:[MapTile textureNamed:@"0000_0"] color:[UIColor whiteColor] size:CGSizeMake(25.0f, 25.0f)])) {
        self.coordinates = coordinatesLocal;
        if (coordinates.x == 0 || coordinates.y == 0) {
            height = -10;
        } else {
            height = 1;
        }
        self.color = [self calculateColour];
        self.colorBlendFactor = 0.00f;
    }
    return self;
}

-(SKColor*)calculateColour {

    
    if (height < 0) {
        double hD = (10.0f + height)/10.0f;
        int coast = 0;
        for (MapTile* neighbour in self.surroundingTiles) {
            if (neighbour != [MapTile nilTile]) {
                if (neighbour.height > 0.0f) {
                    coast++;
                }
            }
        }
        if (coast > 1) {
            return [UIColor colorWithRed:hD*0.2f green:hD*0.7f blue:hD alpha:1.0f];
        } else {
            return [UIColor colorWithRed:hD*0.1f green:hD*0.35f blue:hD alpha:1.0f];
        }
    } else if (height > 2.65f) {
        return [UIColor whiteColor];
    } else {
        float coast = 0;
        float peak = 0;
        int i=0;
        for (MapTile* neighbour in self.surroundingTiles) {
            if (neighbour != [MapTile nilTile]) {
                if (neighbour.height < 0.0f) {
                    if ([MapTile isDirectionMajor:i]) {
                        coast++;
                    } else {
                        coast +=0.5f;
                    }
                } else if (neighbour.height > 2.65f) {
                    if ([MapTile isDirectionMajor:i]) {
                        peak++;
                    } else {
                        peak += 0.5f;
                    }
                }
            }
            i++;
        }
        peak = 0.5f+peak/12.0f;
        coast = coast/12.0f;
        double hD = (10.0f - height)/10.0f;
        if (coast > 0.0f) {
            return [UIColor colorWithRed:(0.9f-0.5f*hD) green:(1.0f-0.5f*hD)-0.5*coast blue:0.1f*(1.0f-hD) alpha:1.0f];
            //return [[UIColor colorWithRed:hD*0.75f green:hD*0.75f blue:0.1*hD alpha:1.0f] CGColor];
        } else if (peak > 0.55f) {
            return [UIColor colorWithRed:hD*peak green:hD*peak blue:hD*peak alpha:1.0f];
        } else {
            return [UIColor colorWithRed:0.1f*hD green:(1.0f-0.5f*hD) blue:0.1f*(1.0f-hD) alpha:1.0f];
        }
    }
}

-(void)setHeight:(float)heightLocal {
    height = round(heightLocal);
    if (height<0) {
        height = 0;
    }
    self.color = [self calculateColour];
}


/** 0 1 2
    3   4
    5 6 7
 **/

-(void)connectWithTiles:(MapData *)map {
    self.surroundingTiles = [NSMutableArray arrayWithCapacity:8];
    int i=0;
    for (int y=self.coordinates.y-1; y<=self.coordinates.y+1; y++) {
        for (int x=self.coordinates.x-1; x<=self.coordinates.x+1; x++) {
            if (x<0 || y<0 || x >= map.mapSize.width || y>=map.mapSize.height) {
                [self.surroundingTiles insertObject:[MapTile nilTile] atIndex:i];
                i++;
            } else if (x == self.coordinates.x && y == self.coordinates.y) {
                
            } else {
                [self.surroundingTiles insertObject:[map tileAtMapX:x andMapY:y] atIndex:i];
                i++;
            }
        }
    }
    self.texture = [self calculateTexture];
}

+(SKTexture*)textureNamed:(NSString*)textureName {
    static NSMutableDictionary* textures;
    if (!textures) {
        textures = [NSMutableDictionary dictionary];
        for (int first=0; first<2; first++) {
            for (int second=0; second<2; second++) {
                for (int third=0; third<2; third++) {
                    for (int fourth=0; fourth<2; fourth++) {
                        for (int alternative=0; alternative<2; alternative++) {
                            NSString* name = [NSString stringWithFormat:@"%i%i%i%i_%i", first, second, third, fourth, alternative];
                            textures[name] = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@.png", name]];
                        }
                    }
                }
            }
        }
    }
    
    if (textures[textureName]) {
        return textures[textureName];
    } else {
        [[NSException exceptionWithName:@"Texture not found" reason:[NSString stringWithFormat:@"Missing file for texture %@", textureName ] userInfo:nil] raise];
        return nil;
    }
}

/** 0 1 2
    3   4
    5 6 7
    **/

-(SKTexture*)calculateTexture {
    NSString* textureName = [NSString stringWithFormat:@"%i%i%i%i_%i",
                            (((MapTile*)self.surroundingTiles[6]).height),
                            (((MapTile*)self.surroundingTiles[7]).height),
                            (self.height),
                            (((MapTile*)self.surroundingTiles[4]).height),
                             ((int)(self.coordinates.x+self.coordinates.y) % 2)];
    return [MapTile textureNamed:textureName];
}

-(NSString *) description {
    return [NSString stringWithFormat:@"(%f,%f,%f)", self.coordinates.x, self.coordinates.y, self.height];
}

+(MapTile*)tile {
    return [[MapTile alloc] init];
}

+(MapTile*)tileWithCoordinates:(CGPoint)coordinatesLocal {
    return [[MapTile alloc] initWithCoordinates:coordinatesLocal];
}

+(MapTile*)nilTile {
    if (!nilTileSingleton) {
        nilTileSingleton = [[MapTile alloc] initWithCoordinates:CGPointMake(-1, -1)];
        //nilTileSingleton.backgroundColor = [[UIColor blackColor] CGColor];
        
    }
    return nilTileSingleton;
}

+(BOOL)isDirectionMajor:(int)direction {
    return (direction == w || direction == n || direction == e || direction == s);
}
@end
