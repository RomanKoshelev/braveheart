//
// Vertex shader: Arc
//

uniform mat4 modelViewProjection;

attribute vec4 position;
attribute vec2 texCoord;

varying highp vec2 vTexCoord;

void main() {
    vTexCoord = texCoord;
    gl_Position = modelViewProjection * position;
}
