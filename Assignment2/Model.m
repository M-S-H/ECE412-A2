//
//  Model.m
//  Assignment2
//
//  Created by Michael Hickman on 10/29/13.
//  Copyright (c) 2013 Michael Hickman. All rights reserved.
//

#import "Model.h"

@implementation Model

- (id) init
{
	self = [super init];
	
	v = NULL;
	f = NULL;
	
	vertnum = 0;
	facenum = 0;
	
	maxx = 1;
	minx = -1;
	maxy = 1;
	
	miny = maxz = minz = 0;
	
	return self;
}


- (id) initWithFile:(NSString *)file
{
	self = [self init];
	
	// Initialize Variables
	vertnum = 0;
	facenum = 0;
	
	maxx = 1;
	minx = -1;
	maxy = 1;
	
	miny = maxz = minz = 0;
	
	
	// Open File and make sure its valid
	FILE *fp;
	const char *path = [file UTF8String];
	fp = fopen(path, "r");
	
	if (fp == NULL)
	{
		NSLog(@"File not found");
		exit(1);
	}
	
	
	// Parse object
	int bars = 0;
	char ch1, ch2;
	v = (vertex *) malloc(sizeof(vertex));
	f = (face *) malloc(sizeof(face));
	
	fscanf(fp, "%c%c", &ch1, &ch2);
	while (ch1 != 'v' && ch2 != ' ')
		fscanf(fp, "%c%c", &ch1, &ch2);
	
	
	// Read Verticies
	while (ch1 == 'v' && ch2 == ' ')
	{
		v = (vertex *) realloc(v, sizeof(vertex)*(vertnum+1));
		fscanf(fp, "%f %f %f\n", &v[vertnum].x, &v[vertnum].y, &v[vertnum].z);
		[self determine_bound: vertnum];
		fscanf(fp, "%c%c", &ch1, &ch2);
		vertnum++;
	}
	
	
	// Read Faces
	while (ch1 != 'f')
		fscanf(fp, "%c", &ch1);
	
	while (ch1 != '\n')
	{
		fscanf(fp, "%c", &ch1);
		if (ch1 == '/')
			bars = 1;
	}
	
	while (ch1 != 'f')
	{
		fseek(fp, -2, SEEK_CUR);
		fscanf(fp, "%c", &ch1);
	}
	
	while (ch1 == 'f')
	{
		f = (face *) realloc(f, sizeof(face)*(facenum+1));
		if (bars)
			fscanf(fp, " %d//%d %d//%d %d//%d\n", &f[facenum].x, &f[facenum].x, &f[facenum].y, &f[facenum].y, &f[facenum].z, &f[facenum].z);
		else
			fscanf(fp, " %d %d %d\n", &f[facenum].x, &f[facenum].y, &f[facenum].z);
		
		facenum++;
		
		if (feof(fp))
			break;
		
		fscanf(fp, "%c", &ch1);
	}
	
	fclose(fp);
	
	return self;
}



- (void) determine_bound:(int)i
{
	if (v[i].x > maxx)
		maxx = v[i].x;
	else
		if (v[i].x < minx)
			minx = v[i].x;
	
	if (v[i].y > maxy)
		maxy = v[i].y;
	else
		if (v[i].y < miny)
			miny = v[i].y;
	
	if (v[i].z > maxz)
		maxz = v[i].z;
	else
		if (v[i].z < minz)
			minz = v[i].z;
	/*
	for (int j=0; j<3; j++)
	{
		
		if (tri[i].vertex[j].x > maxx)
			maxx = tri[i].vertex[0].x;
		else
			if (tri[i].vertex[j].x < minx)
				minx = tri[i].vertex[j].x;
		
		if (tri[i].vertex[j].y > maxy)
			maxy = tri[i].vertex[j].y;
		else
			if (tri[i].vertex[j].y < miny)
				miny = tri[i].vertex[j].y;
		
		if (tri[i].vertex[j].z > maxz)
			maxz = tri[i].vertex[j].z;
		else
			if (tri[i].vertex[j].z < minz)
				minz = tri[i].vertex[j].z;
	}
	*/
}

- (void) release
{
	if (v != NULL)
		free(v);
	
	if (f != NULL)
		free(f);
}

@end

