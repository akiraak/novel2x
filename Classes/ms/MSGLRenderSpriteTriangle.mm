#if 0
//
//  RenderSpriteTriangle.m
//  IAI
//
//  Created by akira on 09/05/19.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RenderSpriteTriangle.h"

@implementation RenderSpriteTriangle

- (void)setTriangleType:(RENDER_SPRITETRIANGLE_TYPE)_type{
	type = _type;
}

- (void) draw{
	CGSize		size = [self textureUVSize];
	GLfloat		widthHalf = size.width * 0.5;
	GLfloat		heightHalf = size.height * 0.5;
	GLfloat		centerX = pos.x + widthHalf;
	GLfloat		centerY = pos.y + heightHalf;
	widthHalf = widthHalf * scale.x;
	heightHalf = heightHalf * scale.y;
	GLfloat		coordinates[6];	
	GLfloat		vertices[9];

	/*	GLfloat		coordinates[] =
	 {
	 uv.uv0.x,
	 uv.uv0.y,
	 uv.uv1.x,
	 uv.uv0.y,
	 uv.uv0.x,
	 uv.uv1.y,
	 uv.uv1.x,
	 uv.uv1.y,
	 };
	 */
	/*	GLfloat		vertices[] =
	 {
	 centerX + ((-widthHalf)*cos(r) + (-heightHalf)*sin(r)),	centerY + ((-widthHalf)*-sin(r) + (-heightHalf)*cos(r)),	0.0,
	 centerX + (( widthHalf)*cos(r) + (-heightHalf)*sin(r)),	centerY + (( widthHalf)*-sin(r) + (-heightHalf)*cos(r)),	0.0,
	 centerX + ((-widthHalf)*cos(r) + ( heightHalf)*sin(r)),	centerY + ((-widthHalf)*-sin(r) + ( heightHalf)*cos(r)),	0.0,
	 centerX + (( widthHalf)*cos(r) + ( heightHalf)*sin(r)),	centerY + (( widthHalf)*-sin(r) + ( heightHalf)*cos(r)),	0.0,
	 };
	 */	
	switch(type){
		case RENDER_SPRITETRIANGLE_TYPE_LT:			
			coordinates[0] = uv.uv0.x;
			coordinates[1] = uv.uv0.y;
			coordinates[2] = uv.uv1.x;
			coordinates[3] = uv.uv0.y;
			coordinates[4] = uv.uv0.x;
			coordinates[5] = uv.uv1.y;
			vertices[0] = centerX + ((-widthHalf)*cos(r) + (-heightHalf)*sin(r));
			vertices[1] = centerY + ((-widthHalf)*-sin(r) + (-heightHalf)*cos(r));
			vertices[2] = 0.0;
			vertices[3] = centerX + (( widthHalf)*cos(r) + (-heightHalf)*sin(r));
			vertices[4] = centerY + (( widthHalf)*-sin(r) + (-heightHalf)*cos(r));
			vertices[5] = 0.0;
			vertices[6] = centerX + ((-widthHalf)*cos(r) + ( heightHalf)*sin(r));
			vertices[7] = centerY + ((-widthHalf)*-sin(r) + ( heightHalf)*cos(r));
			vertices[8] = 0.0;
			break;
		case RENDER_SPRITETRIANGLE_TYPE_LB:
			coordinates[0] = uv.uv0.x;
			coordinates[1] = uv.uv0.y;
			coordinates[2] = uv.uv0.x;
			coordinates[3] = uv.uv1.y;
			coordinates[4] = uv.uv1.x;
			coordinates[5] = uv.uv1.y;
			vertices[0] = centerX + ((-widthHalf)*cos(r) + (-heightHalf)*sin(r));
			vertices[1] = centerY + ((-widthHalf)*-sin(r) + (-heightHalf)*cos(r));
			vertices[2] = 0.0;
			vertices[3] = centerX + ((-widthHalf)*cos(r) + ( heightHalf)*sin(r));
			vertices[4] = centerY + ((-widthHalf)*-sin(r) + ( heightHalf)*cos(r));
			vertices[5] = 0.0;
			vertices[6] = centerX + (( widthHalf)*cos(r) + ( heightHalf)*sin(r));
			vertices[7] = centerY + (( widthHalf)*-sin(r) + ( heightHalf)*cos(r));
			vertices[8] = 0.0;
			break;

		case RENDER_SPRITETRIANGLE_TYPE_RT:
			coordinates[0] = uv.uv0.x;
			coordinates[1] = uv.uv0.y;
			coordinates[2] = uv.uv1.x;
			coordinates[3] = uv.uv0.y;
			coordinates[4] = uv.uv1.x;
			coordinates[5] = uv.uv1.y;
			vertices[0] = centerX + ((-widthHalf)*cos(r) + (-heightHalf)*sin(r));
			vertices[1] = centerY + ((-widthHalf)*-sin(r) + (-heightHalf)*cos(r));
			vertices[2] = 0.0;
			vertices[3] = centerX + (( widthHalf)*cos(r) + (-heightHalf)*sin(r));
			vertices[4] = centerY + (( widthHalf)*-sin(r) + (-heightHalf)*cos(r));
			vertices[5] = 0.0;
			vertices[6] = centerX + (( widthHalf)*cos(r) + ( heightHalf)*sin(r));
			vertices[7] = centerY + (( widthHalf)*-sin(r) + ( heightHalf)*cos(r));
			vertices[8] = 0.0;
			break;
		case RENDER_SPRITETRIANGLE_TYPE_RB:
			coordinates[0] = uv.uv1.x;
			coordinates[1] = uv.uv0.y;
			coordinates[2] = uv.uv0.x;
			coordinates[3] = uv.uv1.y;
			coordinates[4] = uv.uv1.x;
			coordinates[5] = uv.uv1.y;
			vertices[0] = centerX + (( widthHalf)*cos(r) + (-heightHalf)*sin(r));
			vertices[1] = centerY + (( widthHalf)*-sin(r) + (-heightHalf)*cos(r));
			vertices[2] = 0.0;
			vertices[3] = centerX + ((-widthHalf)*cos(r) + ( heightHalf)*sin(r));
			vertices[4] = centerY + ((-widthHalf)*-sin(r) + ( heightHalf)*cos(r));
			vertices[5] = 0.0;
			vertices[6] = centerX + (( widthHalf)*cos(r) + ( heightHalf)*sin(r));
			vertices[7] = centerY + (( widthHalf)*-sin(r) + ( heightHalf)*cos(r));
			vertices[8] = 0.0;
			break;
	}
	
	glBindTexture(GL_TEXTURE_2D, texture.textureName);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glColorPointer(4, GL_FLOAT, 0, vertexColors);
	glEnableClientState(GL_COLOR_ARRAY);
	
	if(alphaTest){
		glEnable(GL_ALPHA_TEST);
	}
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
	
	if(alphaTest){
		glDisable(GL_ALPHA_TEST);
	}
}

@end

#endif