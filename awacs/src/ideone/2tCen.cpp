// Pack-expansion of lambda expressions.

template<typename... Args>
void dummy(Args &&...)
{}

template<int... IS>
void foo()
{
  dummy([]{ return IS; }()...);
}

int main()
{
  foo<0, 1, 2>();
}
