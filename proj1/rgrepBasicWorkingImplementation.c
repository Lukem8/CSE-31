#include <stdio.h>
#define MAXSIZE 4096
#include <string.h>
/**
 * You can use this recommended helper function 
 * Returns true if partial_line matches pattern, starting from
 * the first char of partial_line.
 */
int matches_leading(char *partial_line, char *pattern) {
  // Implement if desire 
	
  return 0;
}

/**
 * You may assume that all strings are properly null terminated 
 * and will not overrun the buffer set by MAXSIZE 
 *
 * Implementation of the rgrep matcher function
 */
int rgrep_matches(char *line, char *pattern) {		//function receives a line of short.txt and the pattern
	int i,k;
	int j =1;
	int check =0;
	
	int line_length = strlen(line);		// length of string from line from file including null char \0
	int pattern_length = strlen(pattern); // gets length of our pattern including single quotes ' '
	
	char newpattern[pattern_length-2];		// size of newpattern we will work with, excludes the size from the single quotes
	for (i = 1; i < pattern_length-2; i++)
	{
		newpattern[i-1] = pattern[i];		//newpattern contains our pattern from command line minus the single quotes given
	}
											
	pattern_length = strlen(newpattern);	//length of our pattern
	
	if ((line_length-1) < pattern_length)	// check if pattern is longer than current line
	{
		return 0;
	}
	
	/* START OF PATTERN CHECKING FOR CURRENT LINE */
	for (i = 0; i <= line_length-1; i++)
	{
		check = 0;
		if (line[i] == newpattern[0]) //Checks each character to see if equal, goal is for check to equal pattern length
		{
			check++;
			
			for (k = i+1; k < line_length-1; k++)
			{
				
				if(line[k] == newpattern[j])
				{
					j++;
					check++;	
				}
				else 
				{
					check = 0;
					break;
				}
			}
			if (check == pattern_length-1)
			{
				return 1;
			}
		}
	}	
    return 0;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <PATTERN>\n", argv[0]);
        return 2;
    }
	
    /* we're not going to worry about long lines */
    char buf[MAXSIZE];

    while (!feof(stdin) && !ferror(stdin)) {
        if (!fgets(buf, sizeof(buf), stdin)) {
            break;
        }
        if (rgrep_matches(buf, argv[1])) {
            fputs(buf, stdout);
            fflush(stdout);
        }
    }

    if (ferror(stdin)) {
        perror(argv[0]);
        return 1;
    }
    return 0;
}
