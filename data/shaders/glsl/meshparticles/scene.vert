#version 450

layout (location = 0) in vec4 inPos;
layout (location = 1) in vec2 inUV;
layout (location = 2) in vec3 inColor;
layout (location = 3) in vec3 inNormal;

layout (binding = 0) uniform UBOModel 
{
	float modelAlpha;	
} modelData;

layout (binding = 1) uniform UBOView
{
	mat4 projection;
	mat4 model;
	mat4 view;
} viewData;

layout (binding = 2) buffer SRVInstance
{
	vec4 instancePos[2];
} instanceData;

layout (location = 0) out vec3 outNormal;
layout (location = 1) out vec2 outUV;
layout (location = 2) out vec3 outColor;
layout (location = 3) out vec3 outPos;

void main() 
{
	vec4 instancePos = inPos + instanceData.instancePos[gl_InstanceIndex];
	gl_Position = viewData.projection * viewData.view * viewData.model * instancePos;
	
	outUV = inUV;

	// Vertex position in view space
	outPos = vec3(viewData.view * viewData.model * inPos);

	// Normal in view space
	mat3 normalMatrix = transpose(inverse(mat3(viewData.view * viewData.model)));
	outNormal = normalMatrix * inNormal;

	outColor = inColor;
}
