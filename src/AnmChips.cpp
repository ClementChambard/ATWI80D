#include "AnmChips.h"

#include <string>
#include <NSEngine.h>
#include <math/Random.h>
#include <GameSprites.h>
#include <AnmManager.h>

namespace SprChips {

int sGlowC;
int sGlowB;
int sGlowT;
int sGlowN;
int sC[12][72];
int sRock;
int sLock1;
int sLock2;
int sIce1;
int sIce2;
int sWall;
int sCircle;
int sHeart;
int sTime;
int sBag;
int sCBreak[12][8];
int sLockBreak[8];
int sIceBreak[8];
int sRockBreak[8];

int layerChipsBelow;
int layerChips;
int layerChipsDecorations;
int layerChipsAbove;

int getOffset(int s, int o)
{
    int s_off = (s - sC[0][0]) % 72;
    //std::cout << "I'm at " << s << ", this is offset " << s_off << ". I want to go to offset " << o << " : Correction=" <<  o - s_off << "\n";
    return o - s_off +1;
}

};

using namespace SprChips;
bool AnmChips::isInit = false;
void AnmChips::Init()
{
    if (isInit) return;
    isInit = true;

    layerChipsBelow = NSEngine::addGameLayer(NSEngine::GLT_SPRITES);
    layerChips = NSEngine::addGameLayer(NSEngine::GLT_SPRITES);
    layerChipsDecorations = NSEngine::addGameLayer(NSEngine::GLT_SPRITES);
    layerChipsAbove = NSEngine::addGameLayer(NSEngine::GLT_SPRITES);

    int tex_BonusGlow = NSEngine::TextureManager::RegisterTexture("assets/Textures/Chips/BonusGlow.png");
    sGlowC = GS_ AddSprite(tex_BonusGlow,   0, 0, 64, 64);
    sGlowB = GS_ AddSprite(tex_BonusGlow,  64, 0, 64, 64);
    sGlowT = GS_ AddSprite(tex_BonusGlow, 128, 0, 64, 64);
    sGlowN = GS_ AddSprite(tex_BonusGlow, 192, 0, 64, 64);

    int tex_c[12];
    for (int i = 0; i < 12; i++)
    {
        std::string fileName = std::string("assets/Textures/Chips/c")+std::to_string(i+1)+std::string(".png");
        tex_c[i] = NSEngine::TextureManager::RegisterTexture(fileName.c_str());
        for (int j = 0; j < 6; j++) for (int k = 0; k < 12; k++)
        {
            sC[i][j+k*6] = GS_ AddSprite(tex_c[i], k*42, j*42, 42, 42);
        }
    }

    int tex_Chips = NSEngine::TextureManager::RegisterTexture("assets/Textures/Chips/Chips.png");
    sRock   = GS_ AddSprite(tex_Chips,   0,   0, 44, 44);
    sLock1  = GS_ AddSprite(tex_Chips,  44,   0, 44, 44);
    sLock2  = GS_ AddSprite(tex_Chips,  88,   0, 44, 44);
    sIce1   = GS_ AddSprite(tex_Chips, 132,   0, 44, 44);
    sIce2   = GS_ AddSprite(tex_Chips, 176,   0, 44, 44);
    sWall   = GS_ AddSprite(tex_Chips,   0,  44, 44, 44);
    sCircle = GS_ AddSprite(tex_Chips,  89,  89, 42, 43);
    sHeart  = GS_ AddSprite(tex_Chips, 133,  89, 42, 43);
    sTime   = GS_ AddSprite(tex_Chips, 177,  89, 43, 43);
    sBag    = GS_ AddSprite(tex_Chips,   0, 134, 42, 44);

    int tex_pieces = NSEngine::TextureManager::RegisterTexture("assets/Textures/Chips/pieces.png");
    for (int i = 0; i < 12; i++)
    {
        for (int j = 0; j < 8; j++) sCBreak[i][j] = GS_ AddSprite(tex_pieces, j*32, i*32, 32, 32);
    }
    for (int i = 0; i < 8; i++)
    {
        sLockBreak[i] = GS_ AddSprite(tex_pieces, i*32, 13*32, 32, 32);
        sIceBreak [i] = GS_ AddSprite(tex_pieces, i*32, 14*32, 32, 32);
        sRockBreak[i] = GS_ AddSprite(tex_pieces, i*32, 15*32, 32, 32);
    }
}

