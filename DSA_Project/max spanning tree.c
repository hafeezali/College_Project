#include<stdio.h>
#include<stdlib.h>
// int i,j,k,u,v,n,ne,a,b;
int maxcost[20],parent[20][100001],u,v;
struct edge{
	int a,b,c;
}e[20][100001],temp; 

int partition(int low,int high,int ctr)
{
int pivot,j,i;
j=low-1;
pivot=e[ctr][high].c;
for(i=low;i<high;i++)
{
 if(e[ctr][i].c>=pivot)
 {
 	j++;
 	temp=e[ctr][j];
 	e[ctr][j]=e[ctr][i];
 	e[ctr][i]=temp;
 }
}
temp=e[ctr][j+1];
e[ctr][j+1]=e[ctr][high];
e[ctr][high]=temp;
return(j+1);
}
void quicksort(int low,int high,int ctr)
{
int p;
if(low<high)
{
	p=partition(low,high,ctr);
quicksort(low,p-1,ctr);
quicksort(p+1,high,ctr);
}
}
int main()
{
int a,b,c,T,ctr,N,M,i,count=0;
scanf("%d",&T);
for(ctr=0;ctr<T;ctr++)
{
	count=0;
scanf("%d%d",&N,&M);	

for(i=1;i<=M;i++)
	{
	scanf("%d%d%d",&a,&b,&c);

	e[ctr][i].a=a;
	e[ctr][i].b=b;
	e[ctr][i].c=c;
	}
	

quicksort(1,M,ctr);

		for(i=1;i<=M;i++)
		{
			a=u=e[ctr][i].a;
			b=v=e[ctr][i].b;
		u=find(u,ctr); 
		if(parent[ctr][a]!=0)
		parent[ctr][a]=u;
		v=find(v,ctr); 
		if(parent[ctr][b]!=0)
		parent[ctr][b]=v;
		if(uni(u,v,ctr))
		{
			maxcost[ctr] +=e[ctr][i].c;
			count++;
			if(count==N-1) break;
		}
	
	}

}
for(ctr=0;ctr<T;ctr++)
printf("%d\n",maxcost[ctr]);
return 0;
}
int find(int i,int ctr)
{   
	while(parent[ctr][i]!=0)
	i=parent[ctr][i];
	return i;
}
int uni(int i,int j,int ctr)
{
	if(i!=j)
	{
		parent[ctr][j]=i;
		return 1;
	}
	return 0;
}

