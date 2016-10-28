#include<stdio.h>
#define Hsize 26
int main()
{
	char arr[100][1000],str[10];
	int T,N,i,j,k,Hash[Hsize],flag[100];
	scanf("%d",&T);
	for(i=0;i<T;i++)
	{
		for(j=0;j<Hsize;j++)
		Hash[j]=0;
		flag[i]=1;
		scanf("%d",&N);
		if(N>26) flag[i]=0;
		for(j=0;j<N;j++)
		{
			scanf("%s",str);
			arr[i][j]=str[0];
			k=(int)(arr[i][j]-'a');
			if(Hash[k]==0)
			Hash[k]=k+1;
			else 
			flag[i]=0;
		}
	}
	for(i=0;i<T;i++)
	if(flag[i]==1) printf("YES\n");
	else printf("NO\n");
return 0;	
	
}
