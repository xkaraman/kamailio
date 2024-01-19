
# Ubuntu 5.4.0-169-generic (gcc)
- gcc version 10.5.0 (Ubuntu 10.5.0-1ubuntu1~20.04)
- -O3 -Wall -std=c11
## Params:
- Num of proccess = 8
- Num of iterations = 16000000

## Table of results:

| Type | User | System | CPU | Total Time (s) (Real) |
| --- | --- | --- | --- | --- |
| nolock | 5.47s | 0.00s | 287% | **1.905** |
| flock | 36.20s | 280.99s | 287% | **1:50.28** |
| sysv | 107.86s | 1385.78s | 138% | **17:59.51** |
| posix | 13.62s | 0.03s |  279% | ***4.880*** |
| pmutex | 7.32s | 10.82s | 287% | **6.300** |
| fastl | 10.27s | 0.01s | 288% | ***3.559*** |
| c11 mtx | 13.15s | 0.02s | 281% | ***4.680*** |
| cabool | 14.74s | 0.02s | 282% | **5.232**  |

## Notes:
- nolock= no locking, just a loop in multiple threads
- flock= using flock
- sysv = using SYSV semaphores
- posix = using POSIX1003.1b semaphores (sem_wait, sem_post)
- pmutex = using pthread_mutex*
- fastl = using fastlock.h from ser (hand made assembler
locks)
- c11 mtx = using C11 mutex (mtx)
- cabool = using C11 atomic_bool (atomic_flag)

Test: time ./locking_test_* -c 1 (iteration hardcoded to 16000000)
(misc/test/locking/*)
