float random(float2 pixel, float seed = 1)
{
    // magical hardcoded randomness

    const float a = 12.9898;
    const float b = 78.233;
    const float c = 43758.543123;

    float d = dot(pixel, float2(a,b)) + seed;
    float s = sin(d);

    return frac(s * c);
}
