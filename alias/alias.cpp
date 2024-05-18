#include <cstdlib>
#include <fstream>
#include <iostream>

void	ft_putstr_fd(const char *s, std::ostream &os)
{
	os << s;
}

int	check_alias(void)
{
	const char	*home = getenv("HOME");

	std::ifstream	file(home + std::string("/.zshrc"));
	std::string		line;

	if (!file.is_open())
	{
		perror("Error opening the file");
		exit(1);
	}
	while (std::getline(file, line))
	{
		if (line == "alias m_test=~/Minishell_Tester/start.sh")
		{
			std::cerr << "Alias already present in the file" << std::endl;
			file.close();
			return (1);
		}
	}
	file.close();
	return (0);
}

int	main(void)
{
	const char	*home = getenv("HOME");
	char		path[1024];

	if (home == nullptr)
	{
		std::cerr << "Error getting home directory" << std::endl;
		return (1);
	}
	snprintf(path, sizeof(path), "%s/.zshrc", home);
	std::ofstream file(path, std::ios::out | std::ios::app);
	if (!file.is_open())
	{
		perror("Error opening the file");
		return (1);
	}
	else
	{
		if(check_alias() == 1)
			exit(0);
		ft_putstr_fd("\n", file);
		ft_putstr_fd("alias m_test=~/Minishell_Tester/start.sh\n", file);
	}
	file.close();
	return (0);
}
