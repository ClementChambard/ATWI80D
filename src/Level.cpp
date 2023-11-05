#include "Level.h"
#include "Tile.h"
#include <NSEngine.h>
#include <vector>
#include <math/Random.h>

auto GenVec(char* cases, int* a = nullptr)
{
    struct sprToDraw {
            void draw(int t, float x, float y) { NSEngine::draw_quad_tex_2d(t, {x+x1,y+y1,u1,v1}, {x+x2,y+y1,u2,v1}, {x+x2,y+y2,u2,v2}, {x+x1,y+y2,u1,v2}); }
            float x1, x2, y1, y2, u1, u2, v1, v2;
    };
    static std::vector<sprToDraw> v;
    static int alpha = 0;
    alpha += 2; if (alpha > 255) alpha = 255; if (a!=nullptr) *a = alpha;
    if (!cases) return v;
    alpha = 0;
    v.clear();
    float du = 44.f/512.f;
    float dv = 44.f/256.f;
    // draw outside
    for (int i = 0; i < 12; i++)
    {
        for (int j = 0; j < 12; j++)
        {
            sprToDraw s;
            s.x1 = 44*(j-6.f); s.x2 = s.x1+44;
            s.y1 = -44*(i-5.f); s.y2 = s.y1+44;
            char tl, tr, bl, br;
            tl = (i == 0  || j == 0 ) ? '0' : cases[(i-1)*11+(j-1)];
            tr = (i == 0  || j == 11) ? '0' : cases[(i-1)*11+(j-0)];
            bl = (i == 11 || j == 0 ) ? '0' : cases[(i-0)*11+(j-1)];
            br = (i == 11 || j == 11) ? '0' : cases[(i-0)*11+(j-0)];
            if (tl == '0' && tr == '0' && bl == '0' && br == '0') continue;
            else if (tl == '0' && tr == '0' && bl == '0') {/*tl corner*/ s.u1 = 1*du; s.v1 = 2*dv; s.u2 = 2*du; s.v2 = 1*dv;}
            else if (tl == '0' && tr == '0' && br == '0') {/*tr corner*/ s.u1 = 3*du; s.v1 = 2*dv; s.u2 = 4*du; s.v2 = 1*dv;}
            else if (bl == '0' && br == '0' && tl == '0') {/*bl corner*/ s.u1 = 1*du; s.v1 = 4*dv; s.u2 = 2*du; s.v2 = 3*dv;}
            else if (bl == '0' && br == '0' && tr == '0') {/*br corner*/ s.u1 = 3*du; s.v1 = 4*dv; s.u2 = 4*du; s.v2 = 3*dv;}
            else if (bl == '0' && br == '0') {/*b line*/ s.u1 = 2*du; s.v1 = 4*dv; s.u2 = 3*du; s.v2 = 3*dv;}
            else if (tl == '0' && tr == '0') {/*t line*/ s.u1 = 2*du; s.v1 = 2*dv; s.u2 = 3*du; s.v2 = 1*dv;}
            else if (bl == '0' && tl == '0') {/*l line*/ s.u1 = 1*du; s.v1 = 3*dv; s.u2 = 2*du; s.v2 = 2*dv;}
            else if (br == '0' && tr == '0') {/*r line*/ s.u1 = 3*du; s.v1 = 3*dv; s.u2 = 4*du; s.v2 = 2*dv;}
            else if (br == '0') {/*br anti corner*/ s.u1 = 5*du; s.v1 = 1*dv; s.u2 = 6*du; s.v2 = 0*dv;}
            else if (bl == '0') {/*bl anti corner*/ s.u1 = 6*du; s.v1 = 1*dv; s.u2 = 7*du; s.v2 = 0*dv;}
            else if (tr == '0') {/*tr anti corner*/ s.u1 = 5*du; s.v1 = 2*dv; s.u2 = 6*du; s.v2 = 1*dv;}
            else if (tl == '0') {/*tl anti corner*/ s.u1 = 6*du; s.v1 = 2*dv; s.u2 = 7*du; s.v2 = 1*dv;}
            else continue;
            v.push_back(s);
        }
    }
    return v;
}

