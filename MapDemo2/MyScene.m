//
//  MyScene.m
//  MapDemo2
//
//  Created by Milos Jovanovic on 2013-09-20.
//  Copyright (c) 2013 ABVGD. All rights reserved.
//

#import "MapTile.h"
#import "MapData.h"
#import "MyScene.h"

extern float TILE_SIZE;

#define LEFTRIGHT_OVERLAP 5.0f
#define UPDOWN_OVERLAP 5.0f
#define hex 0.0f

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
//        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
//        
//        myLabel.text = @"Hello, World!";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                       CGRectGetMidY(self.frame));
//        
//        [self addChild:myLabel];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        MapTile* tile = (MapTile*)[self nodeAtPoint:location];
        NSLog(@"Tile %@ h:%i %@", tile, tile.height, [tile textureName]);
        lastTouchLocation = location;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint delta = CGPointMake(lastTouchLocation.x-location.x, lastTouchLocation.y-location.y);
        self.mapOffset = CGPointMake(self.mapOffset.x+delta.x, self.mapOffset.y+delta.y);
        if (abs(delta.x) > 1 || abs(delta.y) > 1) {
            for (SKNode* node in self.children) {
                node.position = CGPointMake(node.position.x-delta.x, node.position.y-delta.y);
            }
            
        }
        lastTouchLocation = location;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    
    self.mapData = [[MapData alloc] init];
    /*SKAction* motionOfTheOceanUp = [SKAction moveBy:CGVectorMake(0, 20.0f) duration:3.0f];
    motionOfTheOceanUp.timingMode = SKActionTimingEaseInEaseOut;
    SKAction* motionOfTheOceanDown = [motionOfTheOceanUp reversedAction];
    SKAction* motionOfTheOceanWave = [SKAction sequence:@[motionOfTheOceanUp, motionOfTheOceanDown]];
    SKAction* motionOfTheOceanRepeat = [SKAction repeatActionForever:motionOfTheOceanWave];
    
    SKAction* travelFullLength = [SKAction moveByX:500 y:0 duration:30];
    SKAction* resetTravel = [SKAction moveByX:-500 y:0 duration:0];
    SKAction* travelLoop = [SKAction repeatActionForever:[SKAction sequence:@[travelFullLength, resetTravel]]];
    SKAction* motionGroup = [SKAction group:@[travelLoop, motionOfTheOceanRepeat]];

    //SKAction* prime = [SKAction rotateByAngle:M_PI*0.1f duration:0.0f];
    SKAction* rotate = [SKAction sequence:@[ [SKAction rotateByAngle:M_PI*0.3 duration:0], [SKAction rotateByAngle:-M_PI duration:3.0f]]];
    SKAction* travel = [SKAction moveByX:250 y:0 duration:3.0f];
    travel.timingMode = SKActionTimingEaseInEaseOut;
    SKAction* rise = [SKAction moveByX:0 y:250 duration:1.0f];
    rise.timingMode = SKActionTimingEaseOut;
    SKAction* fall = [SKAction moveByX:0 y:-250 duration:2.0f];
    fall.timingMode = SKActionTimingEaseIn;
    SKAction* riseAndFall = [SKAction sequence:@[rise, fall]];
    SKAction* rotateBack = [SKAction rotateByAngle:M_PI*0.7 duration:0];
    SKAction* travelBack = [SKAction moveByX:-250 y:0 duration:0];
    SKAction* waveAction = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction group:@[rotate, travel, riseAndFall]], [SKAction waitForDuration:1.5f],travelBack,rotateBack]]];
    
    SKTexture* bckgrnd = [SKTexture textureWithImageNamed:@"seabackground.png"];
    
    for (int x=0; x<6; x++) {
        for (int y=0; y<16; y++) {
            SKSpriteNode* bkg = [SKSpriteNode spriteNodeWithTexture:bckgrnd size:CGSizeMake(250, 125)];
            bkg.position = CGPointMake(x*249-250, y*60);
            bkg.zPosition = -y;
            
            [bkg runAction:[SKAction sequence:@[[SKAction waitForDuration:y*0.2], motionGroup]]];
            [self addChild:bkg];
        }
    }*/
    
    /*for (int x=0; x<4; x+=2) {
        for (int y=0; y<8; y+=2) {
            SKSpriteNode* wave = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"wave.png"] size:CGSizeMake(500, 500)];
            wave.position = CGPointMake(x*500+250, y*125-200);
            wave.zPosition = -y - 0.1;
            
            [wave runAction:[SKAction sequence:@[[SKAction waitForDuration:(arc4random()%20)/10.0f], waveAction]]];
            [self addChild:wave];
        }
    }*/
    
    
    //create map
    /*layerMap = [NSMutableArray arrayWithCapacity:1000];
    layerBucket = [NSMutableArray arrayWithCapacity:100];
    for (int y=0; y<1000; y++) {
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:1000];
        [layerMap addObject:row];
        for (int x=0; x<1000; x++) {
            [row addObject:[NSNull null]];
        }
        
    }*/
}

