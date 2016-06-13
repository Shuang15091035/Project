//
//  JCVertexDeclaration.h
//  June Winter
//
//  Created by GavinLo on 14-10-15.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#ifndef __jw__JCVertexDeclaration__
#define __jw__JCVertexDeclaration__

#include <jw/JCBase.h>
#include <jw/JCVertexElement.h>
#include <jw/JCVertex3.h>

JC_BEGIN

typedef enum {
    
    JCVertexDeclarationMaxVertexElements = 8 + JCMaxTexCoordSetsPreVertex + JCMaxBonesPreVertex,
    
}JCVertexDeclarationConstants;

typedef struct
{
    JCVertexElement elements[JCVertexDeclarationMaxVertexElements];
    JCUInt numElements;
    JCUInt numTexCoords;
    JCUInt numBoneWeights;
    
}JCVertexDeclaration;

JCVertexDeclaration JCVertexDeclarationMake();
JCVertexElement JCVertexDeclarationAddElement(JCVertexDeclaration* vertexDeclaration, const JCVertexElement* element);
JCVertexElement JCVertexDeclarationElementAt(const JCVertexDeclaration* vertexDeclaration, int index);
JCVertexElement JCVertexDeclarationGetElementBySemantic(const JCVertexDeclaration* vertexDeclaration, JCUInt semantic);
JCUInt JCVertexDeclarationGetVertexSize(const JCVertexDeclaration* vertexDeclaration);
void JCVertexDeclarationClear(JCVertexDeclaration* vertexDeclaration);
void JCVertexDeclarationDeepCopy(JCVertexDeclaration* dst, const JCVertexDeclaration* src);

JC_END

#endif /* defined(__jw__JCVertexDeclaration__) */
