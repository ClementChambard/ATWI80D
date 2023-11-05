#include "Game.h"

#include <ATWI80DConfig.h>
#include <Assets.h>
#include <LoadingScreen.h>
#include "Anm.h"

//constructor + destructor
Game::Game(){}
Game::~Game(){}

/*    Around the world in 80 days     */

//init all game objects here
void Game::INIT()
{

    NSEngine::Init();

    int windowWidth = 800;
    int windowHeight = 600;

    window.Init("Autour du monde en 80 jours",windowWidth,windowHeight, 0);

    NSEngine::LoadingScreen::Load([&](){

        NSEngine::Subsystems();
        NSEngine::setMaxFps(60);
        NSEngine::createCamera(NS_CAM_3D, windowWidth, windowHeight);
        NSEngine::activeCamera3D()->setDebugSpeed(1.4f, 0.006f);
        glm::vec3 pos = NSEngine::activeCamera3D()->getPosition();
        NSEngine::activeCamera3D()->setPosition(pos.x, pos.y, pos.z*2);
        NSEngine::addGameLayer(NSEngine::GLT_SPRITES, false);
        NSEngine::EndInit();
        AnmManager::Init();
        AnmInitAll();
        NSEngine::setPrSep("");
        NSEngine::pr("Launching ATWI80D version ", ATWI80D_VERSION_MAJOR, "." , ATWI80D_VERSION_MINOR);

    }, NSEngine::blackLoadScreen);
}
#include "Level.h"
// game loop
void Game::GAMELOOP()
{
    int a = 1;
    int i = 0;
    Level l; l.Init();

    while(NSEngine::IsRunning())
    {

        NSEngine::StartFrame();

        NSEngine::StartUpdate();
        if (Inputs::Keyboard().Pressed(NSK_f10)) window.nextDisplaymode();
        if (NSEngine::IsFBF() && !Inputs::Keyboard().Pressed(NSK_backspace) && !Inputs::Keyboard().Down(NSK_equals)) continue;

        if (Inputs::Keyboard().Pressed(NSK_2)) AnmManager::interrupt(a, 2);
        if (Inputs::Keyboard().Pressed(NSK_3)) AnmManager::interrupt(a, 3);
        if (Inputs::Keyboard().Pressed(NSK_4)) AnmManager::interrupt(a, 4);
        if (Inputs::Keyboard().Pressed(NSK_5)) AnmManager::anim(a)->offset_sprite(72);
        if (Inputs::Keyboard().Pressed(NSK_6)) AnmManager::anim(a)->offset_sprite(-72);

        NSEngine::UpdateEngine();
        l.Update();
        NSEngine::EndUpdate();

        window.InitDrawing();

        NSEngine::RenderEngine();
        l.Draw();

        window.EndDrawing();

        NSEngine::EndFrame();
    }
}


void Game::CLEAN()
{
    window.destroy();
    NSEngine::Quit();
}
