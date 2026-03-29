#include "./Line.cginc"

float isSquareDebugLine(float2 p, float lineThickness = 0.005)
{
    if(
        (0 <= p.x && p.x <= lineThickness) ||
        (1 - lineThickness <= p.x && p.x <= 1) ||
        (0 <= p.y && p.y <= lineThickness) ||
        (1 - lineThickness <= p.y && p.y <= 1)
    )
    {
        return 1;
    }

    return 0;
}

float isGradientDebugLine(float2 p, float2 corner, float2 gradient, float lineThickness = 0.02)
{
    // translate the point to the coordinate system of the corner
    // this is essentially the distance from p to the corner
    float2 d = p - corner;

    // check if the point belongs to the line of the gradient
    // based on a coordinate system centered on the corner
    // y = gradient.y * x

    if(0.5 < length(d))
    {
        return 0;
    }

    if(
        (gradient.y < 0 && d.y > 0) ||
        (gradient.y > 0 && d.y < 0) ||
        (gradient.x < 0 && d.x > 0) ||
        (gradient.x > 0 && d.x < 0)
    )
    {
        return 0;
    }

    float deltaY = sign(gradient.x) * gradient.y;
    float deltaX = sign(gradient.x) * gradient.x;
    float slope = deltaY / deltaX;

    return onLine(d.y, slope * d.x, lineThickness);
}

float isGradientDebugLine(
    float2 p,
    float2 a,
    float2 b,
    float2 c,
    float2 d,
    float2 gradientA,
    float2 gradientB,
    float2 gradientC,
    float2 gradientD
)
{
    if(
        isGradientDebugLine(p, a, gradientA) ||
        isGradientDebugLine(p, b, gradientB) ||
        isGradientDebugLine(p, c, gradientC) ||
        isGradientDebugLine(p, d, gradientD)
    )
    {
        return 1;
    }

    return 0;
}
