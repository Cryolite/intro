// Non-static data member initializers.

#include <cstdlib>

class X
{
public:
  X() : j_() {}

  int getI() const
  {
    return i_;
  }

  int getJ() const
  {
    return j_;
  }

private:
  int i_{42};
  int j_;
};

int main()
{
  X x;
  if (x.getI() != 42) {
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
