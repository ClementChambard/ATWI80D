#include "Chip.h"
#include <math/Random.h>
#include <AnmManager.h>
#include "AnmChips.h"

Chip::Chip(int type)
{
    this->color = type < 12 ? type : -1; //floor(Random::Float01()*4.9);
    anmID = AnmChipGen(type);
}


Chip::~Chip()
{
    if (anmID != -1) AnmManager::interrupt(anmID, 1);
}

void Chip::Update()
{
    timer++;

    if (x > desiredX)
    {
        xspd -= accel;
        if (xspd < -spdMax) xspd = -spdMax;
        x += xspd;
        if (x <= desiredX) { x = desiredX; xspd = 0; }
    }
    if (x < desiredX)
    {
        xspd += accel;
        if (xspd > spdMax) xspd = spdMax;
        x += xspd;
        if (x >= desiredX) { x = desiredX; xspd = 0; }
    }
    if (y > desiredY)
    {
        yspd -= accel;
        if (yspd < -spdMax) yspd = -spdMax;
        y += yspd;
        if (y <= desiredY) { y = desiredY; yspd = 0; AnmManager::interrupt(anmID, 6); }
    }
    if (y < desiredY)
    {
        yspd += accel;
        if (yspd > spdMax) yspd = spdMax;
        y += yspd;
        if (y >= desiredY) { y = desiredY; yspd = 0; }
    }

    AnmManager::UpdateChild(anmID, x, y, 0, 0, 0, 0, 1, 1, true);
}

bool Chip::IsMoving() { return y != desiredY || x != desiredX || timer < 35; }
void Chip::SetDesiredX(float x) { desiredX = x; if (this->x == NOTPLACED) this->x = x; }
void Chip::SetDesiredY(float y) { desiredY = y; if (this->y == NOTPLACED) this->y = y; }
void Chip::interrupt(int i) { AnmManager::interrupt(anmID, i); }
void Chip::GetPos(float &x, float &y) { x = this->x; y = this->y; }
int  Chip::GetColor() { return color; }
