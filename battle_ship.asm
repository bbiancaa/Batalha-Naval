.data

msg_comum:						.asciz "Entre com o valor de "
ships:							.asciz "3\n1511\n0522\n0164"
n:							.asciz "\n"	
lines:							.word 10
columns:						.word 10

.text
main:
	la	a1, ships				# lê endereço do vetor
	la	s0, lines
	la 	s1, columns
	add	s3, s3, zero
	
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
	mv 	a0, t0  				# imprime para ver qual é a posicao atual
	li 	a7, 11
	ecall	
	
	j insere_na_vertical				# funcao recursiva para percorrer toda a linha
	
loop_all_caracters:

	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	addi 	a1, a1, 1				# pula 1 endereco de memoria, aqui por ser string cada posicao tem 8 bits
	
	
	beq   	t0, t1, loop_find_eof 			# verifica se possui \n para proxima interacao
	
	beq   	t0, t2, fim 				# verifica se endereço atual é \0 e encerra for
	
	ret

preenche_vetor_vertical:
	sw	t0, (s1)
	addi	s1, s1, 4
	ret
	
preenche_vetor_horizontal:
	sw	t0, (s0)
	addi	s0, s0, 4
	ret
fim:
	nop
	
