#include <algorithm>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <vector>

void	removeSpecificLines(const char *filename,
		const std::vector<std::string> &linesToRemove)
{
	bool	found;

	std::ifstream inFile(filename);
	if (!inFile.is_open())
	{
		perror("Error opening the file");
		exit(1);
	}
	std::vector<std::string> lines;
	std::string line;
	while (std::getline(inFile, line))
	{
		found = false;
		for (size_t i = 0; i < linesToRemove.size(); ++i)
		{
			if (line == linesToRemove[i])
			{
				found = true;
				break ;
			}
		}
		if (!found)
		{
			lines.push_back(line);
		}
	}
	inFile.close();
	std::ofstream outFile(filename);
	if (!outFile.is_open())
	{
		perror("Error opening the file");
		exit(1);
	}
	for (size_t i = 0; i < lines.size(); ++i)
	{
		outFile << lines[i] << "\n";
	}
	outFile.close();
}

int	main(void)
{
	const char	*home = getenv("HOME");
	const char	*filename = ".zshrc";
	char		path[1024];

	if (home == nullptr)
	{
		std::cerr << "Error getting home directory" << std::endl;
		return (1);
	}
	snprintf(path, sizeof(path), "%s/%s", home, filename);
	std::vector<std::string> linesToRemove;
	linesToRemove.push_back("");
	linesToRemove.push_back("alias m_test=~/Minishell_Tester/start.sh");
	linesToRemove.push_back("alias reallyshell=~/Minishell_Tester/connect.sh");
	removeSpecificLines(path, linesToRemove);
	return (0);
}
