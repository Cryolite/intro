// Non-static data member initializers with equal-initializers.

#include <cstdlib>

class X
{
public:
  X() : j_(43) {}

  int getI() const
  {
    return i_;
  }

  int getJ() const
  {
    return j_;
  }

private:
  int i_ = 42;
  int j_;
};

int main()
{
  X x;
  if (x.getI() != 42 || x.getJ() != 43) {
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
