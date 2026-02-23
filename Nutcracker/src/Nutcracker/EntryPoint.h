#pragma once

#ifdef NC_PLATFORM_WINDOWS

extern Nutcracker::Application* Nutcracker::CreateApplication();

int main(int argc, char** argv)
{
    auto app = Nutcracker::CreateApplication();
    app->Run();
    delete app;
}

#endif
