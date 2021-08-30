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
	li  	t1, '\n'			# grava \n
	li  	t2, '\0'			# grava eof
	jal	insere_embarcacoes		# chama função insere_embarcacoes:


insere_embarcacoes:  
	beq   	t0, t1, loop_find_eof 		# verifica se possui \n para proxima interacao
	jal	loop_all_caracters		# percorre toda a string
	



loop_find_eof:

	la      a0, n
	li 	a7, 4
	ecall	
	lbu  	t0, (a1)			# estende endereco de memoria atual de a1 para t0
	jal insere_embarcacoes			# volta para inserir embarcacoes
	
loop_all_caracters:
	lbu  	t0, (a1)			# estende endereco de memoria atual de a1 para t0
	addi 	a1, a1, 1			# pula 1 endereco de memoria, aqui por ser string cada posicao tem 8 bits
	
	addi 	s9, a1, 1			# verifica se esta no final da string \0 para evitar loop infinito
	lbu  	s10, (s9)
	beq   	s10, t2, fim 
	
	mv 	a0, a1  			# imprime para ver como esta percorrendo
	li 	a7, 4
	ecall	
	
	jal insere_embarcacoes			#se nao continua percorrendo 
fim:
	nop
	