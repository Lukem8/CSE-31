#include <stdio.h>
#define MAXSIZE 4096
#include <string.h>
/**
 * You can use this recommended helper function 
 * Returns true if partial_line matches pattern, starting from
 * the first char of partial_line.
 */
int regCheck(char *line, char* newpattern, int pattern_length, int line_length);

int backSlash(char *line, char *pattern)
 {
	int i;
	int j =1;
	int count = 0;
	int pattern_length = strlen(pattern); 
	
	char newpattern[pattern_length];

	for (i = 0; i < pattern_length; i++)
	{
		newpattern[i] = pattern[i];	//now newpattern is our pattern
	}


	for (i = 0; i < pattern_length; i++)
	{
		if( (newpattern[i] == 92 && newpattern[i+1] != '?')  ||  (newpattern[i] == 92 && newpattern[i+1] != '+') || (newpattern[i] == 92 && newpattern[i+1] != '.') || (newpattern[i] == 92 && 			newpattern[i+1] != 92))
		{
			count++;
			for(j = i; j < pattern_length; j++)
			{
				newpattern[j] = newpattern[j+1];			
			}
		break;
		}
		
	}
	pattern_length = pattern_length-count;
	return pattern_length;
}

int specials(char *line, char* newpattern, int pattern_length, int line_length) {
									
	char p[pattern_length-1];			
	char p2[pattern_length-2];
	int a,incr,specialChar;
	int x,x2;
	int k,j,i;
	int check =0;
	for (i = 0; i < pattern_length; i++)
	{		
		
		if (newpattern[i] == '?')
		{ 
			
				for (k = 0; k < pattern_length; k++)
				{
					if (k < i)
						a = k;
					if (k >= i)
						a = k+1;
					
					p[k] = newpattern[a];		
					

				}
				pattern_length -= 1;	
									
				x = specials(line, p, pattern_length, line_length);
			
				for (k = 0; k < pattern_length-1; k++)
				{
					if (k < i-1)
						a = k;
					if (k >= i-1)
						a = k+2;
					
					p2[k] = newpattern[a];		
					//which = 0;
					
				}
				pattern_length -= 1;
			
				x2 = specials(line, p2, pattern_length, line_length);
				if (x == 1 || x2 == 1)
					return 1;
				else 
					return 0;
		
		}
	}		
	
	for (i = 0; i < line_length; i++)
	{
		check = 0;
		if (line[i] == newpattern[0] || newpattern[0] == '.' ) 
		{
			check++;
			j=1;
			for (k = i+1; k < line_length; k++)		// k cant be less than pattern_length
			{	
				if (newpattern[j] == '+')			
				{	
							
					incr = i+1;
					specialChar = newpattern[j-1];
					while (line[incr] == specialChar) 	//while loop to get through the repeating character
					{
						incr++;
					}
					check++;
					
					if (check == pattern_length)
						return 1;
					k = incr;
					if (pattern_length > j)
					{
						if(line[k] == newpattern[j+1] || line[k] == newpattern[j+2])
						{	
							j += 2;
							check++;
							k++;
							continue;		//continue because we found the match
						}
						else 
						{
							check = 0;
							j = 1;		//reset j when we break
							break;
						}
					}
				}			
				
				if (check < pattern_length)
				{
					if(line[k] == newpattern[j] || newpattern[j] == '.')		
					{
						j++;
						check++;
	
					}
					else 
					{
						check = 0;
						j = 1;
						break;		
					}
				}
			}
			
			if (check == pattern_length || check == pattern_length-1)
			{	
				return 1;
			}
		}
	}	
    return 0;
}
int regCheck(char *line, char* newpattern, int pattern_length, int line_length) {
	int i;
	int check = 0;
	int j,k;
	for (i = 0; i < line_length; i++)
	{
		check = 0;
		if (line[i] == newpattern[0]) 
		{
			check++;
			j=1;
			for (k = i+1; k < line_length; k++)	
			{				
				
				if (check < pattern_length)
				{
					if(line[k] == newpattern[j])		
					{
						j++;
						check++;
	
					}
					else 
					{
						check = 0;
						j = 1;
						break;		
					}
				}
			}
			if (check == pattern_length)
			{	
				return 1;
			}
		}
	}	
    return 0;
}

int rgrep_matches(char *line, char *pattern) {
	int y;	
	int line_length = (strlen(line) - 1);		
	int pattern_length = strlen(pattern); 
	
	y = specials(line, pattern, pattern_length, line_length);
	if (y)
		return 1;
	else
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
