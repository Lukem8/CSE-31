



char* backSlash(char *line, char *pattern)
{
 	int i,k,index,a;
 	int j =1;
 	int check =0;
 	int count = 0;
	//int hasQ = 0;
	int line_length = (strlen(line) - 1);		// length of string from line from file including null char \0
	int pattern_length = strlen(pattern); 		// gets length of our pattern 
	//printf("%d\n", pattern_length);

	char p[pattern_length-1];

	for (i = 0; i < pattern_length; i++)
	{
		newpattern[i] = pattern[i];	//now newpattern is our pattern
	}


	for (i = 0; i < pattern_length; i++)
	{

		
		if( (newpattern[i] == 92 && newpattern[i+1] == '?')  ||  (newpattern[i] == 92 && newpattern[i+1] == '+') || (newpattern[i] == 92 && newpattern[i+1] == '.') || (newpattern[i] == 92 && newpattern[i+1] == 92))
		{
			index = i;
			for(k = 0; j < pattern_length; j++)
			{
				if (k < index)
					a = k;
				if (k >= i)
					a = k+1;
				p[k] = newpattern[a];					
			}
			

		}



	}
	return newpattern;
}
