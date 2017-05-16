NAME		=	example

CC		=	gcc

RM		=	rm -f

COMPILEFLAGS	=	-W -Wall -Wextra

INCLUDES	=	includes

LDFLAGS		=	

CFLAGS		=	$(COMPILEFLAGS) -I ./$(INCLUDES)

SRCPATH		=	src

SRCS		=	$(SRCPATH)/main.c	\
			$(SRCPATH)/file2.c	\
			$(SRCPATH)/file3.c	\

OBJS		=	$(SRCS:.c=.o)

DEBUG		=	no

ifeq ($(DEBUG), yes)
CC		=	clang
CFLAGS		+=	-g -Weverything
LDFLAGS		+=	
endif

all: $(NAME)

$(NAME): $(OBJS)
	@echo -n "\033[0;34mCompilation en cours...\033[0m\n"
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME) $(LDFLAGS) && \
	printf "\033[0;32mCompilation terminée avec succès.\033[0m\n"

clean:
	$(RM) $(OBJS) && \
	printf "\033[0;33mSuppression des \".o\"...\033[0m\n"

fclean: clean
	$(RM) $(NAME) && \
	printf "\033[0;33mSuppresion du binaire...\033[0m\n"

re: fclean all

