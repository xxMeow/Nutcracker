workspace "Nutcracker"
    architecture "x64"
    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }
    outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

    filter { "system:windows", "toolset:msc*" } -- msc*可以匹配VisualStudio所使用的MSVC编译器
    buildoptions
    {
        "/utf-8" -- 启用utf-8编码，兼容中文注释
    }
    filter {} -- 重置filter

    -- Include directories releative to root folder (solution directory)
    IncludeDir = {}
    IncludeDir["GLFW"] = "Nutcracker/vendor/GLFW/include"
    include "Nutcracker/vendor/GLFW"
    filter {} -- 重置GLFW的premake文件遗留的filter


project "GLFW"
    staticruntime "On" -- Cherno的GLFW仓库中, 此项在后来的更新中被设置为了Off, 与本项目不匹配, 需要改回来


project "Nutcracker"
    location "Nutcracker"
    kind "SharedLib"
    language "C++"
    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
    pchheader "ncpch.h"
    pchsource "Nutcracker/src/ncpch.cpp"
    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }
    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}"
    }
    links
    {
        "GLFW",
        "opengl32.lib"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"
        defines
        {
            "NC_PLATFORM_WINDOWS",
            "NC_BUILD_DLL"
        }

    filter "configurations:Debug"
        defines "NC_DEBUG"
        buildoptions "/MDd"
        symbols "On"

    filter "configurations:Release"
        defines "NC_RELEASE"
        buildoptions "/MD"
        optimize "On"

    filter "configurations:Dist"
        defines "NC_DIST"
        buildoptions "/MD"
        optimize "On"


project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }
    includedirs
    {
        "Nutcracker/vendor/spdlog/include",
        "Nutcracker/src"
    }
    links
    {
        "Nutcracker"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"
        defines
        {
            "NC_PLATFORM_WINDOWS"
        }
        postbuildcommands
        {
            -- bug：原教程中在Nutcracker的postbuild节点复制dll，此时Sandbox目录尚未被创建，无法复制
            -- bugfix: Sandbox只是运行时依赖Nutcracker，可以在postbuild阶段自己收集所需dll，此时目录一定存在
            ("{COPY} ../bin/" .. outputdir .. "/Nutcracker/Nutcracker.dll ../bin/" .. outputdir .. "/Sandbox")
        }

    filter "configurations:Debug"
        defines "NC_DEBUG"
        buildoptions "/MDd"
        symbols "On"

    filter "configurations:Release"
        defines "NC_RELEASE"
        buildoptions "/MD"
        optimize "On"

    filter "configurations:Dist"
        defines "NC_DIST"
        buildoptions "/MD"
        optimize "On"
