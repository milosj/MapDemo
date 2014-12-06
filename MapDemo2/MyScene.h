//
//  MyScene.h
//  MapDemo2
//

//  Copyright (c) 2013 ABVGD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MapData;

@interface MyScene : SKScene {
    __strong NSMutableArray* layerMap;
    __strong NSMutableArray* layerBucket;
    CGRect lastDrawnRect;
}


+(CGPoint)mapCoordinatesAtScreenPoint:(CGPoint)screenPoint;
+(CGPoint)cmapCoordinatesAtScreenPoint:(CGPoint)screenPoint;
+(CGPoint)fmapCoordinatesAtScreenPoint:(CGPoint)screenPoint;



@property (strong, nonatomic) MapData* mapData;
@property (assign) BOOL contentCreated;
@end
