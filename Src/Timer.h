#pragma once
#include <SDL_timer.h>

class Timer
{
public:
    Timer()
	:   m_StartTicks{0},
		m_PausedTicks{0},
        m_Paused{false},
		m_Started{false}
    {

    }

    //The various clock actions
    void Start()
    {
        //Start the timer
        m_Started = true;

        //Unpause the timer
        m_Paused = false;

        //Get the current clock time
        m_StartTicks = SDL_GetTicks();
        m_PausedTicks = 0;
    }

    void Stop()
    {
        //Stop the timer
        m_Started = false;

        //Unpause the timer
        m_Paused = false;

        //Clear tick variables
        m_StartTicks = 0;
        m_PausedTicks = 0;
    }

    void Pause()
    {
        //If the timer is running and isn't already paused
        if (m_Started && !m_Paused)
        {
            //Pause the timer
            m_Paused = true;

            //Calculate the paused ticks
            m_PausedTicks = SDL_GetTicks() - m_StartTicks;
            m_StartTicks = 0;
        }
    }

    void Unpause()
    {
        //If the timer is running and paused
        if (m_Started && m_Paused)
        {
            //Unpause the timer
            m_Paused = false;

            //Reset the starting ticks
            m_StartTicks = SDL_GetTicks() - m_PausedTicks;

            //Reset the paused ticks
            m_PausedTicks = 0;
        }
    }

    //Gets the timer's time
    [[nodiscard]] Uint32 GetTicks() const
    {
        //The actual timer time
        Uint32 time = 0;

        // If the timer is running
        if (m_Started)
        {
            // If the timer is paused
            if (m_Paused)
            {
                // Return the number of ticks when the timer was paused
                time = m_PausedTicks;
            }
            else
            {
                // Return the current time minus the start time
                time = SDL_GetTicks() - m_StartTicks;
            }
        }

        return time;
    }

    [[nodiscard]] Uint32 GetStartTicks()
    {
        return SDL_GetTicks() - m_StartTicks;
    }

    // Checks the status of the timer

    [[nodiscard]] bool IsStarted() const
    {
        // Timer is running and paused or un-paused
        return m_Started;
    }

    [[nodiscard]] bool IsPaused() const
    {
        // Timer is running and paused
        return m_Paused && m_Started;
    }

private:
    // The clock time when the timer started
    Uint32 m_StartTicks;

    // The ticks stored when the timer was paused
    Uint32 m_PausedTicks;

    // The timer status
    bool m_Paused;
    bool m_Started;
};
