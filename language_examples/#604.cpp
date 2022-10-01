auto compare =
    [](
        const QualifiedName& a,
        const QualifiedName& b
    ) -> auto /* broken! */ /*
    // broken
    {
        return a.raw < b.raw;
    };
    */
    {
        return a.raw < b.raw;
    };