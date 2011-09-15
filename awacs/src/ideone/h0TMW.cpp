// Pack expansion as fixed-size template arguments.

#include <tuple>

template<class T, class U>
struct X
{};

template<class... Args>
void f(std::tuple<Args...> const &)
{
  X<Args...> x;
}

int main()
{
  std::tuple<int, int> t;
  f(t);
}
