//
// Fragment shader: Arc
//

precision highp float;

uniform float size;
uniform float a1;
uniform float a2;
uniform vec4 color;

varying vec2 vTexCoord;

void main() {
    vec4 col = vec4(0.0);
    vec2 r = vTexCoord - vec2(0.5);
    float d = length(r);
    if (d > size && d < 0.5) {
        float a = atan(r.y, r.x);
        if (a2 > a1) {
            if (a > a1 && a < a2) {
                col = color;
            }
        } else {
            if (a > a1 || a < a2) {
                col = color;
            }
        }
    }
    gl_FragColor = col;
}
