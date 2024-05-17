#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static void	sent_text_by_bits(char *s, pid_t serv_pid)
{
	int		b_i;
	char	tmp_c;

	while (*s)
	{
		b_i = 8;
		tmp_c = *s;
		while (b_i-- > 0)
		{
			tmp_c = *s >> b_i;
			if (tmp_c % 2 == 0)
				kill(serv_pid, SIGUSR1);
			else
				kill(serv_pid, SIGUSR2);
			usleep(200);
		}
		s++;
	}
}

int	main(int ac, char **av)
{
	pid_t	serv_pid;

	if (ac != 3)
	{
		printf("Error: Wrong format! \n");
		return (0);
	}
	serv_pid = atoi(av[1]);
	if (kill(serv_pid, 0))
	{
		printf("Error: PID is not valid\n");
		return (0);
	}
	sent_text_by_bits(av[2], serv_pid);
	sent_text_by_bits("\n", serv_pid);
	return (0);
}
