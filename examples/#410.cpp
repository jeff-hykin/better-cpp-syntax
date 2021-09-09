template <typename T>
class DummyContainer
{
public:
  DummyContainer(unsigned int size) : size(size)
  {
    container=new T[size];
  }

  ~DummyContainer()
  {
    delete [] container;
  }

  DummyContainer operator>>=(unsigned int n)
  {
    for (int itr=0;itr+n<size;++itr)
    {
      container[itr]=container[itr+n];
    }
    return *this;
  }

  DummyContainer operator<<=(unsigned int n)
  {
    for (int itr=0;itr+n<size;++itr)
    {
      container[itr]=container[itr+n];
    }
    return *this;
  }

private:
  T *container;
  int size;
};