#include <cstddef>
#include <cstdlib>


template<typename T>
bool f(T x)
{
  std::size_t const a = x;
  return [=]() {
    return a == 100;
  }();
}

int main()
{
  return f(100) ? EXIT_SUCCESS : EXIT_FAILURE;
}
