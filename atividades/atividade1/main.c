#include <stdio.h>
#include <fstream>
#include <iostream>


// colunas: letra, digito, outro
// linhas: estado 1, estado 2, estado 3
int tabela[3][3] {
    { 1, -1, -1}, 
    { 1, 1, 2},
    {-1, -1, -1}
};

using namespace std;

ifstream arq("sort.txt");
ofstream saida("saida.txt");

bool ehLetra(char c) {
    return (c >= 'A' && c<= 'Z') || (c >= 'a' && c <= 'z');
}

bool ehDigito(char c) {
    return (c >= '0' && c <= '9');
}

int classifica(char c) {
    if (ehLetra(c)) return 0;
    if (ehDigito(c)) return 1;
    return 2;
}

bool accept(int estado) {
    return estado == 2; // indice 2 == estado 3
}

char proximoChar(){
    char ch;
    arq.get(ch);
    return(ch);
}

int checkTabela(int estado, char ch) {
    int classe = classifica(ch);
    return tabela[estado][classe];
}

int main() {
    char ch;
    while(arq.get(ch)) {
        if (!ehLetra(ch)) {
            // nn começa como id, apenas copia para saida
            saida << ch;
            continue;
        }
        
        // começa no estado 1 (seria o 0)
        int estado = 0;
        
        while (!accept(estado)) {
            int novoEstado = checkTabela(estado,ch);
            
            if (novoEstado == 2) {
                // foi pra "outro", logo nn faz parte do ID
                // devolve pro arquivo pra ser reprocessado dps
                arq.putback(ch);
                estado = novoEstado;
                break;
            }
            
            // letra ou digito faz parte do ID, consome
            estado = novoEstado;
            
            if (!arq.get(ch)) {
                // acabou o arquivo no meio do identificador -> fecha como ID
                estado = 2;
                break;
            }
        }
        if (accept(estado)) {
            // logica de trocar a string por "ID"
            saida << "ID";
        }
    }
    
    arq.close();
    saida.close();
    return 0;
}
