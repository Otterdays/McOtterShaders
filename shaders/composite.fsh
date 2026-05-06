#version 120

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;

uniform float OUTLINE_THICKNESS;
uniform float OUTLINE_INTENSITY;
uniform float OUTLINE_DEPTH_SENS;
uniform float OUTLINE_NORMAL_SENS;
uniform int SHADE_STEPS;
uniform float SHADE_STRENGTH;

varying vec2 texcoord;

#include "/lib/toon.glsl"
#include "/lib/edge_detect.glsl"

void main() {
    vec3 baseColor = texture2D(colortex0, texcoord).rgb;
    vec2 pixelStep = vec2(1.0 / max(viewWidth, 1.0), 1.0 / max(viewHeight, 1.0));
    vec2 kernelStep = pixelStep * max(OUTLINE_THICKNESS, 0.25);

    float edge = edgeMaskFromDepthNormal(
        depthtex0,
        colortex1,
        texcoord,
        kernelStep,
        OUTLINE_DEPTH_SENS,
        OUTLINE_NORMAL_SENS,
        OUTLINE_INTENSITY
    );

    vec3 toonColor = applyToonBands(baseColor, SHADE_STEPS, SHADE_STRENGTH);
    vec3 outlineColor = vec3(0.06, 0.05, 0.04);
    float outlineBlend = clamp(edge * 0.70, 0.0, 0.85);
    vec3 outlined = mix(toonColor, outlineColor, outlineBlend);

    gl_FragColor = vec4(clamp(outlined, 0.0, 1.0), 1.0);
}
