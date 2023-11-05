#ifndef TILE_H_
#define TILE_H_

#include <AnmManager.h>

class Chip;

class Tile {

    public:
        void Init(int i);
        void Init();
        void Init(int tex, float x, float y, bool empty);
        void Cleanup();

        void MoveChipDown(int amount);
        void AssignChip(Chip* c);

        void Lined(std::vector<std::vector<Chip*>>& ToDestroy) const;

        void Draw();
        void Update();

        Chip* getChip() const { return myChip; }

        static void TileAnm(AnimScript* anm);

    private:
        int ID = 0;
        bool empty = true;
        bool hovered;

        float u1 = 0.f;
        float v1 = 0.f;
        float u2 = 0.f;
        float v2 = 0.f;
        int TexID = 0;

        float x = 0.f, y = 0.f;

        static int tileLayer;

        AnimScript* myAnmScr = nullptr;

        Chip* myChip    = nullptr;
        Tile* tileAbove = nullptr;
        Tile* tileBelow = nullptr;
        Tile* tileLeft  = nullptr;
        Tile* tileRight = nullptr;

        static constexpr float SIZE = 44;

        friend class Chip;
        friend class Level;
};


#endif // TILE_H_
