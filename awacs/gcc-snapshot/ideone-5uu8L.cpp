// Alias templates.

#include <memory>
#include <vector>

int main()
{
  template<typename T> using my_vec = std::vector<T, std::allocator<T>>;
  my_vec<int> v;
}