std::vector<std::vector<Tile>> Level::tileBoard;

void Level::Init()
{
    if (tileBoard.empty())
    {
        std::vector<Tile> empty;
        for (int i = 0; i < 11; i++) tileBoard.push_back(empty);
        for (int i = 0; i < 121; i++) {
            tileBoard[i/CHIPSPERROWS].push_back(Tile());
            tileBoard[i/CHIPSPERROWS].back().Init(i);
        }
        for (int i = 0; i < 11; i++)
            for (int j = 0; j < 11; j++)
            {
                if (j !=  0) tileBoard[i][j].tileLeft  = &tileBoard[i][j-1];
                if (j != 10) tileBoard[i][j].tileRight = &tileBoard[i][j+1];
                if (i !=  0) tileBoard[i][j].tileAbove = &tileBoard[i-1][j];
                if (i != 10) tileBoard[i][j].tileBelow = &tileBoard[i+1][j];
            }
    }

    cases = new char[TOTALCHIPS] {
        '0','0','0','0','0','0','0','0','0','0','0',
        '0','0','0','0','0','0','0','0','0','0','0',
        '0','0','0','1','1','0','1','1','0','0','0',
        '0','0','0','1','1','1','1','1','0','0','0',
        '0','0','0','1','1','1','1','1','0','0','0',
        'A','0','0','S','A','S','A','S','0','0','A',
        '+','1','1','1','1','1','1','1','1','1','+',
        '+','1','1','1','1','1','1','1','1','1','+',
        '0','1','1','1','1','1','1','1','1','1','0',
        '0','0','0','0','0','0','0','0','0','0','0',
        '0','0','0','0','0','0','0','0','0','0','0',
    };
    texIDBG = NSEngine::TextureManager::RegisterTexture("assets/Textures/Fields/Substrates/Substr_7_base.png");
    texIDBG = NSEngine::TextureManager::GetTextureID(texIDBG);
    texIDCorners = NSEngine::TextureManager::RegisterTexture("assets/Textures/Fields/scope7.png");
    texIDCorners = NSEngine::TextureManager::GetTextureID(texIDCorners);

    float begx = -GRIDSIZE*5.5f+OX;
    float begy = GRIDSIZE*5.5f+OY;
    std::cout << "RESET\n";
    for (int i = 0; i < 11; i++)
        for (int j = 0; j < 11; j++)
        {
            tileBoard[i][j].Init(texIDBG, begx, begy, cases[i*11+j] == '0');
            if(cases[i*11+j] != '0') { Chip* c = new Chip(cases[i*11+j]=='S'?15:(cases[i*11+j]=='A'?12:Random::Float01()*5)); tileBoard[i][j].AssignChip(c); }
        }
    //Chip* c = new Chip(0);
    //tileBoard[3][5].AssignChip(c);

    //for (int i = 0; i < 11; i++)
    //{
        //for (int j = 0; j < 11; j++)
        //{
            //if (tileBoard[i][j].empty) std::cout << "XX";
            //else printf("%2d",tileBoard[i][j].myChip->color);
        //}
        //std::cout << "\n";
    //}

    state = State::SELECT;
    GenVec(cases);
}

void Level::Cleanup()
{
    delete[] cases; cases = nullptr;
    selectedChip = nullptr;
    swapChip = nullptr;
    for (auto l : tileBoard) for (auto t : l) { delete t.myChip; t.myChip = nullptr; };
}

Chip* Level::_getChipByPos(float x, float y)
{
    // Get X
    float xx = x-OX+CHIPSPERROWS*GRIDSIZE/2;
    if (xx<0 || xx>CHIPSPERROWS*GRIDSIZE-1) return nullptr;
    int X = ((int)xx)/(int)GRIDSIZE;
    // Get Y
    float yy = y-OY+CHIPSPERROWS*GRIDSIZE/2;
    if (yy<0 || yy>CHIPSPERROWS*GRIDSIZE-1) return nullptr;
    int Y = CHIPSPERROWS-1-((int)yy)/(int)GRIDSIZE;
    return tileBoard[Y][X].myChip;
}

