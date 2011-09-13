// Rvalue references on *this.

#include <cassert>

struct X
{
  int get() &
  {
    return 0;
  }

  int get() &&
  {
    return 1;
  }
};

int main()
{
  X x;
  assert(x.get() == 0);
  assert(X().get() == 1);
}
