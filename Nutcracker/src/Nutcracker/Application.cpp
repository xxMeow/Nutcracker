#include "Application.h"

#include "Nutcracker/Events/ApplicationEvent.h"
#include "Nutcracker/Log.h"

namespace Nutcracker
{
    Application::Application()
    {
    }

    Application::~Application()
    {
    }

    void Application::Run()
    {
        WindowResizeEvent e(1280, 720);
        NC_TRACE(e);

        while (true);
    }
}
