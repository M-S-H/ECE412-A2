//
//  MainView.h
//  Assignment2
//
//  Created by Michael Hickman on 10/29/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Controller.h"
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "Model.h"
#import "Matrix.h"
#import "Shader.h"



@interface MainView : NSOpenGLView
{
	camera		cam;
	GLfloat		shapeSize;
	Model		*m;
	
	float		increment;
	
	GLenum		polyMode;
	GLenum		cullMode;
	
	NSPoint		start;
	
	float		color[3];
	
	ModelView	*mvm;
	Projection	*pm;
	
	IBOutlet id con;
	
	Shader *shader;
	GLhandleARB program;
}

+ (NSOpenGLPixelFormat*) basicPixelFormat;

- (void) drawObject;
- (void) updateProjection;
- (void) updateModelView;
- (void) resizeGL;
- (void) resetCamera;
- (void) updateCamera: (float)posx :(float)posy :(float)posz :(float)dirx :(float)diry :(float)dirz;
- (void) updateColor: (float)red :(float)green :(float)blue;
- (void) updateNearFar: (float)near :(float)far;
- (void) updateMode: (int)tag;
- (void) updateCulling: (int)tag;
- (void) printCamera;
- (void) loadModel: (NSString *)s;
- (GLuint) loadShader;

- (void) drawRect:(NSRect)bounds;
- (void) prepareOpenGL;
- (void) update;

- (void) keyDown:(NSEvent *)theEvent;
- (void) mouseDown: (NSEvent *)theEvent;
- (void) mouseDragged:(NSEvent *)theEvent;
- (void) mouseUp:(NSEvent *)theEvent;

- (BOOL) acceptsFirstResponder;
- (BOOL) becomeFirstResponder;
- (BOOL) resignFirstResponder;

- (id) initWithFrame: (NSRect)frameRect;
- (void) awakeFromNib;


@end
