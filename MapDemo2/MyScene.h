//
//  MyScene.h
//  MapDemo2
//

//  Copyright (c) 2013 ABVGD. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define MAX_ZOOM 1.25f
#define MIN_ZOOM 0.75f
#define ZOOM_BOUNCE 0.1f;

@class MapData;

@interface MyScene : SKScene {
    __strong NSMutableArray* layerMap;
    __strong NSMutableArray* layerBucket;
    CGRect lastDrawnRect;
    CGPoint lastTouchLocation;
    BOOL isZooming;
    
    CGFloat mapZoom;
    CGFloat startingMapZoom;
}


+(CGPoint)mapCoordinatesAtScreenPoint:(CGPoint)screenPoint;
+(CGPoint)cmapCoordinatesAtScreenPoint:(CGPoint)screenPoint;
+(CGPoint)fmapCoordinatesAtScreenPoint:(CGPoint)screenPoint;

-(CGFloat)maxZoom;
-(CGFloat)minZoom;

-(void)mapDidPinch:(CGFloat)pinch;

@property (strong, nonatomic) MapData* mapData;
@property (assign) BOOL contentCreated;
@property (assign, nonatomic) CGPoint mapOffset;
@property (strong, nonatomic) SKNode* mapRootNode;
@property (assign, nonatomic) CGFloat zoom;
@end
