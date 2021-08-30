.data

msg_comum:	.asciz "Entre com o valor de "
ships:		.asciz "3\n1511\n0522\n0164"
n:			.asciz "\n"	
lines:		.word 10
columns:	.word 10

.text
main:
	la	a1, ships			# lê endereço do vetor
	la	s0, lines
	la 	s1, columns
	add	s3, s3, zero
	
	lbu  	s2, (a1)			# pego valor primeira posicao = quantidade de navios	
	addi	a1, a1, 2			# pula 2 caracter pois informacao necessaria ja adqurida na primeira linha
	
	li  	t1, '\n'			# grava \n
	li  	t2, '\0'			# grava eof
	j	insere_embarcacoes		# chama função insere_embarcacoes:


insere_embarcacoes:  

	beq   	t0, t1, loop_find_eof 		# verifica se possui \n para proxima interacao
	
	beqz	t0, insere_na_horizontal		# insere navio na horizontal
	bgez	t0, insere_na_vertical		# insere navio na vertical
	


loop_find_eof:
	lbu  	t0, (a1)			# estende endereco de memoria atual de a1 para t0
	j	insere_embarcacoes
	
	

insere_na_horizontal:
	beq   	t0, t1, loop_find_eof 		# verifica se possui \n para proxima interacao
	jal	loop_all_caracters


insere_na_vertical:
	beq   	t0, t1, loop_find_eof 		# verifica se possui \n para proxima interacao
	j	loop_all_caracters
	
loop_all_caracters:

	lbu  	t0, (a1)			# estende endereco de memoria atual de a1 para t0
	addi 	a1, a1, 1			# pula 1 endereco de memoria, aqui por ser string cada posicao tem 8 bits
	
	mv 	a0, t0  			# imprime para ver qual é a posicao atual
	li 	a7, 11
	ecall	
	
	
	beq   	t0, t1, loop_find_eof 		# verifica se possui \n para proxima interacao
	
	beq   	t0, t2, fim 			# verifica se endereço atual é /0 e encerra se for
	
	ret
fim:
	nop
	
