// The "noreturn" attribute.

[[noreturn]] void f()
{
  throw 42;
}

int main()
{
  try {
    f();
  }
  catch (...) {
  }
}
