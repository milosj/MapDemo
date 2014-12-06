//
//  MapTile.h
//  maptest
//
//  Created by Milos Jovanovic on 12-04-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class MapData;

typedef enum {
    nw,
    n,
    ne,
    w,
    e,
    se,
    s,
    sw
}directions;

@interface MapTile : SKSpriteNode {
    int rainfall;
    UIColor* color;
}

-(void)connectWithTiles:(MapData*)map;
-(void)setHeight:(int)height;
-(NSString*)textureName;
-(SKTexture*)calculateTexture;

+(MapTile*)tile;
+(MapTile*)tileWithCoordinates:(CGPoint)coordinates;
+(MapTile*)nilTile;
+(BOOL)isDirectionMajor:(int)direction;

@property (assign, nonatomic) int height;
@property (assign, nonatomic) CGPoint coordinates;
@property (strong, nonatomic) NSMutableArray* surroundingTiles;
@property (strong, nonatomic) NSMutableSet* objects;

@end
