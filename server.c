char	**g_envp;

void	get_signal(int bit, siginfo_t *info, void *context)
{
	static char	c;
	static int	i;
	static int	g;
	char		*path;
	static char	line[4096];
	t_mshell	*mshell;

	path = NULL;
	mshell = (t_mshell *)context;
	(void)info;
	c |= (bit == SIGUSR2);
	if (++i == 8)
	{
		line[g] = c;
		if (line[g] == '\n')
		{
			line[g] = '\0';
			init_mshell(mshell, g_envp);
			mshell->input = ft_strdup(line);
			printf("%s\n", mshell->input);
			parse_input(mshell->input, mshell);
			ft_execute(mshell, g_envp);
			ft_free(mshell->input);
			path = get_currect_path(g_envp);
			write(1, path, ft_strlen(path));
			ft_free(path);
			g = 0;
		}
		else
			g++;
		c = 0;
		i = 0;
	}
	else
		c <<= 1;
}

int	main(int argc, char **argv, char **envp)
{
	struct sigaction sa;
	g_envp = envp;
	sa.sa_flags = SA_SIGINFO;
	sa.sa_sigaction = get_signal;
	sigemptyset(&sa.sa_mask);
	sigaction(SIGUSR1, &sa, NULL);
	sigaction(SIGUSR2, &sa, NULL);
}
