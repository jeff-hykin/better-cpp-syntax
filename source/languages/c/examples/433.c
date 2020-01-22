void test()
{
  asm
  (
    : : :
  );
}

void test()
{
    __asm__
    (
        // load palettes
        "ld2 {v4.16b, v5.16b}, [%[curpal0]]\n"
        "ld2 {v6.16b, v7.16b}, [%[curpal1]]\n"
        :
            [prevTileLo] "+w" (prevTile.val[0]), [prevTileHi] "+w" (prevTile.val[1])
        :
            [curpal0] "r" (curpal0), [curpal1] "r" (curpal1)
        :
            "memory", "q0", "q1", "q2", "q3", "q4", "q5", "q6", "q7"
    );

    int test = 0;
    printf("test %d\n", 0);
}

int main(int argc char* argv[])
{

}