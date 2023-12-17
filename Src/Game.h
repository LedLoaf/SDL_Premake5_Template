#pragma once
#include "Timer.h"

#include <SDL.h>
#include <SDL_main.h>
#include <SDL_image.h>
#include <SDL_ttf.h>

#include "imgui.h"
#include "imgui_sdl.h"

#include <iostream>
#include <string>

constexpr int SCREEN_WIDTH = 1280;                                      // Window Width
constexpr int SCREEN_HEIGHT = 720;                                      // Window Height
constexpr int SCREEN_FPS = 60;                                          // Target Frames Per Second
constexpr int SCREEN_TICKS_PER_FRAME = 1000 / SCREEN_FPS;               // Ticks per frame

const std::string texturePath = "../Assets/Textures/house.png";         // Example Texture path

class Game
{
public:
    // Initializes all SDL systems and other objects
    int Initialize()
    {
        auto isSuccess = true;

        // Initializing SDL2
        if (SDL_Init(SDL_INIT_VIDEO) == -1)
        {
            SDL_Log("SDL_Init(SDL_INIT_VIDEO) failed: %s", SDL_GetError());
            isSuccess = false;
        }

        // Initializing SDL_Image to be able to load .png files
        constexpr auto imgFlags = IMG_INIT_PNG;
        if (!(IMG_Init(imgFlags) & imgFlags))
        {
            SDL_Log("SDL_image could not initialize! SDL_image Error: %s\n", IMG_GetError());
            isSuccess = false;
        }

        // Initializing TTF_Font to use fonts.
        if (!TTF_Init() == 0)
        {
            SDL_Log("SDL_TTF could not initialize! SDL_TTF Error: %s\n", TTF_GetError());
            isSuccess = false;
        }

        // Set texture filtering to linear
        if (!SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1")) { SDL_Log("Warning: Linear texture filtering not enabled!"); }

        // Initialzing the SDL Window
        m_Window = SDL_CreateWindow("Hello SDL", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
        if (!m_Window)
        {
            SDL_Log("SDL_CreateWindow() failed: %s", SDL_GetError());
            isSuccess = false;
        }

        // Initializing the SDL Renderer.
        m_Renderer = SDL_CreateRenderer(m_Window, -1, SDL_RENDERER_ACCELERATED);
        if (!m_Renderer)
        {
            SDL_Log("SDL_CreateRenderer() failed: %s", SDL_GetError());
            isSuccess = false;
        }

        // Initialize the font from default windows location
        m_Font = TTF_OpenFont("C:/Windows/Fonts/Arial.ttf", 25);
        if (!m_Font)
        {
            SDL_Log("SDL_CreateRenderer() failed to create font: %s", SDL_GetError());
            isSuccess = false;
        }

        // Initialize ImGui
        ImGui::CreateContext();
        ImGuiSDL::Initialize(m_Renderer, SCREEN_WIDTH, SCREEN_HEIGHT);     // Create the size the size of the window


        /* Open the image file */
        m_Texture = IMG_LoadTexture(m_Renderer, texturePath.c_str());
        if (!m_Texture)
        {
            SDL_Log("Couldn't load texture: \n", SDL_GetError());
            isSuccess = false;
        }

        /* -1000 so it's offscreen at start */
        m_MousePosRect.x = m_MousePosRect.y = -1000;
        m_MousePosRect.w = m_MousePosRect.h = 96;

        // Start counting frames per second
        m_FPSTimer.Start();

        return isSuccess;
    }

    // Process the SDL_Event input
    void ProcessInput()
    {
        // ImGui input
        ImGuiIO& io = ImGui::GetIO();

        SDL_Event event;
        while (SDL_PollEvent(&event))
        {
            switch (event.type)
            {
            case SDL_QUIT:
                m_IsRunning = SDL_FALSE;
                break;

            case SDL_KEYDOWN:
                if (event.key.keysym.sym == SDLK_ESCAPE)
                    m_IsRunning = SDL_FALSE;
                break;

            case SDL_MOUSEMOTION:
                m_MousePosRect.x = event.motion.x - (m_MousePosRect.w / 2);
                m_MousePosRect.y = event.motion.y - (m_MousePosRect.h / 2);
                break;

            case SDL_MOUSEWHEEL:
                {
                    if (event.wheel.y == 1)				// Scroll Up
                    {
                        m_MousePosRect.w += 5;
                        m_MousePosRect.h += 5;
                    }
                    else if (event.wheel.y == -1)		// Scroll down
                    {
                        m_MousePosRect.w -= 5;
                        m_MousePosRect.h -= 5;
                    }
                }
                break;

            default: break;
            }
        }

        // Retrieves the mouse positions
        int mouseX, mouseY;
        const int buttons = SDL_GetMouseState(&mouseX, &mouseY);

        // Setup low-level inputs (e.g. on Win32, GetKeyboardState(), or write to those fields from your Windows message loop handlers, etc.)
        io.DeltaTime = 1.0f / 60.0f;
        io.MousePos = ImVec2(static_cast<float>(mouseX), static_cast<float>(mouseY));
        io.MouseDown[0] = buttons & SDL_BUTTON(SDL_BUTTON_LEFT);
        io.MouseDown[1] = buttons & SDL_BUTTON(SDL_BUTTON_RIGHT);
        io.MouseWheel = static_cast<float>(event.wheel.y);
    }

    // Update the delta time (Note: You can combine the 'Update' and the 'Renderer' functions, I like them separate)
    void Update()
    {
        // Calculate and correct fps
        float avgFPS = m_CountedFrames / (m_FPSTimer.GetTicks() / 1000.f);
        if (avgFPS > 2000000) { avgFPS = 0; }

        // If you need delta time.
        static float dt = 0;
        dt += m_CapTimer.GetStartTicks();

        // Hack way to remove the amount of zeros with the FPS.
        if (dt >= 20)
        {
            m_FPSText = std::to_string(avgFPS);
            m_FPSText.pop_back();
            m_FPSText.pop_back();
            m_FPSText.pop_back();
            m_FPSText.pop_back();
            dt = 0;
        }
    }
    void Render()
    {
        // Begin a new ImGui frame
        ImGui::NewFrame();
        // For demonstration purposes and can be turned on/off or removed
        ImGui::ShowDemoWindow();

        // The ImGui window and the image being placed.
        ImGui::Begin("Image");
        ImGui::Image(m_Texture, ImVec2(100, 100));
        ImGui::End();


        /* Fade between shades of red every 3 seconds, from 0 to 255. */
        auto r = static_cast<Uint8>((static_cast<float>(SDL_GetTicks() % 6000) / 6000.0f) * 255.0f);

        // Set screen color
        SDL_SetRenderDrawColor(m_Renderer, r, 0, 0, 255);
        // Clear screen
        SDL_RenderClear(m_Renderer);
        // Reset draw color
        SDL_SetRenderDrawColor(m_Renderer, 255, 255, 255, 255);

        // Draw the rectangle at the mouse position.
        SDL_RenderFillRect(m_Renderer, &m_MousePosRect);

        // Draw the texture at the mouse position.
        SDL_RenderCopy(m_Renderer, m_Texture, nullptr, &m_MousePosRect);


        // Set the different red, green, blue shades for the text.
        r = static_cast<Uint8>((static_cast<float>(SDL_GetTicks() % 6000) / 6000.0f) * 255.0f);
        const auto g = static_cast<Uint8>((static_cast<float>(SDL_GetTicks() % 3000) / 3000.0f) * 255.0f);
        const auto b = static_cast<Uint8>((static_cast<float>(SDL_GetTicks() % 9000) / 9000.0f) * 255.0f);
        m_FontColor.r = r;
        m_FontColor.g = g;
        m_FontColor.b = b;

        // Text to display
        const std::string msg = "SDL_Premake5 Template";


        // Creating Dynamic Text
        constexpr SDL_Rect textRect{1280 / 2 - 300,720 / 2 - 300,600,100};           // Middle of the screen
        SDL_Surface* surface = TTF_RenderText_Solid(m_Font, msg.c_str(),m_FontColor);       // Creates a font surface with the font so it can be drawn
        m_Text = SDL_CreateTextureFromSurface( m_Renderer, surface);                             // Create the texture from the surface
        SDL_FreeSurface(surface);                                                                // Destroy the surface, since it's no longer needed
        SDL_RenderCopy(m_Renderer, m_Text, nullptr, &textRect);                   // Drawing the TTF font texture

        // Creating Dynamic Text
        constexpr SDL_Rect fpsRect{ 1280 - 150,0,100,50 };                          // Top right corner slightly to the left to have room.
        SDL_Surface* surface2 = TTF_RenderText_Solid(m_Font, m_FPSText.c_str(), m_FPSColor);
        m_FPSTexture = SDL_CreateTextureFromSurface(m_Renderer, surface2);
        SDL_FreeSurface(surface2);
        SDL_RenderCopy(m_Renderer, m_FPSTexture, nullptr, &fpsRect);             // Drawing the TTF font texture


        // ImGui Render
        ImGui::Render();
        ImGuiSDL::Render(ImGui::GetDrawData());


        // Present screen image
        SDL_RenderPresent(m_Renderer);

        ++m_CountedFrames;
        // If frame finished early
        const int frameTicks = m_CapTimer.GetTicks();
        if (frameTicks < SCREEN_TICKS_PER_FRAME)
        {
            // Wait remaining time
            SDL_Delay(SCREEN_TICKS_PER_FRAME - frameTicks);
        }

    }

    void Shutdown() const
    {
        // Uninitialized SDL ImGui backend
        ImGuiSDL::Deinitialize();

        // Uninitialized the ImGui context
        ImGui::DestroyContext();

        // Uninitialized the example texture and text
        SDL_DestroyTexture(m_Texture);
        SDL_DestroyTexture(m_Text);

        // Uninitialized TTF_Fonts
        TTF_CloseFont(m_Font);
        // Uninitialized the SDL_Renderer and SDL_Window
        SDL_DestroyRenderer(m_Renderer);
        SDL_DestroyWindow(m_Window);

        // Shut down TTF_Fonts, SDL_image, and finally, SDL2
        TTF_Quit();
        IMG_Quit();
        SDL_Quit();
    }

    void Run()
    {
        // Initialize everything
        if (!Initialize())
        {
            SDL_Log("Failed to initialize");
            return;
        }

        // Run until m_IsRunning = false
        m_IsRunning = SDL_TRUE;
        while (m_IsRunning)
        {
            // Start cap timer
            m_CapTimer.Start();

            ProcessInput();
            Update();
            Render();
        }
        Shutdown();     // Cleanup
    }

private:
    SDL_Window* m_Window = nullptr;
    SDL_Renderer* m_Renderer = nullptr;

    SDL_Texture* m_Texture = nullptr;
    SDL_Texture* m_FPSTexture = nullptr;
    SDL_Texture* m_Text = nullptr;

    TTF_Font* m_Font = nullptr;

    Timer m_FPSTimer;                                   // The frames per second timer
    Timer m_CapTimer;                                   // The frames per second cap timer
    SDL_bool m_IsRunning = SDL_TRUE;                    // Used to shut down the program

    SDL_Color m_FontColor = {255,255,255};    // The text displayed color
    SDL_Color m_FPSColor = {255,255,255};     // The FPS text displayed color

private:
    SDL_Rect m_MousePosRect{0,0,0,0};      // Mouse Rect to keep track of the location
    int m_CountedFrames = 0;                           // Start counting frames per second
    std::string m_FPSText{};                           // FPS text to display
};