void func() {
    printf("%d\n", N);
    for(int i = 1; i <= N; ++i)
        printf("%d%c",randint(1,1000000006), " \n"[i==N]);

    static int perm[N + 1];
    for(int i = 1; i <= N; ++i)
        perm[i] = i;
    std::shuffle(perm + 1, perm + 1 + N, gen)
    // std::shuffle(perm + 1, prem + N, perm + 1 + N)
}