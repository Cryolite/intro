// Calculates the number of parameters of a class template.                                                                                                                                                                                                                     

#include <cstddef>
#include <cstdlib>

template<template<class...> class TT, class... Args>
constexpr std::size_t foo(TT<Args...> const &)
{
  return sizeof...(Args);
}

template<typename T1>
struct X1{};

template<typename T1, typename T2>
struct X2{};

template<typename T1, typename T2, typename T3>
struct X3{};

template<typename... Args>
struct V{};

static_assert(foo(X1<int>()) == 1u, "");
static_assert(foo(X2<int, int>()) == 2u, "");
static_assert(foo(X3<int, int, int>()) == 3u, "");
static_assert(foo(V<>()) == 0u, "");
static_assert(foo(V<int>()) == 1u, "");
static_assert(foo(V<int, int>()) == 2u, "");

int main()
{
  return EXIT_SUCCESS;
}
