//
//  MapObject.m
//  maptest
//
//  Created by Milos Jovanovic on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "MapTile.h"
#import "MapObject.h"

@implementation MapObject

@synthesize homeTile;

-(id)initWithTile:(MapTile*)tile {
    if ((self = [super init])) {
        self.homeTile = tile;
    }
    return self;
}

@end
