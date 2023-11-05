#ifndef LEVEL_H_
#define LEVEL_H_

#include "Chip.h"
#include "Tile.h"

class Level {

    public:
        void Init();
        void Draw();
        void Update();
        void Cleanup();

    private:

        enum State {
            SELECT,
            IN_SELECTION,
            PLAYER_MOVEMENT,
            BOARD_CHECKING,
            BOARD_FALLING
        } state;
        int stateframe = 0;

        void _update_select();
        void _update_inSelection();
        void _update_playerMovement();
        void _update_boardChecking();
        void _update_boardFalling();

        int texIDBG = 0;
        int texIDCorners = 0;

        char* cases;

        static std::vector<std::vector<Tile>> tileBoard;

        Chip* selectedChip;
        Chip* swapChip;
        Chip* _getChipByPos(float x, float y);

        void _doShineAnim(bool start = false);

        static constexpr float OX = 100;
        static constexpr float OY = 0;
        static constexpr float GRIDSIZE = 44;
        static constexpr unsigned int CHIPSPERROWS = 11;
        static constexpr unsigned int TOTALCHIPS = 121;
};


#endif // LEVEL_H_
