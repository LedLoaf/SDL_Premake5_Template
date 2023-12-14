-- === premake5.lua ===
_workspace = {}
_workspace["workspace"] = "WorkspaceName"

-- Architecture 
_arch = {}
_arch["x86"] = "x86"
_arch["x64"] = "x64"

-- Configuration
_cfg = {}
_cfg["Debug"] = "Debug"
_cfg["Release"] = "Release"

-- Platforms
_platf = {}
_platf["Win32"] = "Win32"
_platf["Win64"] = "Win64"

-- Project name
_proj = {}
_proj["name"] = "ProjectName"
_proj["location"] = "ProjectLocationFolder"

-- Target directory
_proj["targetdir"] = "Bin/%{prj.name}/%{cfg.buildcfg}/%{cfg.platform}"
-- Obj directory
_proj["objdir"]    = "Bin/Obj/%{prj.name}/%{cfg.buildcfg}/%{cfg.platform}"
-- Target/exe Name (By default it's set to the project name)
_proj["targetname"] = _proj.name

-- App kind ConsoleApp or StaticLibrary
_proj["kind"] = "ConsoleApp"
_proj["systemversion"] = "latest"
_proj["toolset"] = "msc-v143"
_proj["language"] = "C++"
_proj["cppdialect"] = "C++20"

-- Third-Party library or plugin
extDir = {}
-- SDL Libraries
extDir["SDL2"] = "Vendor/SDL2"
extDir["SDL2Image"] = "Vendor/SDL2Image"
extDir["SDL2ttf"] = "Vendor/SDL2ttf"
extDir["SDL2Mixer"] = "Vendor/SDL2Mixer"

-- Workspace Setings
workspace (_workspace.workspace)
startproject (_proj.name)

-- Types of configurations (Debug, Release)
configurations
{
	(_cfg.Debug),
	(_cfg.Release),
}
 
 -- Types of platforms x86/x64
platforms 
{
	(_platf.Win32),
	(_platf.Win64),
}
 
project (_proj.name)
location (_proj.location)
targetname(_proj.targetname)
kind (_proj.kind)
systemversion(_proj.lates)
toolset(_proj.toolset)
language (_proj.language)
cppdialect(_proj.cppdialect)

-- Source/Header files to add to the project
files
{
    "Src/*.cpp",
	"Src/*.h",
}
	
-- Both Win32 Win64 Settings
filter {"system:windows","configurations:*"}

systemversion (_proj.systemversion)
targetdir(_proj.targetdir)

 externalincludedirs
{
	-- SDL Libraries Includes
    "%{extDir.SDL2}/include",
    "%{extDir.SDL2Image}/include",
    "%{extDir.SDL2ttf}/include",
	"%{extDir.SDL2Mixer}/include",
}

 links
{
	-- SDL Lib names
	"SDL2",
	"SDL2main",
	"SDL2_image",
	"SDL2_ttf",
	"SDL2_mixer",
}
 
-- Win32 Settings
filter {"system:windows", "platforms:Win32" }

architecture (_arch.x86)
objdir(_proj.objdir)

libdirs
{
 -- SDL Win32 Lib Directory
  "Vendor/SDL2/lib/x86",
  "Vendor/SDL2Image/lib/x86",
  "Vendor/SDL2ttf/lib/x86",
  "Vendor/SDL2mixer/lib/x86",
}
 
filter {"system:windows", "configurations:Debug", "platforms:Win32"}

defines 
{
    "Win32_Debug",
}

postbuildcommands
{
	-- SDL Win32 Debug .dll locations to copy from and to the correct directory
    "copy $(SolutionDir)Vendor\\SDL2\\lib\\x86\\SDL2.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win32\\SDL2.dll",
    "copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x86\\SDL2_image.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win32\\SDL2_image.dll",
    "copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x86\\SDL2_ttf.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win32\\SDL2_ttf.dll",
    "copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x86\\SDL2_mixer.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win32\\SDL2_mixer.dll",
	-- Texture .png Example
    "copy $(SolutionDir)Assets\\Textures\\house.png $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win32\\house.png",

}
	
filter {"system:windows", "configurations:Release", "platforms:Win32"}

defines 
{
  "Win32_Release",
}

postbuildcommands
{
-- SDL Win32 Realease .dll locations to copy from and to the correct directory
    "copy $(SolutionDir)Vendor\\SDL2\\lib\\x86\\SDL2.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win32\\SDL2.dll",
    "copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x86\\SDL2_image.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win32\\SDL2_image.dll",
	"copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x86\\SDL2_ttf.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win32\\SDL2_ttf.dll",
    "copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x86\\SDL2_mixer.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win32\\SDL2_mixer.dll",
	
	-- Texture .png Example
    "copy $(SolutionDir)Assets\\Textures\\house.png $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win32\\house.png",
}

-- Win64 Settings
filter {"system:windows", "platforms:Win64" }

architecture (_arch.x64)
objdir(_proj.objdir)

libdirs
{
  -- SDL Win64 Lib directories
  "Vendor/SDL2/lib/x64",
  "Vendor/SDL2Image/lib/x64",
  "Vendor/SDL2ttf/lib/x64",
  "Vendor/SDL2mixer/lib/x64",
}
 
filter {"system:windows", "configurations:Debug", "platforms:Win64"}

defines 
{
   "Win64_Debug",
}

postbuildcommands
{
	-- SDL Win64 Debug .dll locations to copy from and to the correct directory
	"copy $(SolutionDir)Vendor\\SDL2\\lib\\x64\\SDL2.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win64\\SDL2.dll",
	"copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x64\\SDL2_image.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win64\\SDL2_image.dll",
	"copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x64\\SDL2_ttf.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win64\\SDL2_ttf.dll",
	"copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x64\\SDL2_mixer.dll $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win64\\SDL2_mixer.dll",
    -- Texture .png Example
	"copy $(SolutionDir)Assets\\Textures\\house.png $(SolutionDir)Bin\\".._proj.name.."\\Debug\\Win64\\house.png",
}

filter {"system:windows", "configurations:Release", "platforms:Win64"}

defines 
{
     "Win64_Release",
}

postbuildcommands
{
	-- SDL Win64 Release .dll locations to copy from and to the correct directory
    "copy $(SolutionDir)Vendor\\SDL2\\lib\\x64\\SDL2.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win64\\SDL2.dll",
    "copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x64\\SDL2_image.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win64\\SDL2_image.dll",
    "copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x64\\SDL2_ttf.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win64\\SDL2_ttf.dll",
    "copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x64\\SDL2_mixer.dll $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win64\\SDL2_mixer.dll",
     -- Texture .png Example
	"copy $(SolutionDir)Assets\\Textures\\house.png $(SolutionDir)Bin\\".._proj.name.."\\Release\\Win64\\house.png",
}