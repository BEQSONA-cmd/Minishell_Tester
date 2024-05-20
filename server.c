char		**g_envp;

void	execute_string(char *input)
{
	t_mshell	mshell;
	char		*path;

	init_mshell(&mshell, g_envp);
	printf("%s\n", input);
	parse_input(input, &mshell);
	ft_execute(&mshell, g_envp);
	path = get_currect_path(g_envp);
	write(1, path, ft_strlen(path));
	ft_free(path);
}

void	get_signal(int bit)
{
	static char	c;
	static int	i;
	static int	g;
	static char	line[4096];

	c |= (bit == SIGUSR2);
	if (++i == 8)
	{
		line[g] = c;
		if (line[g] == '\n')
		{
			line[g] = '\0';
			execute_string(line);
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
