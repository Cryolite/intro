// constexpr on std::numeric_limits specializations.

#include <limits>

static_assert(std::numeric_limits<double>::epsilon() != 0.0, "");

int main(){}