+(CGPoint)cmapCoordinatesAtScreenPoint:(CGPoint)screenPoint {
    CGFloat x,y;
    if (hex) {
        y = ceilf(y/(TILE_SIZE+UPDOWN_OVERLAP));
        if (((int)y)%2==0) {
            x = ceilf(x/(TILE_SIZE+LEFTRIGHT_OVERLAP));
        } else {
            x = ceilf((x-TILE_SIZE*-0.5f)/(TILE_SIZE+LEFTRIGHT_OVERLAP));
        }
    } else {
        x = ceilf(screenPoint.x/TILE_SIZE);
        y = ceilf(screenPoint.y/TILE_SIZE);
    }
    return CGPointMake(x, y);
}

+(CGPoint)fmapCoordinatesAtScreenPoint:(CGPoint)screenPoint {
    CGFloat x,y;
    if (hex) {
        y = floorf(y/(TILE_SIZE+UPDOWN_OVERLAP));
        if (((int)y)%2==0) {
            x = floorf(x/(TILE_SIZE+LEFTRIGHT_OVERLAP));
        } else {
            x = floorf((x-TILE_SIZE*-0.5f)/(TILE_SIZE+LEFTRIGHT_OVERLAP));
        }
    } else {
        x = floorf(screenPoint.x/TILE_SIZE);
        y = floorf(screenPoint.y/TILE_SIZE);
    }
    return CGPointMake(x, y);
}

+(CGPoint)mapCoordinatesAtScreenPoint:(CGPoint)screenPoint {
    CGFloat x,y;
    if (hex) {
        y = roundf(y/(TILE_SIZE+UPDOWN_OVERLAP));
        if (((int)y)%2==0) {
            x = roundf(x/(TILE_SIZE+LEFTRIGHT_OVERLAP));
        } else {
            x = roundf((x-TILE_SIZE*-0.5f)/(TILE_SIZE+LEFTRIGHT_OVERLAP));
        }
    } else {
        x = roundf(screenPoint.x/TILE_SIZE);
        y = roundf(screenPoint.y/TILE_SIZE);
    }
    return CGPointMake(x, y);
}

