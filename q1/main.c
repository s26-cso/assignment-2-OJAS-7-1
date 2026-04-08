#include<stdio.h>
#include<stdlib.h>
struct node{
    int val;
    struct node *left;
    struct node *right;
};

struct node *make_node(int val);
struct node *insert(struct node* root,int val);
struct node *get(struct node* root,int val);
int getAtMost(int val,struct node* root);

int main(){


    return 0;
}