#ifndef ANMCHIPS_H_
#define ANMCHIPS_H_

class AnmChips {
    public:
        static void Init();
    private:
        static bool isInit;
};

extern int AnmChipGen(int type);

#endif // ANMCHIPS_H_
