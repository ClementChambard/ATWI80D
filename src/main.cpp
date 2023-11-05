#define SDL_MAIN_HANDLED

#include "Game.h"

Game *game = nullptr;

int main(int argc, const char * argv[])
{
    game = new Game();

    game->INIT();
    game->GAMELOOP();
    game->CLEAN();

    return 0;
}