void Level::_doShineAnim(bool start)
{
    static int shineAnimPos = 0;
    if (start) shineAnimPos = 1;
    if (shineAnimPos >= CHIPSPERROWS*GRIDSIZE*2-1) shineAnimPos = 0;
    if (shineAnimPos == 0) return;
    if ((shineAnimPos%(int)GRIDSIZE) == 1)
    {
        int dist = shineAnimPos/GRIDSIZE;
        for (int i = 0; i <= dist; i++)
        {
            int j = dist - i;
            if (i > 10 || j > 10) continue;
            Chip* c = tileBoard[j][i].myChip;
            if (c) c->interrupt(4);
        }
    }
    shineAnimPos+=2;
}


void Level::Draw()
{
    /* Draw Contour */{
        int alpha;
        auto v = GenVec(nullptr, &alpha);
        NSEngine::draw_set_alpha(alpha);
        for (auto s : v) s.draw(texIDCorners, OX, OY);
        NSEngine::draw_set_alpha(255);
    }
    for (auto l : tileBoard)  for (auto t : l) t.Draw();
}

void Level::Update()
{
    // Global update
    for (auto l : tileBoard) for (auto t : l) t.Update();
    if (Inputs::Keyboard().Pressed(NSK_r)) { Cleanup(); Init(); }
    if (Inputs::Keyboard().Pressed(NSK_t)) { tileBoard[6][5].MoveChipDown(1); tileBoard[3][5].MoveChipDown(3); }
    // Shine (should use timer instead of key)
    _doShineAnim(Inputs::Keyboard().Pressed(NSK_w));

    // Specific update funcs
    switch (state)
    {
        case State::SELECT:
          _update_select();
          break;
        case State::IN_SELECTION:
          _update_inSelection();
          break;
        case State::PLAYER_MOVEMENT:
          _update_playerMovement();
          break;
        case State::BOARD_CHECKING:
          _update_boardChecking();
          break;
        case State::BOARD_FALLING:
          _update_boardFalling();
    }
}

std::vector<std::vector<Chip*>> ToDestroy;

void Level::_update_select()
{
    if (Inputs::Mouse().Pressed(NSM_leftclick))
    {
        selectedChip = _getChipByPos(Inputs::Mouse().pos.x, Inputs::Mouse().pos.y);
        if (selectedChip)
        {
            selectedChip->interrupt(3);
            state = State::IN_SELECTION;
            stateframe = 0;
        }
    }
    if (Inputs::Mouse().Pressed(NSM_rightclick))
    {
        selectedChip = _getChipByPos(Inputs::Mouse().pos.x, Inputs::Mouse().pos.y);
        if (selectedChip)
        {
            if (Inputs::Keyboard().Down(NSK_lshift)) {
                int c = selectedChip->color;
                if (c == -1) return;
                std::vector<Chip*> cs;
                for (int i = 0; i < 121; i++) if (tileBoard[i/11][i%11].myChip && tileBoard[i/11][i%11].myChip->color == c) cs.push_back(tileBoard[i/11][i%11].myChip);
                ToDestroy.push_back(cs);
            }
            else {
                ToDestroy.push_back({selectedChip});
            }
            state = State::BOARD_CHECKING;
        }
    }
}

void GetToDestroy(std::vector<std::vector<Tile>> const& t)
{
    ToDestroy.clear();
    for (int i = 0; i < 121; i++)
    {
        bool found = false;
        for (auto v : ToDestroy)
        {
            for (auto c : v) if (t[i/11][i%11].getChip() == c) { found = true; break ; }
            if (found) break;
        }
        if (found) continue;
        t[i/11][i%11].Lined(ToDestroy);
    }
}

