#include <boost/preprocessor/arithmetic/inc.hpp>
#include <boost/preprocessor/arithmetic/dec.hpp>
#include <boost/preprocessor/list/cat.hpp>
#include <boost/preprocessor/repetition/repeat_from_to.hpp>

template <typename T, typename U>
struct foo : T, U {};

#define TYPEDEF_FOO(z, n, type) typedef foo<BOOST_PP_CAT(T, n), BOOST_PP_CAT(T, BOOST_PP_DEC(n))> BOOST_PP_CAT(T, BOOST_PP_INC(n));

struct T0 {};

struct T1 {};

#define N 256

BOOST_PP_REPEAT_FROM_TO(1, N, TYPEDEF_FOO, T)

int main()
{
    BOOST_PP_CAT(T, N) x;
}