/*
@implementation Model

- (id) init
{
	self = [super init];
	
	tri_num = 1;
	tri = (triangle *) malloc(sizeof(triangle));
	
	tri[0].vertex[0].x = 0;
	tri[0].vertex[0].y = 0;
	tri[0].vertex[0].z = 0;
	
	tri[0].vertex[1].x = 0;
	tri[0].vertex[1].y = 0;
	tri[0].vertex[1].z = 0;
	
	tri[0].vertex[2].x = 0;
	tri[0].vertex[2].y = 0;
	tri[0].vertex[2].z = 0;
	
	maxx = 1;
	minx = -1;
	maxy = 1;
	
	miny = maxz = minz = 0;
	
	return self;
}


- (id) initWithFile:(NSString*) file
{
	minx = miny = minz = maxx = maxy = maxz = 0;
	
	self = [super init];
	if (self)
	{
		FILE *fp;
		const char *path = [file UTF8String];
		fp = fopen(path, "r");
		
		if (fp == NULL)
		{
			NSLog(@"File not found");
			exit(1);
		}
		
		char ch;
		fscanf(fp, "%c", &ch);
		
		while (ch != '\n')
			fscanf(fp, "%c", &ch);
		
		// Read Number of Triangles and Materials
		fscanf(fp,"# triangles = %d\n", &tri_num);
		fscanf(fp,"Material count = %d\n", &material_num);
		
		// Allocate Space
		tri = (triangle *) malloc(sizeof(triangle) * tri_num);
		mat = (material *) malloc(sizeof(material) * material_num);
		
		// Read Material Parameters
		for (int i=0; i<material_num; i++)
		{
			fscanf(fp, "ambient color %f %f %f\n", &(mat[i].colora[0]), &(mat[i].colora[1]), &(mat[i].colora[2]));
			fscanf(fp, "diffuse color %f %f %f\n", &(mat[i].colord[0]), &(mat[i].colord[1]), &(mat[i].colord[2]));
			fscanf(fp, "specular color %f %f %f\n", &(mat[i].colors[0]), &(mat[i].colors[1]), &(mat[i].colors[2]));
			fscanf(fp, "material shine %f\n", &(mat[i].shine));
		}
		
		fscanf(fp, "%c", &ch);
		while (ch != '\n')
			fscanf(fp, "%c", &ch);
		
		int color_index[3];
		
		// Read Triangles
		for (int i=0; i<tri_num; i++)
		{
			fscanf(fp, "v0 %f %f %f %f %f %f %d\n", &(tri[i].vertex[0].x), &(tri[i].vertex[0].y), &(tri[i].vertex[0].z), &(tri[i].normal[0].x), &(tri[i].normal[0].y), &(tri[i].normal[0].z), &(color_index[0]));
			
			if (i==0)
			{
				maxx = minx = tri[i].vertex[0].x;
				maxy = miny = tri[i].vertex[0].y;
				maxz = minz = tri[i].vertex[0].z;
			}
			
			fscanf(fp, "v1 %f %f %f %f %f %f %d\n", &(tri[i].vertex[1].x), &(tri[i].vertex[1].y), &(tri[i].vertex[1].z), &(tri[i].normal[1].x), &(tri[i].normal[1].y), &(tri[i].normal[1].z), &(color_index[1]));
			
			fscanf(fp, "v2 %f %f %f %f %f %f %d\n", &(tri[i].vertex[2].x), &(tri[i].vertex[2].y), &(tri[i].vertex[2].z), &(tri[i].normal[2].x), &(tri[i].normal[2].y), &(tri[i].normal[2].z), &(color_index[2]));
			
			fscanf(fp, "face normal %f %f %f\n", &(tri[i].face_normal[0]), &(tri[i].face_normal[1]), &(tri[i].face_normal[2]));
			
			[self determine_bound: i];
			
			tri[i].color[0] = 255 * mat[color_index[0]].colord[0];
			tri[i].color[1] = 255 * mat[color_index[0]].colord[1];
			tri[i].color[2] = 255 * mat[color_index[0]].colord[2];
		}
		
		fclose(fp);
	}
	
	return self;
}



- (void) determine_bound:(int)i
{
	for (int j=0; j<3; j++)
	{
		
		if (tri[i].vertex[j].x > maxx)
			maxx = tri[i].vertex[0].x;
		else
			if (tri[i].vertex[j].x < minx)
				minx = tri[i].vertex[j].x;
		
		if (tri[i].vertex[j].y > maxy)
			maxy = tri[i].vertex[j].y;
		else
			if (tri[i].vertex[j].y < miny)
				miny = tri[i].vertex[j].y;
		
		if (tri[i].vertex[j].z > maxz)
			maxz = tri[i].vertex[j].z;
		else
			if (tri[i].vertex[j].z < minz)
				minz = tri[i].vertex[j].z;
	}
}


@end
 */
