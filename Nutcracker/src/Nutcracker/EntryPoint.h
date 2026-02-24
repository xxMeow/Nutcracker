#pragma once

#ifdef NC_PLATFORM_WINDOWS

extern Nutcracker::Application* Nutcracker::CreateApplication();

int main(int argc, char** argv)
{
    Nutcracker::Log::Init();

    NC_CORE_WARN("Initialized Core Log!");
    int a = 5;
    NC_INFO("Hello! Var={0}", a);

    auto app = Nutcracker::CreateApplication();
    app->Run();
    delete app;
}

#endif
