#include <stdlib.h>
#include <stdio.h>
#include <linux/membarrier.h>
#include <sys/membarrier.h>

int main()
{
    int rc = membarrier(MEMBARRIER_CMD_QUERY, 0);
    if (rc < 0) {
        perror("membarrier");
        exit(EXIT_FAILURE);
    }
    exit(EXIT_SUCCESS);
}
