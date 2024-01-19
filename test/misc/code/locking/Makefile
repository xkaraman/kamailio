#
# $Id$
#

NAME=locking_test
# NAME=locking_test_proccess

# CC=aarch64-linux-gnu-gcc
CC=gcc
CFLAGS= -O2 -Wall -std=c11
DEFS= -D_DEFAULT_SOURCE -D__CPU_x86_64
LIBS= -lrt
INCLUDE=
PTHREAD_LIBS= -lpthread

OS = $(shell uname -s)


ifeq ($(OS), SunOS)
LIBS+= -lrt
CFLAGS+=-mv8 -Wa,-xarch=v8plus
PTHREAD_LIBS= -lpthread
endif
ifeq ($(OS), FreeBSD)
PTHREAD_LIBS= -lc_r
endif

$(NAME): $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DNO_LOCK -o $@ $< $(LIBS) \
		$(PTHREAD_LIBS)


$(NAME)_sysv: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DSYSV_SEM -o $@ $(INCLUDE) $< $(LIBS) \
		$(PTHREAD_LIBS)


$(NAME)_flock: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DFLOCK -o $@ $(INCLUDE) $< $(LIBS) \
		$(PTHREAD_LIBS)

$(NAME)_posix: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DPOSIX_SEM -o $@ $(INCLUDE) $< $(LIBS) \
		$(PTHREAD_LIBS)

$(NAME)_pmutex: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DPTHREAD_MUTEX -o $@ $(INCLUDE) $< $(LIBS) \
		$(PTHREAD_LIBS)

$(NAME)_fastlock: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DFAST_LOCK -o $@ $(INCLUDE) $< $(LIBS) \
		$(PTHREAD_LIBS)

$(NAME)_futex: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DFUTEX -o $@ $(INCLUDE) $< $(LIBS) \
		$(PTHREAD_LIBS)

$(NAME)_c11_mutex: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DC11_MUTEX -o $@ $(INCLUDE) $< $(LIBS) -Ofast -std=c11 \
		$(PTHREAD_LIBS)

$(NAME)_c11_bool: $(NAME).c
	$(CC) $(CFLAGS) $(DEFS) -DC11_BOOL  -o $@ $(INCLUDE) $< $(LIBS) -std=c11 -Ofast \
		$(PTHREAD_LIBS)

all: $(NAME) $(NAME)_sysv  $(NAME)_posix $(NAME)_pmutex \
		$(NAME)_fastlock $(NAME)_c11_mutex $(NAME)_c11_bool

ifneq ($(OS), SunOS)

all: $(NAME)_flock

endif

clean:
	-@rm $(NAME) $(NAME)_sysv $(NAME)_flock $(NAME)_posix \
		$(NAME)_pmutex $(NAME)_fastlock $(NAME)_futex \
		$(NAME)_c11_mutex
