// SFINAE for the object creation of an incomplete type.

struct complete{};
struct incomplete;
template<class T> auto f(T *) -> decltype(T{}) *;
template<class T> char f(T);
int main()
{
  complete *p = 0;
  static_assert(sizeof(f(p)) == sizeof(void*), "");
  incomplete *q = 0;
  static_assert(sizeof(f(q)) == 1u, "");
}
