#ifndef CHIP_H_
#define CHIP_H_

class Tile;

enum ChipType {
    Normal,
    Piece,
    Rock,
    Wall
};

class Chip {

    public:
        Chip(int type);
        ~Chip();

        void Update();
        bool IsMoving();
        void SetDesiredX(float x);
        void SetDesiredY(float y);

        void interrupt(int i);

        int GetColor();
        void GetPos(float &x, float &y);
    private:

        int timer = 0;
        int anmID = -1;
        int color = -1;

        float x = NOTPLACED;
        float y = NOTPLACED;
        float yspd = 0;
        float xspd = 0;
        float desiredX = 0;
        float desiredY = 0;

        Tile* t = nullptr;
        const float accel = 0.2;
        const float spdMax = 10;

        static constexpr float NOTPLACED = -9999;

        friend class Level;
        friend class Tile;
};

#endif // CHIP_H_
