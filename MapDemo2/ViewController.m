//
//  ViewController.m
//  MapDemo2
//
//  Created by Milos Jovanovic on 2013-09-20.
//  Copyright (c) 2013 ABVGD. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "MapData.h"



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [pinchGestureRecognizer addTarget:self action:@selector(pinchHappened:)];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    self.mapScene = scene;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark map stuff

- (void)pinchHappened:(UIPinchGestureRecognizer*)pinch {

    [self.mapScene mapDidPinch:pinch.scale];
}



@end
