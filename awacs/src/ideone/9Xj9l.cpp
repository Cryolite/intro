// Constexpr functions can contain null statements,
// static_assert-declarations, typedef declarations, using-declarations
// and using-directives.

namespace my{ namespace nested{

template<class T>
struct s
{
  static constexpr int min()
  {
    return 0;
  }

  static constexpr int max()
  {
    return 42;
  }
};

}}

constexpr double f()
{
  ;
  using namespace my;
  using nested::s;
  typedef s<double> x;
  static_assert(x::max() > x::min(), "");
  return x::max();
}

int main()
{
  static_assert(f() == 42, "");
}
