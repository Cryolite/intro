// Pack expansion into non-variadic class template.
// See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=35722

template<typename G = void, typename H = void>
struct foo
{};

template<typename... G>
struct bar : foo<G...>
{};

int main() {
  bar<int, float> f;
}
