# Ubuntu 5.4.0-169-generic
- gcc version 10.5.0 (Ubuntu 10.5.0-1ubuntu1~20.04)
- O2 -Wall -std=c11
## Params:
- Num of threads = 8
- Num of iterations = 16000000
- Not using usleep(1) in the loop
- Not using atomic operations in the loop

## Table of results:

| Type | User | System | CPU | Total Time (s) (Real) |
| --- | --- | --- | --- | --- |
| nolock | 0.00s | 0.00s | 117% | 0.002 |
| flock | 2.07s | 23.93s | 290% | 8.958 (wrong total)|
| sysv | 6.50s | 131.04s | 140% | 1:37.89 |
| posix | 1.80s | 3.00s | 294% | 1.630 |
| pmutex | 1.03s | 0.91s | 295% | 0.658 |
| fastl | 0.23s | 0.04s | 173% | 0.155 |
| c11 mtx | 0.75s | 0.75s | 293% | 0.513 |
| cabool | 8.60s | 0.01s | 294% | 2.930  |







## Notes:
- nolock= no locking, just a loop in multiple threads
- flock= using flock
- sysv = using SYSV semaphores
- posix = using POSIX1003.1b semaphores (sem_wait, sem_post)
- pmutex = using pthread_mutex*
- fastl = using fastlock.h from ser (hand made assembler locks)
- c11_mutex = using C11 mutex (mtx)
- c11_atomic_bool = using C11 atomic_bool (atomic_flag)

Test: time ./locking_test* -c 10000000

(sip_router/test/locking/*)
