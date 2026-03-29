float onLine(float y, float fx, float lineWidth)
{
    float halfLineWidth = lineWidth * 0.5;

    // returns 1 when (x,y) is in the line: y = fx
    return step(
        fx - halfLineWidth,
        y
    ) - step(
        fx + halfLineWidth,
        y
    );
}
