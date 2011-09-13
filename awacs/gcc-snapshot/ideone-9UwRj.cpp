// std::uncaught_exception should return true in delegating constructors
// called by the initialization of exception handlers.

#include <cstdlib>
#include <exception>

bool b = false;

struct X
{
  X()
  {}

  X(X const &)
    : X()
  {
    b = std::uncaught_exception();
  }
};

int main()
{
  try {
    throw X();
  }
  catch (X) {
  }
  if (!b) {
    return EXIT_FAILURE;
  }
  return EXIT_SUCCESS;
}
