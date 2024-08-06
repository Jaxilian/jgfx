local function set_options()
    newoption {
        trigger = "directx11",
        description = "Include DirectX 11 specific settings"
    }
    
    newoption {
        trigger = "directx12",
        description = "Include DirectX 12 specific settings"
    }
    
    newoption {
        trigger = "vulkan",
        description = "Include Vulkan specific settings"
    }
    
    newoption {
        trigger = "opengl",
        description = "Include OpenGL specific settings"
    }
end

local function set_workspace()
    workspace "jgfx"
    configurations { "Debug", "Release" }
    language "C"
    cdialect "C99"
    flags { "FatalWarnings" }
    startproject("test")
    architecture "x86_64"

    local has_option = false
    if _OPTIONS["directx11"] then
        defines { "_DIRECTX11" }
        has_option = true
    end

    if _OPTIONS["directx12"] then
        defines { "_DIRECTX12" }
        has_option = true
    end

    if _OPTIONS["vulkan"] then
        defines { "_VULKAN" }
        has_option = true
    end

    if _OPTIONS["opengl"] then
        defines { "_OPENGL" }
        has_option = true
    end

    if not  has_option then
        print("[ warning ] no rendering option set! using --opengl")
        defines { "_OPENGL" }
    end

    filter { "system:windows" }
        defines { "_WIN32" }
    filter { "system:linux" }
        defines { "_LINUX", "_UNIX" }
    filter { "system:macosx" }
        defines { "_MACOSX", "_UNIX" }

    filter { "action:gmake*" }
        buildoptions { "-march=native" }
        linkoptions { "-march=native" }

    filter { "action:vs*" }
        defines { "VISUAL_STUDIO", "_WIN32", "_WIN64" }
        buildoptions { "/GR-", "/wd4996", "/wd4006", "/wd4099", "/arch:AVX2" }
        disablewarnings { "4996", "4006", "4099" }
      

    filter { "configurations:debug" }
        symbols "On"
        defines { "_DEBUG" }

    filter { "configurations:release" }
        flags {
            "LinkTimeOptimization",
            "MultiProcessorCompile",
            "FatalWarnings",
            "NoMinimalRebuild",
            "NoBufferSecurityCheck",
            "NoIncrementalLink"
        }

        optimize "Full"
        symbols "Off"
        defines { "_NDEBUG", "_RELEASE" }

        if os.target() == "windows" then
            buildoptions { "/O2", "/arch:AVX2", "/GL", "/wd4996" }
            linkoptions { "/LTCG" }
        else
            buildoptions {
                "-fno-rtti",
                "-O2",
                "-march=native",
                "-Wall",
                "-Wextra",
                "-Werror",
                "-flto"
            }
            linkoptions { "-flto" }
        end
end

local function set_project(name, is_test)
    project(name)
    location(name)
    objdir(name .. "/obj/%{cfg.buildcfg}")
    targetdir(name .. "/bin/%{cfg.buildcfg}")
    debugdir(name .. "/bin/%{cfg.buildcfg}")
    includedirs { name .. "/src/" }

    files {
        name .. "/src/**.h",
        name .. "/src/**.c"
    }

    if is_test then
        kind "ConsoleApp"
        links({"jgfx", "glfw3"})
        libdirs{name .. "/ven/glfw/lib/"}
        includedirs { "jgfx/src/", name .. "/ven/glfw/include/"}
        ignoredefaultlibraries { "MSVCRT" }
    else
        kind "StaticLib"
    end


end

print(os.target())
set_options()
set_workspace()
set_project("jgfx")
set_project("test", true)