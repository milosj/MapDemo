//
//  MapObject.h
//  maptest
//
//  Created by Milos Jovanovic on 12-04-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MapTile;

@interface MapObject : NSObject

@property (strong, nonatomic) MapTile* homeTile;


-(id)initWithTile:(MapTile*)tile;

@end
