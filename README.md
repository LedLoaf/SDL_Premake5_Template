##### This is a basic premake5 file for setting up SDL2 in C++ for Debug and Release mode for x86/x64.
***

**As of right now, it includes the following libraries:**
-  SDL2,
-  SDL2_image,
-  SDL2_ttf,
-  SDL2_mixer,
-  ImGui,
-  glm

*Note: I don't see a point in adding SDL2_net, but it's included in the folders but not the template itself.*

***

###### Open up the premake5 and fill out the appropriate variables
###### Example:
- Workspace name,     "SDL-Template"
- Project name,       "Sandbox"
- ProjectFolderName,  "Build"
- TargetName/exe,     "Sandbox" (Default is project name)

Run the .bat script and you are all ready to go.

*TODO: Probably will add Glad and GLFW, but I'm lazy and fix up this Read-Me* 



