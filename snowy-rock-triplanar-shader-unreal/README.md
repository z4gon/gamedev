# Snowy Rock Triplanar Shader

Implemented with Triplanar Projection and Normals Orientation in **Unreal Engine 5.1.0**

## Screenshots

![Picture](./docs/24.jpg)

https://user-images.githubusercontent.com/4588601/204041568-94ed3589-7bbd-4e1e-b676-39c586320045.mp4

### Table of Content

- [Implementation](#implementation)
  - [Model Meshes](#model-meshes)
  - [Setup Scene](#setup-scene)
  - [Import Textures](#import-textures)
  - [Rock Material](#rock-material)
    - [Basic Rock](#basic-rock)
    - [Triplanar Projection Material](#triplanar-projection-material)
      - [Normal Masking](#normal-masking)
      - [TriplanarProjection Material Function](#triplanarprojection-material-function)
  - [Material Instances](#material-instances)
  - [Snow Material](#snow-material)
  - [Snowy Rock Material](#snowy-rock-material)
    - [Snow and Rock Material Functions](#snow-and-rock-material-functions)
    - [Masking Roughness](#masking-roughness)

### Resources

- [Unreal Engine Materials Course by Timothy Trankle](https://www.udemy.com/course/unlocking-the-unreal-engine-material-editor)
- [Rock Texure](https://3dtextures.me/2022/03/03/rock-044/)
- [Snow Texture](https://3dtextures.me/2018/02/27/snow-002/)

## Implementation

### Model Meshes

- Model Meshes in Blender for the Rocks and the Ground.
- Ensure Normals are pointing to the right direction.

![Picture](./docs/1.jpg)

- Export as FBX and then import into Unreal Engine.

![Picture](./docs/2.jpg)

### Setup Scene

- Set the terrain and the rocks.

![Picture](./docs/3.jpg)

- **Directional Light** to simulate the Sun.
- **Exponential Height Fog** to replace the default black background.
- **Sky Atmosphere** to simulate the Sky Box.
- **Sky Light** for Ambient Lighting.
- **Post Processing Volume** to tweak the Auto Exposure.

![Picture](./docs/25.jpg)

### Import Textures

### Rock Material

#### Basic Rock

- Implement a basic material using each of the textures for the corresponding property in the shader.

![Picture](./docs/4.jpg)

#### Triplanar Projection Material

- Use the **World Position** vector to sample the texture 2D, using the plane coordinates as if they were UV coordinates.
- Using the Red and Green channels means using the X,Y plane, thus projecting from the Z direction (Up, Down).
- This projection doesn't depend on object scale, UV maps, or anything.

![Picture](./docs/5.jpg)
![Picture](./docs/6.jpg)

- Repeating the process for all the 3 dimensions gives us the 3 projections we need.

![Picture](./docs/7.jpg)

##### Normal Masking

- To blend together the 3 projections, we need to use the normals directions.
- Getting the absolute value of the Blue coordinate of the Normals, gives us a mask to blend in the Z projection.
- Using a power function we make the blending band smoother.

![Picture](./docs/8.jpg)
![Picture](./docs/9.jpg)

- Multiplying each mask to the corresponding projection, then blending them all together by adding the colors, gives us the triplanar projection.

![Picture](./docs/10.jpg)

##### TriplanarProjection Material Function

- Extracting a set of nodes into a sub graph means creating a **Material Function**.
- This function has inputs and outputs.
- We can then reuse this in other materials.
- In the main **Triplanar Surface** **Material**, we now use the **Triplanar Projection** **Material Function** for each of the texures.

![Picture](./docs/11.jpg)
![Picture](./docs/12.jpg)

### Material Instances

- By making instances of a base material, we just change the parametrized textures and values.
- Make a material instance of the Triplanar Surface Material, to implement the Rock Material Instance.

![Picture](./docs/13.jpg)
![Picture](./docs/14.jpg)

### Snow Material

- Implement a new **Material** using the **TriplanarProjection** **Material Function**.
- Change the light model to **Subsurface**, for subsurface scattering.
- The **Subsurface **Color represents the subsurface scattering color.
- **Opacity** will dictate how much subsurface scattering will happen.

![Picture](./docs/15.jpg)
![Picture](./docs/16.jpg)

### Snowy Rock Material

#### Snow and Rock Material Functions

- Implement two **Material Functions** that will output **MakeMaterialAttributes** for both the **Snow** and **Rock** **Materials**.

![Picture](./docs/17.jpg)
![Picture](./docs/18.jpg)

#### Masking Roughness

- Use a texture to clamp values of 0,1 based on the threshold desired for the amount of snow.

![Picture](./docs/19.jpg)

- Mask again, this time using the Blue channel of the vertex normal, to just get the sides that are pointing up in world space.

![Picture](./docs/20.jpg)

- Use a height map to make the transition more natural, following the shapes of the texture.

![Picture](./docs/21.jpg)

- Multiply all these masks together to get the final mask used to blend the two **Material Properties**.

![Picture](./docs/22.jpg)
![Picture](./docs/23.jpg)

- Final result.

![Picture](./docs/24.jpg)
