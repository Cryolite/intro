// Delegating constructors.

#include <cstdlib>

class X
{
public:
  X()
    : i_(42)
  {}

  X(X const &)
    : X()
  {}

  int get() const
  {
    return i_;
  }

private:
  int i_;
};

int main()
{
  X x;
  X y(x);
  if (y.get() != 42) {
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
