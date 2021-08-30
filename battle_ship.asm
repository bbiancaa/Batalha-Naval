.data

ships:							.asciz "3\n1511\n0522\n0164"
n:							.asciz "\n"	
lines:							.word 10
columns:						.word 10
matriz:							.word 100 #pensando em uma maneira diferente de salvar os valores

.text
main:
	la	a1, ships				# lê endereço do vetor
	la	s0, matriz				# le matriz para ser escrita
	la	s8, matriz				# le matriz para ser printada
	la 	s1, columns
	add	s3, s3, zero				# autoincrement para for de printar
	addi	s4, s4, 10				# valor para adicionar \n
	addi	s5, s5, 100				# tamanho da matriz
	
	lbu  	s2, (a1)				# pego valor primeira posicao = quantidade de navios	
	addi	a1, a1, 2				# pula 2 caracter pois informacao necessaria ja adqurida na primeira linha
	
	li  	t1, '\n'				# grava \n
	li  	t2, '\0'				# grava eof
	li  	t3, '0'					# horizontal
	li  	t4, '1'					# vertical
	j	insere_embarcacoes			# chama função insere_embarcacoes:


insere_embarcacoes:  

	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	
	beq	t0, t3, insere_na_horizontal		# insere navio na horizontal
	beq	t0, t4, insere_na_vertical		# insere navio na vertical
	j	loop_matriz
	


loop_find_eof:
	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	j	insere_embarcacoes
	
	

insere_na_horizontal:
	jal	loop_all_caracters
	jal	preenche_vetor_horizontal
	j 	insere_na_horizontal			# funcao recursiva para percorrer toda a linha
	

insere_na_vertical:

	jal	loop_all_caracters
	jal	preenche_vetor_vertical
	
	j insere_na_vertical				# funcao recursiva para percorrer toda a linha
	
loop_all_caracters:

	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	addi 	a1, a1, 1				# pula 1 endereco de memoria, aqui por ser string cada posicao tem 8 bits
	
	
	beq   	t0, t1, loop_find_eof 			# verifica se possui \n para proxima interacao
	
	beq   	t0, t2, print_n 			# verifica se endereço atual é \0 vai printar a matriz
	
	ret

preenche_vetor_vertical:
	sw	t0, 0(s0)
	addi	s0, s0, 40				# se for vertical escrevo na mesma posicao a cada 10 colunas
	ret
	
preenche_vetor_horizontal:
	sw	t0, 0(s0)
	addi	s0, s0, 4				# se for horizontal escrevo na mesma proxima posicao
	
	ret

loop_matriz:
	lw	a4, (s8)				# carregando matriz de endereços copiada
	
	mv 	a0, a4  				# imprime os valores
	li 	a7, 11
	ecall	
	
	li 	a0, ' '					# imprime espaço para ficar melhor visualmente
	li 	a7, 11
	ecall	
	
	addi	s8, s8, 4				# vou para proxima posicao do vetor copiado
	addi	s3, s3, 1				# autoincremento meu for
	remu	s6, s3, s4				# pego resto da divisão do autoincrementro / 10
	beq	s3, s5, fim				# vejo se o for precisa ser parado
	beqz	s6, print_n				# vejo se o resto do autoincremento / 10 = 0 para adicionar \n
	j 	loop_matriz				# percorro o proximo elemento
	
print_n:

	li 	a0, '\n'				# printo \n
	li 	a7, 11
	ecall	
	j 	loop_matriz				#volto pra matriz
	
fim:

	nop
	
