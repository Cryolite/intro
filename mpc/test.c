#include <mpc.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
  if (argc != 2) {
    return EXIT_FAILURE;
  }

  int i = -1, j = -1, k = -1;
  char c = 0, d = 0;
  int result = sscanf(argv[1], "%d%c%d%c%d", &i, &c, &j, &d, &k);
  if (c != '.') {
    if (result != 1 && result != 2) {
      return EXIT_FAILURE;
    }
    j = 0; k = 0;
  }
  if (d != '.') {
    if (result != 3 && result != 4) {
      return EXIT_FAILURE;
    }
    k = 0;
  }
  if (i != MPC_VERSION_MAJOR
        || j != MPC_VERSION_MINOR
        || k != MPC_VERSION_PATCHLEVEL) {
    return EXIT_FAILURE;
  }

  i = -1; j = -1; k = -1;
  c = 0; d = 0;
  result = sscanf(mpc_get_version(), "%d%c%d%c%d", &i, &c, &j, &d, &k);
  if (c != '.') {
    if (result != 1 && result != 2) {
      return EXIT_FAILURE;
    }
    j = 0; k = 0;
  }
  else if (d != '.') {
    if (result != 3 && result != 4) {
      return EXIT_FAILURE;
    }
    k = 0;
  }
  if (i != MPC_VERSION_MAJOR
        || j != MPC_VERSION_MINOR
        || k != MPC_VERSION_PATCHLEVEL)
  {
    return EXIT_FAILURE;
  }

  return EXIT_SUCCESS;
}
