struct A1 {
  virtual ~A1() = default;
};

struct A2 {
  virtual ~A2() = 0;
};

A2::~A2() = default;

struct A3 {
  ~A3();
};

A3::~A3() {}