void AnmLifeGlow(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChipsBelow);
        anm->set_sprite(sGlowC);
        anm->set_alpha(0);
        anm->alpha_time(60, 3, 255);
        anm->set_blendmode(1);
    }
    if (anm->frame == 1 || anm->frame == 120)
    {
        anm->frame = 1;
        anm->scale_time(60, 9, 1.1, 1.1);
    }
    if (anm->frame == 60)
    {
        anm->scale_time(60, 9, .9, .9);
    }
}
void AnmLifeHeart(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChipsDecorations);
        anm->set_sprite(sHeart);
        anm->set_alpha(0);
        anm->alpha_time(60, 3, 255);
    }
    if (anm->frame == 60 || anm->frame == 80) {
        anm->scale_time(10, 4, 1.12, 1.12);
    }

    if (anm->frame == 70 || anm->frame == 90) {
        anm->scale_time(10, 1, 1, 1);
    }

    if (anm->frame == 150) anm->frame = 0;

}
void AnmLife(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChips);
        anm->set_sprite(sCircle);
        anm->set_alpha(0);
        anm->set_pos(0, 300, 0);
        //anm->pos_time(60, 1, 0, 0, 0);
        anm->move_bezier(60, 0, 0, 0, 0, 0, 0, 0, 500, 0);
        anm->alpha_time(60, 3, 255);
        anm->create_child(AnmLifeGlow);
        anm->create_child(AnmLifeHeart);
    }
    if (anm->interrupt == 6) {
        anm->move_bezier(10, 0, -100, 0, 0, 0, 0, 0, 100, 0);
    }
    if (anm->interrupt == 1) anm->destroy();
}

void AnmRock(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChips);
        anm->set_sprite(sRock);
        anm->set_alpha(0);
        anm->set_pos(0, 300, 0);
        //anm->pos_time(60, 1, 0, 0, 0);
        anm->move_bezier(60, 0, 0, 0, 0, 0, 0, 0, 500, 0);
        anm->alpha_time(60, 3, 255);
    }
    if (anm->interrupt == 6) {
        anm->move_bezier(10, 0, -100, 0, 0, 0, 0, 0, 100, 0);
    }
    if (anm->interrupt == 1) anm->destroy();
}

void AnmBagGlow(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChipsBelow);
        anm->set_sprite(sGlowB);
        anm->set_alpha(0);
        anm->alpha_time(60, 3, 255);
        anm->set_blendmode(1);
    }
    if (anm->frame == 1 || anm->frame == 120)
    {
        anm->frame = 1;
        anm->scale_time(60, 9, 1.1, 1.1);
    }
    if (anm->frame == 60)
    {
        anm->scale_time(60, 9, .9, .9);
    }
}
void AnmBag(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChips);
        anm->set_sprite(sBag);
        anm->set_alpha(0);
        anm->set_pos(0, 300, 0);
        //anm->pos_time(60, 1, 0, 0, 0);
        anm->move_bezier(60, 0, 0, 0, 0, 0, 0, 0, 500, 0);
        anm->alpha_time(60, 3, 255);
        anm->create_child(AnmBagGlow);
    }
    if (anm->interrupt == 6) {
        anm->move_bezier(10, 0, -100, 0, 0, 0, 0, 0, 100, 0);
    }
    if (anm->interrupt == 1) anm->destroy();
}

