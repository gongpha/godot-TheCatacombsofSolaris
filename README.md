# TheCatacombsofSolaris
Simple implementation of Original [The Catacombs of Solaris by Ian MacLarty](https://ianmaclarty.itch.io/catacombs-of-solaris-original) in Godot 3.x

Work with GLES2 and GLES3 (with HDR turn off).
This repository introduces only illusion on meshes. No level generation included.

![image](https://user-images.githubusercontent.com/13400398/162386443-1cd5635a-1c65-4001-be56-85af90dd956d.png)

Press E to apply the illusion<br />
Press R to reset the world<br />
Press T to toggle an overlay of Godot icons<br />

# Customing
- Meshes
  - Make sure your meshes have subdivisions, At least 8 times. Because subdivisions reduce affines on surfaces. You can adjust more for the smoothness of the illusion but with less performance.

- Textures
  - Recommend importing with "Filter" and "Mipmaps" options off.

- Other MeshInstances
  - Add `MeshInstance` nodes in `Spatial` named `meshes`. Then set material `res://resource/surface.tres` in `Material Override`
