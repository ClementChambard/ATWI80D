#include "Tile.h"
#include "Chip.h"

#include <NSEngine.h>
#include <math/Random.h>

#include <glm/gtx/euler_angles.hpp>

int Tile::tileLayer = 0;

void Tile::Init(int i)
{
    ID = i;
}

void Tile::Init()
{
    if (myAnmScr) { myAnmScr->destroy(); myAnmScr = nullptr; }
    if (!empty)
    {
        myAnmScr = AnmManager::anim(AnmManager::newAnim(Tile::TileAnm));
        myAnmScr->visible(false);
    }
}

void Tile::Init(int tex, float xStart, float yStart, bool empty)
{
    this->empty = empty;
    TexID = tex;
    int xx = ID%11;
    int yy = ID/11;
    x = xStart + xx * 44 + 22;
    y = yStart - yy * 44 - 22;
    u1 = xx/11.f; u2 = u1 + 1/11.f;
    v1 = yy/11.f; v2 = v1 + 1/11.f;
    Init();
}

void Tile::Cleanup()
{
    if (myAnmScr) myAnmScr->destroy(); myAnmScr = nullptr;
    if (myChip) delete myChip; myChip = nullptr;
}

void Tile::AssignChip(Chip *c)
{
    myChip = c;
    c->SetDesiredX(x);
    c->SetDesiredY(y);
    c->t = this;
}

void Tile::MoveChipDown(int amount)
{
    Chip* c = myChip; myChip = nullptr;
    if (c == nullptr) return;
    Tile* t = this;
    for (int i = 0; i < amount; i++)
    {
        if (t->tileBelow) t = t->tileBelow;
        if (t->empty) i--;
    }
    t->AssignChip(c);
}

void Tile::Lined(std::vector<std::vector<Chip*>>& ToDestroy) const
{
    // do that recursively
    std::vector<Chip*> out;
    if (empty || !myChip || myChip->color == -1) return;
    int c = myChip->color;
    std::vector<Chip*> h;
    std::vector<Chip*> v;
    Tile* t = tileLeft;
    while (true)
    {
        if (!t || t->empty || !t->myChip || t->myChip->color != c) break;
        h.push_back(t->myChip);
        t = t->tileLeft;
    } t = tileRight;
    while (true)
    {
        if (!t || t->empty || !t->myChip || t->myChip->color != c) break;
        h.push_back(t->myChip);
        t = t->tileRight;
    } t = tileAbove;
    while (true)
    {
        if (!t || t->empty || !t->myChip || t->myChip->color != c) break;
        v.push_back(t->myChip);
        t = t->tileAbove;
    } t = tileBelow;
    while (true)
    {
        if (!t || t->empty || !t->myChip || t->myChip->color != c) break;
        v.push_back(t->myChip);
        t = t->tileBelow;
    }
    if (h.size()>=2) for (auto c : h) out.push_back(c);
    if (v.size()>=2) for (auto c : v) out.push_back(c);
    if (out.size()==0) return;
    out.push_back(myChip);
    ToDestroy.push_back(out);
}

void Tile::Update()
{
    static bool h = false;
    if (empty) return;
    if (myChip)
    {
        bool a = (x - 22 < Inputs::Mouse().pos.x &&
            x + 22 > Inputs::Mouse().pos.x &&
            y - 22 < Inputs::Mouse().pos.y &&
            y + 22 > Inputs::Mouse().pos.y);
        if (a && !h) myChip->interrupt(4);
        h = a;
        myChip->Update();
    }

    myAnmScr->Update(1.f);
}

void Tile::Draw()
{
    if (empty) return;
    hovered = (x - 22 < Inputs::Mouse().pos.x &&
        x + 22 > Inputs::Mouse().pos.x &&
        y - 22 < Inputs::Mouse().pos.y &&
        y + 22 > Inputs::Mouse().pos.y);
    glm::vec3 pos {
        myAnmScr->x_() + x,
        myAnmScr->y_() + y,
        myAnmScr->z_()
    };
    glm::vec3 rot {
        myAnmScr->rx_(),
        myAnmScr->ry_(),
        myAnmScr->rz_()
    };
    uint8_t a = myAnmScr->ca_();
    uint8_t c = hovered ? 192 : 255;
    glm::mat4 rotate = glm::eulerAngleYXZ(rot.y, rot.x, rot.z);
    NSEngine::engineData::layers[tileLayer]->getBatch()->draw(TexID,
        {{glm::vec3(rotate * glm::vec4(-22, 22,0,1)) + pos}, {c,c,c,a},{u1,v1}},
        {{glm::vec3(rotate * glm::vec4( 22, 22,0,1)) + pos}, {c,c,c,a},{u2,v1}},
        {{glm::vec3(rotate * glm::vec4( 22,-22,0,1)) + pos}, {c,c,c,a},{u2,v2}},
        {{glm::vec3(rotate * glm::vec4(-22,-22,0,1)) + pos}, {c,c,c,a},{u1,v2}});
}

void Tile::TileAnm(AnimScript *anm)
{
    if (anm->frame == 0)
    {
        anm->set_alpha(0);
        anm->alpha_time(80, 0, 255);
        anm->set_rot(-PI1_2, -PI1_2, -PI);
        anm->rot_time(80, 0, 0, 0, 0);
    } else anm->frame = 0;
}
