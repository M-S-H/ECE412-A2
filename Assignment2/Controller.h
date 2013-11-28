//
//  Controller.h
//  Assignment2
//
//  Created by Michael Hickman on 10/29/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "MainView.h"

@interface MyCustomView : NSView
{
	IBOutlet id OpenGLView;
	
	IBOutlet NSTextField *posx;
	IBOutlet NSTextField *posy;
	IBOutlet NSTextField *posz;
	IBOutlet NSTextField *dirx;
	IBOutlet NSTextField *diry;
	IBOutlet NSTextField *dirz;
	
	IBOutlet NSTextField *near;
	IBOutlet NSTextField *far;
	
	IBOutlet NSSlider *red;
	IBOutlet NSSlider *green;
	IBOutlet NSSlider *blue;
}

- (IBAction)resetCam:(id)sender;
- (IBAction)changeColor:(id)sender;
- (IBAction)changeNearFar:(id)sender;
- (IBAction)changeMode:(id)sender;
- (IBAction)changeCull:(id)sender;
- (IBAction)openModel:(id)sender;
- (IBAction)debug:(id)sender;

- (void) setNearFar:(float)near :(float)far;
- (void) updateLabels: (float)posx :(float)posy :(float)posz :(float)dirx :(float) diry :(float)dirz;

@end

