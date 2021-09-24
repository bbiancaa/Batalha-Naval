.data

ships:							.asciz 	"3 \n 1 5 1 1 \n 0 5 2 2 \n 0 1 6 4 "
error:							.asciz 	"Entrada invalida"
error_sobreposicao:					.asciz  "Sobreposição nos navios"
error_tam:						.asciz  "O navio extrapola as dimensões da matriz"
columns:						.asciz 	"0 1 2 3 4 5 6 7 8 9\n"
lines:							.asciz 	"0\n1\n2\n3\n4\n5\n6\n7\n8\n9"
n:							.asciz 	"\n"
matriz:							.word 	100 #pensando em uma maneira diferente de salvar os valores
.text
main:
	la	a1, ships				# lê endereço do vetor
	add	s3, s3, zero				# autoincrement para for de printar
	addi	s4, s4, 10				# valor para adicionar \n
	addi	s5, s5, 100				# tamanho da matriz
	addi	t6, t6, 4				# para coluna
	
	add	s1, s1, zero				# contador para linha
	lbu  	s2, (a1)				# pego valor primeira posicao = quantidade de navios	
	addi	a1, a1, 4				# pula 2 caracter pois informacao necessaria ja adqurida na primeira linha
	
	li  	t1, '\n'				# grava \n
	li  	t2, '\0'				# grava eof
	li  	t3, '0'					# horizontal
	li  	t4, '1'					# vertical
	li  	s11, 'A'	 
	j	insere_embarcacoes			# chama função insere_embarcacoes:
	
verifica_vazio:
	addi 	a6, zero, 32
	
	
	addi 	a1, a1, 1				# pula 1 endereco de memoria, aqui por ser string cada posicao tem 8 bits
	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	bne	t0, a6, fim_error			# verifica se proxima posicao n for ' ' printa erro
	addi 	a1, a1, 1				# pula 1 endereco de memoria, se for espaco na posicao atual
	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	ret

verifica_tam:
	addi 	a6, zero, 10
	add	s7, a2, a4
	bgt  	s7, a6, fim_error_tam
	add	s7, a2, a3
	bgt  	s7, a6, fim_error_tam
	ret

insere_embarcacoes:
	la	s9, matriz				# le matriz para ser escrita
	addi	s9, s9, 4				# evitando erro de lixo na memoria
	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	
	add	s1, zero, zero				# reseto contador para linha
	beq   	t0, t1, loop_find_eof 			# verifica se possui \n para proxima interacao
	beq   	t0, t2, loop_matriz 			# verifica se endereço atual é \0 vai printar a matriz
	beq	t0, t3, insere_na_horizontal		# insere navio na horizontal
	beq	t0, t4, insere_na_vertical		# insere navio na vertical
	
	addi 	a1, a1, 1				# pula 1 endereco de memoria, aqui por ser string cada posicao tem 8 bits
	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	j	insere_embarcacoes


loop_find_eof:
	addi	s11, s11, 1  
	addi 	a1, a1, 1				# pula 1 endereco de memoria, aqui por ser string cada posicao tem 8 bits
	lbu  	t0, (a1)				# estende endereco de memoria atual de a1 para t0
	j	insere_embarcacoes
	
	

insere_na_horizontal:
	
	jal	verifica_vazio
	add	a2, a2, zero				# tamanho do navio
	addi 	a2, t0, -48				# coloca o tamanho do navio lido na linha converte pra int e grava
	
	jal	verifica_vazio
	add	a3, a3, zero				# linha do navio
	addi	a3, t0, -48				# coloca a linha inicial do navio lido na linha converte pra int e grava
	
	jal	verifica_vazio
	add	a4, a4, zero				# coluna do navio
	addi	a4, t0, -48				# coloca o coluna inicial do navio lido na linha converte pra int e grava
	
	mul	t5, a3, s4				# multiplico pra ter a coluna inicial
	add	a5, t5, a4				# somo a coluna com a linha pra saber posicao na matriz
	mul	a5, a5, t6				# multiplco * 4 para ter posicao na memoria correta
	
	jal	verifica_vazio
	add	s9, s9, a5
	jal	verifica_tam
	j	preenche_vetor_horizontal
	

insere_na_vertical:

	
	jal	verifica_vazio
	
	add	a2, a2, zero				# tamanho do navio
	addi 	a2, t0, -48				# coloca o tamanho do navio lido na linha converte pra int e grava
	
	
	
	jal	verifica_vazio
	add	a3, a3, zero				# linha do navio
	addi	a3, t0, -48				# coloca o linha inicial do navio lido na linha converte pra int e grava
	
	
	
	jal	verifica_vazio
	add	a4, a4, zero				# coluna do navio
	addi	a4, t0, -48				# coloca o coluna inicial do navio lido na linha converte pra int e grava
	
	
	mul	t5, a3, s4				# multiplico pra ter a coluna inicial
	add	a5, t5, a4				# somo a coluna com a linha pra saber posicao na matriz
	mul	a5, a5, t6				# multiplco * 4 para ter posicao na memoria correta
	
	
	jal	verifica_vazio
	add	s9, s9, a5
	jal 	verifica_tam
	j	preenche_vetor_vertical
	
preenche_vetor_vertical:
	beq	s1, a2, insere_embarcacoes		# se o tamanho do navio ja tiver completo
	addi	s1, s1, 1	
	
	lw 	a6, 0(s9)				# pega valor em s9
	bne	a6, zero, fim_error_choque		# se valor diferente de 0 ja existe navio entao choque de navios
	sw	s11, 0(s9)
	
	addi	s9, s9, 40				# se for vertical escrevo na mesma posicao a cada 10 colunas
	
	
	j	preenche_vetor_vertical
	
preenche_vetor_horizontal:
	beq	s1, a2, insere_embarcacoes		# se o tamanho do navio ja tiver completo
	addi	s1, s1, 1				# auto incremento
	sw	s11, 0(s9)
	addi	s9, s9, 4				# se for horizontal escrevo na proxima posicao
	j	preenche_vetor_horizontal


header:
	la	s7, columns				# le matriz para ser printada
	mv 	a0, s7  				# imprime os valores
	li 	a7, 4
	ecall	
	
	addi	s3, s3, 1				# autoincremento meu for
	j loop_matriz
	
loop_matriz:
	beqz	s3, header
	lw	a6, (s9)				# carregando matriz de endereços copiada
	
	mv 	a0, a6  				# imprime os valores
	li 	a7, 11
	ecall	
	
	li 	a0, ' '					# imprime espaço para ficar melhor visualmente
	li 	a7, 11
	ecall	
	
	addi	s9, s9, 4				# vou para proxima posicao do vetor copiado
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
	
		
fim_error:
	la	s7, error				# le erro
	mv 	a0, s7  				# imprime os vetor de char
	li 	a7, 4
	ecall	
	j	fim
	
fim_error_choque:

	la 	s7, error_sobreposicao				# le erro
	mv 	a0, s7  				# imprime os vetor de char
	li 	a7, 4
	ecall	
	j	fim
	
fim_error_tam:

	la 	s7, error_tam				# le erro
	mv 	a0, s7  				# imprime os vetor de char
	li 	a7, 4
	ecall	
	j	fim
	
fim:
	nop