- (void)setMapData:(MapData *)newMapData {
    
    _mapData = newMapData;
    lastDrawnRect = CGRectMake(0, 0, 0, 0);
    
     int x = 0;
     int y = 0;
     for (NSArray* row in self.mapData.rows) {
         x=0;
         MapTile* tile;
         for (tile in row) {
             //tile.layer.bounds = CGRectMake(0, 0, TILE_SIZE, TILE_SIZE);
             
             if (hex) {
                 if (y%2==0) {
                     tile.position = CGPointMake(x*(TILE_SIZE - LEFTRIGHT_OVERLAP), y*(TILE_SIZE - UPDOWN_OVERLAP));
                 } else {
                     tile.position = CGPointMake(x*(TILE_SIZE - LEFTRIGHT_OVERLAP)+TILE_SIZE*0.5f, y*(TILE_SIZE - UPDOWN_OVERLAP));
                 }
             } else {
                 tile.position = CGPointMake(x*(TILE_SIZE), y*(TILE_SIZE));
             }
             tile.coordinates = tile.position;
             tile.size = CGSizeMake(TILE_SIZE, TILE_SIZE);
             [self addChild:tile];
         

             x++;
         }
        y++;
     
     }
     /*CGPoint startc = [MyScene mapCoordinatesAtScreenPoint:self.contentOffset];
     CGPoint endc = [MyScene mapCoordinatesAtScreenPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
     lastDrawnRect = CGRectMake(startc.x, startc.y, endc.x, endc.y);*/
}

