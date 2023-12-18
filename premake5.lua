-- === premake5.lua ===
_workspace = {}
_workspace["workspace"] 	= "WorkspaceName"

-- Specifies the system architecture to be targeted by the configuration.(You can also use x86_64)
_arch = {}
_arch["x86"] 				= "x86"
_arch["x64"] 				= "x64"

-- Configurations are often used to store some compiler / linker settings together. Ex. Debug for debugging/x64 Release for shipping
_cfg = {}
_cfg["Debug"] 				= "Debug"
_cfg["Release"] 			= "Release"

-- Platforms specifies a set of build platforms, which act as another configuration axis when building.
_platf = {}
_platf["Win32"] 			= "Win32"
_platf["Win64"] 			= "Win64"

-- Project name
_proj = {}
_proj["name"] 				= "ProjectName"
_proj["location"] 			= "Build"			-- Project Location Folder

-- Target/exe directory
_proj["targetdir"] 			= "bin/%{prj.name}/%{cfg.buildcfg}/%{cfg.platform}"

-- Sets the directory where object and other intermediate files should be placed when building a project.
_proj["objdir"]    			= "bin/obj/%{prj.name}/%{cfg.buildcfg}/%{cfg.platform}"

-- Target/exe Name (By default it's set to the project name) 
_proj["targetname"] 		= _proj.name

-- App kind ConsoleApp or StaticLibrary
_proj["kind"] 				= "ConsoleApp"		-- Specify the type of binary output (library, executable)	
_proj["systemversion"] 		= "latest"			-- To specify the version of the SDK you want. Note: colon-delimited string specifying the min and max version, min:max.
_proj["toolset"] 			= "msc-v143"		-- Selects the compiler, linker, etc. which are used to build a project or configuration. Options: (Clag, dmd, donet, gcc, gdc, ldc, msc)
_proj["language"] 			= "C++"				-- We indicate that all the projects are C++ only
_proj["cppdialect"]			= "C++latest"		-- The version of C++. Options such as (C++14, C++17, C++20, C++latest)

-- Third-Party library or plugin				-- This is mandatory to have to track the directories
extDir = {}
-- SDL Libraries
extDir["SDL2"] 				= "Vendor/SDL2"
extDir["SDL2Image"] 		= "Vendor/SDL2Image"
extDir["SDL2ttf"] 			= "Vendor/SDL2ttf"
extDir["SDL2Mixer"] 		= "Vendor/SDL2Mixer"
extDir["ImGui"] 			= "Vendor/imgui"
extDir["glm"] 				= "Vendor/glm"

-- === Extra's ==
-- bindirs { "directory" } sets the binary directory
-- basedir ("value") Sets the base directory for a configuration, from with other paths contained by the configuration will be made relative at export time. 
		   --You do not normally need to set this value, as it is filled in automatically with the current working directory at the time the configuration block is created by the script.
-- pchheader ("stdafx.h")   Set up precompiled header file Note: Treated as a string, not a path and is not made relative to the generated project file
-- pchsource ("stdafx.cpp") 	Set up precompiled source file Note: When specifying pchsource make sure to include the path to the pchsource file just like you would for your regular source files
			 
--  filter "files:**.c"		You can filter specific files to not use the pch header file 
--  flags {"NoPCH"}		Flags is used for Enable debugging information https://github.com/premake/premake-core/wiki/flags

-- optimize "value"		The optimize function specifies the level and type of optimization used while building the target configuration. Ex. On, Off, Debug, Size, Speed, Full
-- buildoptions {"options"} 	Passes arguments directly to the compiler command line without translation.
-- linkoptions { "options" }	Passes arguments directly to the linker command line without translation.
-- 'kind' settings: ConsoleApp, WindowedApp, SharedLib, StaticLib, Makefile, Utility (custom build rules), None, Packaging (androidproj),SharedItems (used only the build settings of linked project)
-- group "GroupLabel"		Starts a "workspace group", a virtual folder to contain one or more projects.
	--include "ProjectPath"

	------------------------------------------------------------
	----------------****Workspace Settings****------------------
	------------------------------------------------------------
workspace (_workspace.workspace)
	startproject (_proj.name)				-- Specify the startup project for a workspace.
	
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
		-- These keywords are being assigned to the appropriate types we made at the beginning.
		location 		(_proj.location)	-- Set the location of compiled targets
		targetname		(_proj.targetname)	-- Set the name of compiled targets
		kind 			(_proj.kind)		-- Sets the kind of binary object being created by the project or configuration, such as a console or windowed application, or a shared or static library.
		systemversion	(_proj.lates)		-- To specify the version of the SDK you want
		toolset			(_proj.toolset)		-- Selects the compiler, linker, etc. which are used to build a project or configuration. Options: (Clag, dmd, donet, gcc, gdc, ldc, msc)
		language 		(_proj.language)	-- The language identifier. Some languages require a module for full support. Options: (C, C++, C#, F#, D)
		cppdialect		(_proj.cppdialect)	-- The version of C++. Options such as (C++14, C++17, C++20, C++latest)
	
	-- Source/Header files to add to the project
	files
	{
		"Src/**.cpp",				 		-- '**' Adds all C++ source files in the folder and subdirectories
		"Src/*.h",							-- '*' Adds all C++ header files in the folder, EXCEPT, the subdirectories
		
		"Vendor/imgui/*.cpp",
		"Vendor/imgui/*.h",					-- imgui_sdl.h and imgui_sdl.cpp are SDL backends located in the main folder. (Note: It's not using ImGui's backends)
		
		"Vendor/glm/glm/**.hpp",
		"Vendor/glm/glm/**.inl",
		
	}
		
	-- We use filters to set options for the specific builds

	-- Both Win32 Win64 Settings
	filter {"system:windows","configurations:*"}	
	
	systemversion 	(_proj.systemversion)	-- To specify the version of the SDK you want
	targetdir		(_proj.targetdir)		-- Sets the destination directory for the compiled binary target.
	
	-- Specifies the include file search paths for the compiler. Paths should be specified relative to the currently running script file.
	-- Note: 'external' keyword treats headers included from these paths as external 
	externalincludedirs
	{
		-- SDL Libraries Includes
		"%{extDir.SDL2}/include",
		"%{extDir.SDL2Image}/include",
		"%{extDir.SDL2ttf}/include",
		"%{extDir.SDL2Mixer}/include",
		"%{extDir.ImGui}",
		"%{extDir.glm}",
		
		
	}
	
	--[[ 	When linking against another project in the same workspace, specify the project name here, rather than the library name. 
	     	Premake will figure out the correct library to link against for the current configuration, and will also create a dependency between the projects to ensure a proper build order. 
		
	    	Note: When linking against system libraries, do not include any prefix or file extension. Premake will use the appropriate naming conventions for the current platform. With two exceptions:
				1. Managed C++ projects can link against managed assemblies by explicitly specifying the ".dll" file extension. Unmanaged libraries should continue to be specified without any decoration.
				2. For Visual Studio, this will add the specified project into References. In contrast, 'dependson' generates a build order dependency in the solution between two projects.--]]
	links
	{
		-- SDL Lib names
		"SDL2",
		"SDL2main",
		"SDL2_image",
		"SDL2_ttf",
		"SDL2_mixer",
		"imgui",
	}
	
	-- ** Win32 Platform Settings **
	-- We now only set the settings for the Debug configuration
	filter {"system:windows", "platforms:Win32" }
		
		symbols "On"					-- We want debug symbols in our debug config
	
	architecture 	(_arch.x86)			-- Specifies the system architecture to be targeted by the configuration.
	objdir			(_proj.objdir)		-- Sets the directory where object and other intermediate files should be placed when building a project.
	
	-- Reset the filter for other settings
	filter { }

	------------------------------------------------------------
	---------------****Win32 Debug Settings****-----------------
	------------------------------------------------------------
	filter {"system:windows", "configurations:Debug", "platforms:Win32"}
		
		symbols "On"					-- We want debug symbols in our debug config
		
	-- Specifies the library search paths for the linker (Link libraries, frameworks, or sibling projects)
	libdirs
	{
	-- SDL Win32 Lib Directory
	"Vendor/SDL2/lib/x86",
	"Vendor/SDL2Image/lib/x86",
	"Vendor/SDL2ttf/lib/x86",
	"Vendor/SDL2mixer/lib/x86",
	"Vendor/imgui/bin/Debug-x86_x64/ImGui",
	}

	-- Adds preprocessor or compiler symbols to a project. Symbols may also assign values. Ex. defines { "CALLSPEC=__dllexport" } 
	defines 
	{
		"_Debug",
	}
	
	-- Copies the .dll files to the appropiate Win32 Debug directory
	postbuildcommands
	{
		-- SDL Win32 Debug .dll locations to copy from and to the correct directory
		"copy $(SolutionDir)Vendor\\SDL2\\lib\\x86\\SDL2.dll 			$(SolutionDir)bin\\".._proj.name.."\\Debug\\Win32\\SDL2.dll",
		"copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x86\\SDL2_image.dll $(SolutionDir)bin\\".._proj.name.."\\Debug\\Win32\\SDL2_image.dll",
		"copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x86\\SDL2_ttf.dll 	$(SolutionDir)bin\\".._proj.name.."\\Debug\\Win32\\SDL2_ttf.dll",
		"copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x86\\SDL2_mixer.dll $(SolutionDir)bin\\".._proj.name.."\\Debug\\Win32\\SDL2_mixer.dll",
		-- Texture .png Example
		"copy $(SolutionDir)Assets\\Textures\\house.png 				$(SolutionDir)bin\\".._proj.name.."\\Debug\\Win32\\house.png",
	
	}
	
	------------------------------------------------------------		
	---------------****Win32 Release Settings****---------------
	------------------------------------------------------------
	filter {"system:windows", "configurations:Release", "platforms:Win32"}
	
		optimize "On"-- Release should be optimized

	-- Specifies the library search paths for the linker (Link libraries, frameworks, or sibling projects)
	libdirs
	{
	-- SDL Win32 Lib Directory
	"Vendor/SDL2/lib/x86",
	"Vendor/SDL2Image/lib/x86",
	"Vendor/SDL2ttf/lib/x86",
	"Vendor/SDL2mixer/lib/x86",
	"Vendor/imgui/bin/Release-x86_x64/ImGui",
	}

	defines 
	{
		"Release",
	}
	
	-- Copies the .dll files to the appropiate Win32 Release directory
	postbuildcommands
	{
		-- SDL Win32 Realease .dll locations to copy from and to the correct directory
		"copy $(SolutionDir)Vendor\\SDL2\\lib\\x86\\SDL2.dll 			$(SolutionDir)bin\\".._proj.name.."\\Release\\Win32\\SDL2.dll",
		"copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x86\\SDL2_image.dll $(SolutionDir)bin\\".._proj.name.."\\Release\\Win32\\SDL2_image.dll",
		"copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x86\\SDL2_ttf.dll 	$(SolutionDir)bin\\".._proj.name.."\\Release\\Win32\\SDL2_ttf.dll",
		"copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x86\\SDL2_mixer.dll $(SolutionDir)bin\\".._proj.name.."\\Release\\Win32\\SDL2_mixer.dll",
		
		-- Texture .png Example
		"copy $(SolutionDir)Assets\\Textures\\house.png 				$(SolutionDir)bin\\".._proj.name.."\\Release\\Win32\\house.png",
	}
	
	------------------------------------------------------------
	---------------****Win64 Debug Settings****---------------
	------------------------------------------------------------
	filter {"system:windows", "platforms:Win64" }
		-- We want debug symbols in our debug config
		symbols "On"

	architecture (_arch.x64)	-- Specifies the system architecture to be targeted by the configuration for x64.
	objdir(_proj.objdir)		-- Sets the x64 directory where object and other intermediate files should be placed when building a project.
		
	-- ** Win64 Debug Settings **
	filter {"system:windows", "configurations:Debug", "platforms:Win64"}
		symbols "On"
		
			-- Specifies the library search paths for the linker (Link libraries, frameworks, or sibling projects)
	libdirs
	{
	-- SDL Win32 Lib Directory
	"Vendor/SDL2/lib/x86",
	"Vendor/SDL2Image/lib/x86",
	"Vendor/SDL2ttf/lib/x86",
	"Vendor/SDL2mixer/lib/x86",
	"Vendor/imgui/bin/Debug-x86_x64/ImGui",
	}
	
	defines 
	{
		"_Debug",
	}
	
	-- Copies the .dll files to the appropiate Win64 Debug directory
	postbuildcommands
	{
		-- SDL Win64 Debug .dll locations to copy from and to the correct directory
		"copy $(SolutionDir)Vendor\\SDL2\\lib\\x64\\SDL2.dll 			$(SolutionDir)bin\\".._proj.name.."\\Debug\\Win64\\SDL2.dll",
		"copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x64\\SDL2_image.dll $(SolutionDir)bin\\".._proj.name.."\\Debug\\Win64\\SDL2_image.dll",
		"copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x64\\SDL2_ttf.dll 	$(SolutionDir)bin\\".._proj.name.."\\Debug\\Win64\\SDL2_ttf.dll",
		"copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x64\\SDL2_mixer.dll $(SolutionDir)bin\\".._proj.name.."\\Debug\\Win64\\SDL2_mixer.dll",
		
		-- Texture .png Example
		"copy $(SolutionDir)Assets\\Textures\\house.png 				$(SolutionDir)bin\\".._proj.name.."\\Debug\\Win64\\house.png",
	}
	
	
	------------------------------------------------------------
	--------------****Win64 Release Settings****----------------
	------------------------------------------------------------

	filter {"system:windows", "configurations:Release", "platforms:Win64"}
		-- Release should be optimized
		optimize "On"	

	libdirs
	{
	-- SDL Win64 Lib directories
	"Vendor/SDL2/lib/x64",
	"Vendor/SDL2Image/lib/x64",
	"Vendor/SDL2ttf/lib/x64",
	"Vendor/SDL2mixer/lib/x64",
	"Vendor/imgui/bin/Release-x86_x64/ImGui",
	}

	defines 
	{
		"Release",
	}

	-- Copies the .dll files to the appropiate Win64 Release directory
	postbuildcommands
	{
		-- SDL Win64 Release .dll locations to copy from and to the correct directory
		"copy $(SolutionDir)Vendor\\SDL2\\lib\\x64\\SDL2.dll 			$(SolutionDir)bin\\".._proj.name.."\\Release\\Win64\\SDL2.dll",
		"copy $(SolutionDir)Vendor\\SDL2Image\\lib\\x64\\SDL2_image.dll $(SolutionDir)bin\\".._proj.name.."\\Release\\Win64\\SDL2_image.dll",
		"copy $(SolutionDir)Vendor\\SDL2ttf\\lib\\x64\\SDL2_ttf.dll 	$(SolutionDir)bin\\".._proj.name.."\\Release\\Win64\\SDL2_ttf.dll",
		"copy $(SolutionDir)Vendor\\SDL2Mixer\\lib\\x64\\SDL2_mixer.dll $(SolutionDir)bin\\".._proj.name.."\\Release\\Win64\\SDL2_mixer.dll",
		-- Texture .png Example
		"copy $(SolutionDir)Assets\\Textures\\house.png 				$(SolutionDir)bin\\".._proj.name.."\\Release\\Win64\\house.png",
	}
	------------------------------------------------------------
	
	--[[ ADDING AN ADDITIONAL PROJECT Example
	project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"vendor/spdlog/include",
		"src",
		"vendor",
		"%{IncludeDir.glm}"
	}

	links
	{
		"StaticProject"
	}

	filter "system:windows"
		systemversion "latest"

		defines
		{
			
		}

	filter "configurations:Debug"
		defines "_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "_DIST"
		runtime "Release"
		optimize "on"
	--]]