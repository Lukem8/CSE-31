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
