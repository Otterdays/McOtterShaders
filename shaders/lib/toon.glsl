#ifndef TOON_GLSL
#define TOON_GLSL

float quantizeToon(float value, int steps) {
    float clamped = clamp(value, 0.0, 1.0);
    float safeSteps = max(float(steps), 2.0);
    return floor(clamped * safeSteps) / (safeSteps - 1.0);
}

vec3 applyToonBands(vec3 color, int steps, float strength) {
    float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
    float bandedLuminance = quantizeToon(luminance, steps);
    float ratio = bandedLuminance / max(luminance, 0.0001);
    vec3 bandedColor = color * ratio;
    return mix(color, bandedColor, clamp(strength, 0.0, 1.0));
}

#endif