void AnmTimeGlow(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChipsBelow);
        anm->set_sprite(sGlowT);
        anm->set_alpha(0);
        anm->alpha_time(60, 3, 255);
        anm->set_blendmode(1);
    }
    if (anm->frame == 1 || anm->frame == 120)
    {
        anm->frame = 1;
        anm->scale_time(60, 9, 1.1, 1.1);
    }
    if (anm->frame == 60)
    {
        anm->scale_time(60, 9, .9, .9);
    }
}
void AnmTime(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_layer(layerChips);
        anm->set_sprite(sTime);
        anm->set_alpha(0);
        anm->set_pos(0, 300, 0);
        //anm->pos_time(60, 1, 0, 0, 0);
        anm->move_bezier(60, 0, 0, 0, 0, 0, 0, 0, 500, 0);
        anm->alpha_time(60, 3, 255);
        anm->create_child(AnmTimeGlow);
    }
    if (anm->interrupt == 1) anm->destroy();
    if (anm->interrupt == 6) {
        anm->move_bezier(10, 0, -100, 0, 0, 0, 0, 0, 100, 0);
    }
}

void AnmWall(AnimScript* anm) {
    if (anm->frame == 0)
    {
        anm->set_alpha(0);
        anm->alpha_time(60, 1, 255);
        anm->set_layer(layerChips);
        anm->set_sprite(sWall);
    }

    if (anm->interrupt == 1) anm->destroy();
}

void AnmChip(AnimScript* anm) {

    // normal 0 - 1
    if (anm->frame == 0)
    {
        anm->set_alpha(0);
        anm->set_pos(0, 300, 0);
        //anm->pos_time(60, 1, 0, 0, 0);
        anm->move_bezier(60, 0, 0, 0, 0, 0, 0, 0, 500, 0);
        anm->alpha_time(60, 3, 255);
        anm->set_layer(layerChips);
    } else if (anm->frame == 1) anm->frame = 0;

    // spin 2 - 38
    else if (anm->frame <= 38)
    {
        if (anm->frame == 38) anm->frame = 2;
        anm->offset_sprite(getOffset(anm->spr_(), anm->frame - 2));
    }

    // shine 39 - 74
    else if (anm->frame <= 74)
    {
        if (anm->frame == 74) { anm->frame = 0; anm->offset_sprite(getOffset(anm->spr_(), 0)); }
        else anm->offset_sprite(getOffset(anm->spr_(), anm->frame - 3));
    }
    if (anm->frame == 150) anm->destroy();
    if (anm->frame >75 && anm->frame < 85) anm->offset_sprite(Random::Float01()*2);

    if (anm->interrupt == 1) {
        anm->frame = 75;
        anm->offset_sprite(getOffset(anm->spr_(), 0));
        anm->set_layer(layerChipsAbove);
        anm->alpha_time(60, 0, 0);
        anm->rot_time(20, 0, 0, 0, Random::Angle()/3);
        anm->pos_time(60, 1, Random::Floatm11()*10.f, -600, 0);
    } else if (anm->interrupt == 2) {
        anm->frame = 0; anm->offset_sprite(getOffset(anm->spr_(), 0));
    } else if (anm->interrupt == 3) {
        anm->frame = 1;
    } else if (anm->interrupt == 4) {
        if (anm->frame == 0)
        anm->frame = 38;
    } else if (anm->interrupt == 5) {
        anm->destroy();
    } else if (anm->interrupt == 6) {
        anm->move_bezier(10, 0, -100, 0, 0, 0, 0, 0, 100, 0);
    }
}

//Ice and lock

int AnmChipGen(int type)
{
    int a = -1;
    if (type < 12)
    {
        a = AnmManager::newAnim(AnmChip);
        AnmManager::anim(a)->set_sprite(sC[type][0]);
    }
    else if (type == 12) a = AnmManager::newAnim(AnmLife);
    else if (type == 13) a = AnmManager::newAnim(AnmTime);
    else if (type == 14) a = AnmManager::newAnim(AnmRock);
    else if (type == 15) a = AnmManager::newAnim(AnmBag);
    else if (type == 16) a = AnmManager::newAnim(AnmWall);
    return a;
}