void Level::_update_inSelection()
{
    #define NEIGHBOR(c, b) (abs((c)->x-(b)->x)==44&&(c)->y==(b)->y || abs((c)->y-(b)->y)==44&&(c)->x==(b)->x)
    Chip* c = _getChipByPos(Inputs::Mouse().pos.x, Inputs::Mouse().pos.y);
    if (Inputs::Mouse().Released(NSM_leftclick))
    {
        stateframe = 1;
    }
    if (stateframe == 0 && Inputs::Mouse().Down(NSM_leftclick))
    {
        if (!c || c == selectedChip) return;
        if (NEIGHBOR(c, selectedChip))
        {
            swapChip = c;
            state = State::PLAYER_MOVEMENT;
            stateframe = 0;
        }

    }
    if (Inputs::Mouse().Pressed(NSM_leftclick))
    {
        if (!c || c == selectedChip || !NEIGHBOR(c, selectedChip))
        {
            selectedChip->interrupt(2);
            selectedChip = nullptr;
            state = State::SELECT;
            return;
        }
        else
        {
            swapChip = c;
            state = State::PLAYER_MOVEMENT;
            stateframe = 0;
        }
    }
    #undef NEIGHBOR
}

void Level::_update_playerMovement()
{
    static bool willwork = true;
    static Tile* tsel = nullptr;
    static Tile* tswa = nullptr;
    if (stateframe == 0)
    {
        tsel = selectedChip->t;
        tswa = swapChip->t;
        tsel->AssignChip(swapChip);
        tswa->AssignChip(selectedChip);
        // TODO: Update chipboard
        willwork = true;
        GetToDestroy(tileBoard);
        if (ToDestroy.empty()) willwork = false;
    }
    if (stateframe == 22 )
    {
        if (willwork)
        {
            state = State::BOARD_CHECKING;
            selectedChip->interrupt(2);
            selectedChip = nullptr;
            swapChip = nullptr;
        }
        else {
            tswa->AssignChip(swapChip);
            tsel->AssignChip(selectedChip);
        }
    }
    if (stateframe == 44)
    {
        state = State::SELECT;
        selectedChip->interrupt(2);
        selectedChip = nullptr;
        swapChip = nullptr;
    }
    stateframe++;
}


void Level::_update_boardChecking()
{
    if (ToDestroy.empty()) { state = State::SELECT; return; }
    for (auto& v : ToDestroy) for (auto c : v)  { c->t->myChip = nullptr; delete c; }
    state = State::BOARD_FALLING;
    stateframe = 0;
}

void Level::_update_boardFalling()
{
    if (stateframe == 0)
    {
        float begx = -GRIDSIZE*5.5f+OX;
        float begy = GRIDSIZE*5.5f+OY;
        for (int i = 0; i < 11; i++)
        {
            float x = begx+44*(i%11)+22;
            int descent = 0;
            for (int j = 10; j >= 0; j--)
            {
                if (tileBoard[j][i].empty) continue;
                if (tileBoard[j][i].myChip == nullptr) { descent++; continue; }
                tileBoard[j][i].MoveChipDown(descent);
            } int j = 0;
            while (descent > 0 && j < 11)
            {
                if (!tileBoard[j][i].empty) { tileBoard[j][i].AssignChip(new Chip(Random::Float01()*5)); descent--; }
                j++;
            }
        }
        stateframe = 1;
    }
    bool any = false;
    for (int i = 0; i < 121; i++) if (tileBoard[i/11][i%11].myChip && tileBoard[i/11][i%11].myChip->IsMoving()) any = true;
    if (!any) {
        GetToDestroy(tileBoard);
        // TODO: Better
        // Remove falling objects when at bottom
        for (int i = 0; i < 11; i++)
        {
            for (int j = 10; j >= 0; j--)
            {
                if (tileBoard[j][i].empty) continue;
                if (!tileBoard[j][i].myChip) break;
                if (tileBoard[j][i].myChip->color == -1) ToDestroy.push_back({tileBoard[j][i].myChip});
                break;
            }
        }
        state = State::BOARD_CHECKING;
    }
}
