/* Works */
class ChildClass : public ParentClass {};

/* Highlighting lost */
class DLLEXPORT ChildClass : public ParentClass {};
class ChildClass : /* comment */ public ParentClass {};
class alignas(32) ChildClass : public ParentClass {};