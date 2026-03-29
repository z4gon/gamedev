# Cg Texture Shaders in Unity

A collection of Texture manipulation Shaders written in **Cg** for the **Built-in RP** in Unity.

### References

- [Learn Unity Shaders from Scratch by Nik Lever](https://www.udemy.com/course/learn-unity-shaders-from-scratch)

## Shaders

- [Simple 2D Texture](#simple-2d-texture)
  - [Flip Texture](#flip-texture)
  - [Grayscale](#grayscale)
  - [Rotate Texture](#rotate-texture)
- [Ripple Effect](#ripple-effect)
- [Ripple Transition](#ripple-transition)

---

## Simple 2D Texture

1. Expose a ShaderLab property to take in a `2D` texture.
1. Connect the property to the Cg program, using a `sampler2D` variable.
1. Use the [tex2D()](https://developer.download.nvidia.com/cg/tex2D.html) function from cg to map a pixel from the texture, to a pixel of the fragment, using the uv coordinates.

```c
_MainTexture("Main Texture", 2D) = "white" {}
```

```c
fixed3 color = tex2D(_MainTexture, uv).rgb;
```

![Gif](./docs/1.gif)

### Flip Texture

1. Subtract the uvs to make them flip along x or y.

```c
float2 uv = float2(
    _FlipHorizontal ? 1 - i.uv.x : i.uv.x,
    _FlipVertical ? 1 - i.uv.y : i.uv.y
);
```

![Gif](./docs/1b.gif)

### Grayscale

1. Use just a channel for all colors (not ideal).

```c
fixed3 color = _Grayscale ? texColor.rrr : texColor.rgb;
```

![Gif](./docs/1c.gif)

### Rotate Texture

1. Use a rotation matrix to rotate the uvs along a specified center.

```c
float2x2 rotation = getRotationMatrix2D(UNITY_PI * _RotationAngle);
uv = mul(uv - _RotationCenter.xy, rotation) + _RotationCenter.xy;
```

![Gif](./docs/1d.gif)

## Ripple Effect

1. Get the current pixel position, this will define the axis along which we will get a displaced uv.
1. Calculate the distance of the current uv to the center, by using [length()](https://developer.download.nvidia.com/cg/length.html).
1. Displace the uv by multiplying by the `distance` and then also mixing in the `_Time` to make it oscillate.

```c
fixed4 frag (v2f i) : COLOR
{
    // use the coordinate system that is centered in (0.5, 0.5)
    float2 pixelPos = i.position.xy * 2.0;

    // get a displacement in the direction of the ray from the center to the pixel
    float distanceToCenter = length(pixelPos);
    float2 displacement = pixelPos / distanceToCenter * 0.03 * cos(
        distanceToCenter * (1 / _RippleSize) - _Time.y * _RippleVelocity
    );

    // find the texel we want to show
    float2 ripple = i.uv + displacement;

    float4 texColor = tex2D(_MainTexture, ripple);
    fixed3 color = texColor.rgb;

    return fixed4(color, 1.0);
}
```

![Gif](./docs/2.gif)

## Ripple Transition

1. Create a circular fade horizon, using the distance to the center and `smoothstep`.
1. Use a C# script to set the `Start Time` to the `Material` so that the shader program can use the value.
1. Calculate the % elapsed of the transition duration, to lerp the transition between textures.
1. Also use the elapsed % to make ripples grow in size, and slow down.

```c
// FADE HORIZON

// figure out how much of the transition has elapsed
float elapsedTime = _Time.y - _StartTime;
// add an extra second for ripple size to grow larger
// elapsedTime = clamp(elapsedTime, 0, _TransitionDuration + 1);

float elapsedPercentage = elapsedTime / _TransitionDuration;

// calculate how much of each texture should show up
float currentDistanceOfFade = 1 * elapsedPercentage;
float distanceToCenter = length(pixelPos);

float currentFade = smoothstep(
    currentDistanceOfFade - _FadeSmoothness,
    currentDistanceOfFade + _FadeSmoothness,
    distanceToCenter
);
```

```c
// RIPPLE

// make ripple size grow over time
float rippleSizeOverTime = lerp(0.02, _RippleSize, elapsedPercentage);

// get a displacement in the direction of the ray from the center to the pixel
float2 displacement = (pixelPos / distanceToCenter) * 0.03 * cos(
    distanceToCenter * (1 / rippleSizeOverTime) - elapsedTime * _RippleVelocity
);
```

```c
// BLEND

// blend the textures given the current fade
float4 texColorA = tex2D(_TextureA, ripple);
float4 texColorB = tex2D(_TextureB, ripple);

float4 blend = lerp(texColorA, texColorB, currentFade);

fixed3 color = blend.rgb;
```

![Gif](./docs/3.gif)
