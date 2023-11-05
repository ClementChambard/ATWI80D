#ifndef GAME
#define GAME

#include <iostream>
#include <math.h>

#include <NSEngine.h>

class Game {

public:

    Game();
    ~Game();

    void INIT();
    void GAMELOOP();
    void CLEAN();

private:
    NSEngine::Window window;

};

#endif