/*-(void)oldDraw {
 CGRect newDrawingArea;
 CGPoint origin = [MapView fmapCoordinatesAtScreenPoint:rect.origin];
 CGPoint size = [MapView cmapCoordinatesAtScreenPoint:CGPointMake(rect.size.width, rect.size.height)];
 newDrawingArea = CGRectMake(MAX(origin.x, 0), MAX(origin.y, 0), MIN(size.x+2, 1000), MIN(size.y+2, 1000));
 
 if (CGRectContainsRect(lastDrawnRect, newDrawingArea)) {
 return;
 }
 
 CGPoint xDrawArea;
 CGPoint yDrawArea;
 CGPoint xEraseArea;
 CGPoint yEraseArea;
 
 if (lastDrawnRect.origin.x > newDrawingArea.origin.x) {
 xDrawArea = CGPointMake(newDrawingArea.origin.x, lastDrawnRect.origin.x);
 xEraseArea = CGPointMake(newDrawingArea.origin.x+newDrawingArea.size.width, lastDrawnRect.origin.x+lastDrawnRect.size.width);
 } else if (lastDrawnRect.origin.x+lastDrawnRect.size.width < newDrawingArea.origin.x+newDrawingArea.size.width) {
 xDrawArea = CGPointMake(lastDrawnRect.origin.x+lastDrawnRect.size.width, newDrawingArea.origin.x+newDrawingArea.size.width);
 xEraseArea = CGPointMake(lastDrawnRect.origin.x, newDrawingArea.origin.x);
 } else {
 xDrawArea = CGPointMake(0, 0);
 xEraseArea = CGPointMake(0, 0);
 }
 if (lastDrawnRect.origin.y > newDrawingArea.origin.y) {
 yDrawArea = CGPointMake(newDrawingArea.origin.y, lastDrawnRect.origin.y);
 yEraseArea = CGPointMake(newDrawingArea.origin.y+newDrawingArea.size.height, lastDrawnRect.origin.y+lastDrawnRect.size.height);
 } else if (lastDrawnRect.origin.y+lastDrawnRect.size.height < newDrawingArea.origin.y+newDrawingArea.size.height) {
 yDrawArea = CGPointMake(lastDrawnRect.origin.y+lastDrawnRect.size.height, newDrawingArea.origin.y+newDrawingArea.size.height);
 yEraseArea = CGPointMake(lastDrawnRect.origin.y, newDrawingArea.origin.y);
 } else {
 yDrawArea = CGPointMake(0, 0);
 yEraseArea = CGPointMake(0, 0);
 }
 
 CGRect xDrawRect = CGRectMake(xDrawArea.x, newDrawingArea.origin.y, xDrawArea.y-xDrawArea.x, newDrawingArea.size.height);
 CGRect xEraseRect = CGRectMake(xEraseArea.x, lastDrawnRect.origin.y, xEraseArea.y-xEraseArea.x, lastDrawnRect.size.height);
 CGRect yDrawRect = CGRectMake(newDrawingArea.origin.x, yDrawArea.x, newDrawingArea.size.width, yDrawArea.y-yDrawArea.x);
 CGRect yEraseRect = CGRectMake(lastDrawnRect.origin.x, yEraseArea.x, lastDrawnRect.size.width, yEraseArea.y-yEraseArea.x);
 
 CGRect yDrawIntersect = CGRectIntersection(xDrawRect, yDrawRect);
 //CGRect yEraseIntersect = CGRectIntersection(xEraseRect, yEraseRect);
 if (CGRectEqualToRect(xDrawRect, yDrawRect)) {
 yDrawRect = CGRectMake(0, 0, 0, 0);
 yEraseRect = CGRectMake(0, 0, 0, 0);
 } else if (yDrawIntersect.origin.x == yDrawRect.origin.x) {
 yDrawRect = CGRectMake(yDrawIntersect.origin.x+yDrawIntersect.size.width, yDrawRect.origin.y,
 yDrawRect.size.width-yDrawIntersect.size.width, yDrawRect.size.height);
 yEraseRect = CGRectMake(yEraseRect.origin.x, yEraseRect.origin.y
 , yEraseRect.size.width-yDrawIntersect.size.width, yEraseRect.size.height);
 } else if (yDrawRect.origin.x+yDrawRect.size.width == xDrawRect.origin.x+xDrawRect.size.width) {
 yDrawRect = CGRectMake(yDrawRect.origin.x, yDrawRect.origin.y,
 yDrawRect.size.width-yDrawIntersect.size.width, yDrawRect.size.height);
 yEraseRect = CGRectMake(yEraseRect.origin.x+yDrawIntersect.size.width, yEraseRect.origin.y
 , yEraseRect.size.width-yDrawIntersect.size.width, yEraseRect.size.height);
 }
 
 for (int x=xEraseRect.origin.x; x<xEraseRect.origin.x+xEraseRect.size.width; x++) {
 for (int y=xEraseRect.origin.y; y<xEraseRect.origin.y+xEraseRect.size.height; y++) {
 CALayer* layer = [[layerMap objectAtIndex:y] objectAtIndex:x];
 [layerBucket addObject:layer];
 [layer removeFromSuperlayer];
 [[layerMap objectAtIndex:y] setObject:[NSNull null] atIndex:x];
 }
 }
 for (int y=yEraseRect.origin.y; y<yEraseRect.origin.y+yEraseRect.size.height; y++) {
 for (int x=yEraseRect.origin.x; x<yEraseRect.origin.x+yEraseRect.size.width; x++) {
 CALayer* layer = [[layerMap objectAtIndex:y] objectAtIndex:x];
 [layerBucket addObject:layer];
 [layer removeFromSuperlayer];
 [[layerMap objectAtIndex:y] setObject:[NSNull null] atIndex:x];
 }
 }
 for (int x=xDrawRect.origin.x; x<xDrawRect.origin.x+xDrawRect.size.width; x++) {
 for (int y=xDrawRect.origin.y; y<xDrawRect.origin.y+xDrawRect.size.height; y++) {
 /*if (x >= mapData.mapSize.width || y >= mapData.mapSize.height) {
 break;
 }* /
 MapTile* tile = [self.mapData tileAtMapX:x andMapY:y];
 CALayer* layer;
 if (layerBucket.count) {
 layer = [layerBucket lastObject];
 [layerBucket removeObject:layer];
 } else {
 layer = [CALayer layer];
 [layer setNeedsDisplayOnBoundsChange:NO];
 /*NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], kCAOnOrderIn,
 [NSNull null], kCAOnOrderOut,
 [NSNull null], @"contents",
 [NSNull null], @"bounds",
 [NSNull null], @"position",
 [NSNull null], @"onLayout",
 nil];
 layer.actions = newActions;* /
 
 }
 
 [CATransaction begin];
 [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
 
 
 if (hex) {
 if (y%2==0) {
 layer.position = CGPointMake(x*(TILE_SIZE - LEFTRIGHT_OVERLAP), y*(TILE_SIZE - UPDOWN_OVERLAP));
 } else {
 layer.position = CGPointMake(x*(TILE_SIZE - LEFTRIGHT_OVERLAP)+TILE_SIZE*0.5f, y*(TILE_SIZE - UPDOWN_OVERLAP));
 }
 } else {
 layer.position = CGPointMake(x*(TILE_SIZE), y*(TILE_SIZE));
 }
 
 /*if ((x+y)%2 == 0) {
 layer.backgroundColor = [[UIColor redColor] CGColor];
 } else {
 layer.backgroundColor = [[UIColor whiteColor] CGColor];
 }* /
 
 //layer.contents = tile.layer.contents;
 layer.backgroundColor = tile.backgroundColor;
 layer.bounds = CGRectMake(0, 0, TILE_SIZE, TILE_SIZE);
 [self.layer addSublayer:layer];
 
 [CATransaction commit];
 
 [[layerMap objectAtIndex:y] setObject:layer atIndex:x];
 }
 }
 for (int x=yDrawRect.origin.x; x<yDrawRect.origin.x+yDrawRect.size.width; x++) {
 for (int y=yDrawRect.origin.y; y<yDrawRect.origin.y+yDrawRect.size.height; y++) {
 /*if (x >= mapData.mapSize.width || y >= mapData.mapSize.height) {
 break;
 } * /
 MapTile* tile = [self.mapData tileAtMapX:x andMapY:y];
 CALayer* layer;
 if (layerBucket.count) {
 layer = [layerBucket lastObject];
 [layerBucket removeObject:layer];
 } else {
 layer = [CALayer layer];
 [layer setNeedsDisplayOnBoundsChange:NO];
 /*NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], kCAOnOrderIn,
 [NSNull null], kCAOnOrderOut,
 [NSNull null], @"contents",
 [NSNull null], @"bounds",
 [NSNull null], @"position",
 [NSNull null], @"onLayout",
 nil];
 layer.actions = newActions;* /
 
 }
 
 [CATransaction begin];
 [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
 
 
 if (hex) {
 if (y%2==0) {
 layer.position = CGPointMake(x*(TILE_SIZE - LEFTRIGHT_OVERLAP), y*(TILE_SIZE - UPDOWN_OVERLAP));
 } else {
 layer.position = CGPointMake(x*(TILE_SIZE - LEFTRIGHT_OVERLAP)+TILE_SIZE*0.5f, y*(TILE_SIZE - UPDOWN_OVERLAP));
 }
 } else {
 layer.position = CGPointMake(x*(TILE_SIZE), y*(TILE_SIZE));
 }
 
 /*if ((x+y)%2 == 0) {
 layer.backgroundColor = [[UIColor purpleColor] CGColor];
 } else {
 layer.backgroundColor = [[UIColor grayColor] CGColor];
 }* /
 
 //layer.contents = tile.layer.contents;
 layer.backgroundColor = tile.backgroundColor;
 layer.bounds = CGRectMake(0, 0, TILE_SIZE, TILE_SIZE);
 [self.layer addSublayer:layer];
 
 [CATransaction commit];
 
 [[layerMap objectAtIndex:y] setObject:layer atIndex:x];
 }
 }
 //NSLog(@"Sublayers: %d Bucket: %d", self.layer.sublayers.count, layerBucket.count);
 //NSLog(@"%d x:%.0f,%.0f, %.0f,%.0f  y:%.0f,%.0f, %.0f,%.0f", self.layer.sublayers.count, xDrawRect.origin.x, xDrawRect.origin.y, xDrawRect.size.width, xDrawRect.size.height, yDrawRect.origin.x, yDrawRect.origin.y, yDrawRect.size.width, yDrawRect.size.height);
 lastDrawnRect = newDrawingArea;
 
 }*/

@end
