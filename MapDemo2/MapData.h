//
//  MapData.h
//  maptest
//
//  Created by Milos Jovanovic on 12-04-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapData : NSObject {
    
}

-(id)tileAtMapX:(int)x andMapY:(int)y;
-(id)tileAtMapCoordinates:(CGPoint)coordinates;

@property(strong, nonatomic) NSMutableArray *allTiles;
@property(strong, nonatomic) NSMutableArray *rows;
@property(assign, nonatomic) CGSize mapSize;
@end
