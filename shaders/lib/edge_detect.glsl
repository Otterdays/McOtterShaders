#ifndef EDGE_DETECT_GLSL
#define EDGE_DETECT_GLSL

float sampleDepthDelta(sampler2D depthTex, vec2 uv, vec2 pixelStep) {
    float center = texture2D(depthTex, uv).r;
    float right = texture2D(depthTex, uv + vec2(pixelStep.x, 0.0)).r;
    float left = texture2D(depthTex, uv - vec2(pixelStep.x, 0.0)).r;
    float up = texture2D(depthTex, uv + vec2(0.0, pixelStep.y)).r;
    float down = texture2D(depthTex, uv - vec2(0.0, pixelStep.y)).r;
    return abs(center - right) + abs(center - left) + abs(center - up) + abs(center - down);
}

float sampleNormalDelta(sampler2D normalTex, vec2 uv, vec2 pixelStep) {
    vec3 center = texture2D(normalTex, uv).xyz * 2.0 - 1.0;
    vec3 right = texture2D(normalTex, uv + vec2(pixelStep.x, 0.0)).xyz * 2.0 - 1.0;
    vec3 left = texture2D(normalTex, uv - vec2(pixelStep.x, 0.0)).xyz * 2.0 - 1.0;
    vec3 up = texture2D(normalTex, uv + vec2(0.0, pixelStep.y)).xyz * 2.0 - 1.0;
    vec3 down = texture2D(normalTex, uv - vec2(0.0, pixelStep.y)).xyz * 2.0 - 1.0;

    float rx = 1.0 - dot(center, normalize(right));
    float lx = 1.0 - dot(center, normalize(left));
    float uy = 1.0 - dot(center, normalize(up));
    float dy = 1.0 - dot(center, normalize(down));
    return max(rx + lx + uy + dy, 0.0);
}

float edgeMaskFromDepthNormal(
    sampler2D depthTex,
    sampler2D normalTex,
    vec2 uv,
    vec2 pixelStep,
    float depthSensitivity,
    float normalSensitivity,
    float intensity
) {
    float depthEdge = sampleDepthDelta(depthTex, uv, pixelStep) * depthSensitivity;
    float normalEdge = sampleNormalDelta(normalTex, uv, pixelStep) * normalSensitivity;

    // Reduce "texture static" outlines by favoring depth discontinuities.
    float gatedNormal = normalEdge * smoothstep(0.01, 0.08, depthEdge);
    float edge = clamp(depthEdge * 1.20 + gatedNormal * 0.35, 0.0, 1.0);
    return smoothstep(0.35, 0.80, edge) * clamp(intensity, 0.0, 1.25);
}

#endif
