# riscv-busca-maior-função.asm
# Função p/ procurar o maior nro em um vetor de 10 nros inteiros, passado por referência
# Mostra o uso de passagem de parâmetros por referência e por valor, valor de retorno, variárveis locais
#

.data

str1: .string "Maior valor encontrado=  "
str2: .string "\n"


.text

# --- main -------------------------------------------------

main:
	addi sp, sp, -48 # Alocar espaço na pilha para array de 10 posições de inteiros, N, maior_encontrado
 	
 	mv a0, sp 		# a0 = endereço de veto: parâmetro 1 de buscaMaior
 	li t1, 4		#Inicialização do vetor "valores" armazenado na pilha, como variável local da função main
 	sw t1, 0(sp)
 	li t1, 5
 	sw t1, 4(sp)
 	li t1, 7
 	sw t1, 8(sp)
 	li t1, 12
 	sw t1, 12(sp)
 	li t1, 654
 	sw t1, 16(sp)
 	li t1, 2
 	sw t1, 20(sp)
 	li t1, 78
 	sw t1, 24(sp)
 	li t1, 22
 	sw t1, 28(sp)
 	li t1, 8
 	sw t1, 32(sp)
 	li t1, 16
 	sw t1, 36(sp)
 	
 	
 	li t1, 10  ##Inicialização da variável  "N", armazenada na pilha, como variável local da função main
 	sw t1, 40(sp)
 	mv a1, t1   # a1 = parâmetro 2 de buscaMaior
 	
 	li t1, -999  ##Inicialização da variável local a main, "maiorEcontrado", armazenada na pilha da função main
 	sw t1, 44(sp)
 	
 	jal buscaMaior   # comando C correspondente: maiorEncontrado= buscaMaior(valores, N);
 	
 	mv t1,a0   #atualiza na memória o valor da variável local "maiorEcontrado", com o valor retornado
 	sw t1, 44(sp)

 	 # Imprimir resultados no console  (argumento em a0)
     jal ra, printResultado
     


 	addi sp, sp, 48 # Desalocar área da pilha usada por main



fimPrograma:
        li a7, 10
        ecall


# --- buscaMaior -------------------------------------------------
# Parâmetros de entrada: a0: endereço do vetor, a1: tamanho do vetor 

buscaMaior:
	addi sp, sp, -8  # Alocar espaço na pilha 2 variáveis locais a buscaMaior: maior, i
	
	li t1, -999 # Var local "maior" - Inicialização com o -999 
 	sw t1, 0(sp) # Armazenar maior na pilha, como variável local de buscaMaior
 	 	
 	li t2, 0  	 # Var local "i" - Inicialização c/ 1 e armazenar na pilha
 	sw t2, 4(sp)
		
for:
	bge t2, a1, fimloop # if i >= 10, fim do loop
	slli t3, t2, 2 # t3 = i * 4
	add t4, a0, t3 # t4= &vetor + i*4
	lw t5, 0(t4) # t5 = vetor[i]

	blt t5, t1, proximo # se vetor[i] < maior, then proxima interação
	
	mv t1, t5 # senão, atualizar maior com novo valor encontrado no vetor
	sw t1, 0(sp)  ## atualiza o valor de maior na memória - Comando C correspondente: maior = vetor[i];

proximo:
	addi t2, t2, 1   #i= i+1
	sw t2, 4(sp)     # atualiza o valor de i na memória - Comando C correspondente: for (i=0; i<tamanho; i++) {
	j for   #próxima interação do loop

fimloop:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	jal, ra, reinicializaVetor
	
	mv a2,a0
	
	mv a0, t1   # maior valor encontrado retorna em a0


	lw ra, 0(sp)
	
	addi sp, sp, 8  # Desalocar área da pilha usada por buscaMaior
	
	
	
	ret   # retorna p/ função main 
	
	
reinicializaVetor:
	
	li t2, 0 
	
	forr:

		bge t2, a1, fimloopdois
		slli t3, t2, 2 # t3 = i * 4
		add t4, a0, t3 # t4= &vetor + i*4
		sw t1, 0(t4) 
		addi t2, t2, 1
	
	j forr
	
fimloopdois:
	ret

	

   

  

# --- printResultado --------------------------------------
# a0: Contém o valor do maior nro do vetor 
printResultado:

	sw ra, 0(sp)
	li t2, 0
       
       forprint:
       
       	bge t2, a1, fimloopfor
       	slli t3, t2, 2 # t3 = i * 4
	add t4, a2, t3 # t4= &vetor + i*4
	
	lw a0, 0(t4)
	li a7,1
	ecall
	
	la a0, str2
	li a7, 4
	ecall
	
	addi t2, t2, 1
       
      
       j forprint


        fimloopfor:	
               ret
        	
       
	lw ra, 0(sp)
        
        
        ret
      
 ## ---- fim de printResultado -----------
        
