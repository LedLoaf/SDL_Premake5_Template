This is a basic premake5 file for setting up SDL2 in C++ for Debug and Release mode for x86/x64.

As of right now it has SDL2 libaries:
SDL2,
SDL2_image,
SDL2_ttf,
SDL2_mixer.
I don't see the need for SDL2_net, but it's included but not added into the template itself.

Open up the premake5 and fill out the appropiate variables
Example:

-Workspace name,
-Project name,
-ProjectFolderName,
-TargetName/exe name,

Run the .bat script and you are all ready to go.

TODO: Imgui, glm, are currently included, but not added to the template itself..
Fix up this read me

