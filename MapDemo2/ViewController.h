//
//  ViewController.h
//  MapDemo2
//

//  Copyright (c) 2013 ABVGD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>


@class MyScene;

@interface ViewController : UIViewController {

    IBOutlet UIPinchGestureRecognizer *pinchGestureRecognizer;
    
}

@property (strong, nonatomic) MyScene *mapScene;

@end
