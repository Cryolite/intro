#include <cstddef>
#include <cstdlib>
#include <iostream>


template<typename T>
void f(T x)
{
  const std::size_t a = x;
  [&]() {
    std::cout << &a << std::endl;
  }();
}

int main()
{
  f(100);
}
