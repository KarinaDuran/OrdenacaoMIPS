###############################################################################################################################
###############################################################################################################################
#####                                                                                                                     #####
#####                Nome: Karina Duran Munhos                                 Numero: 11295911                           #####
#####                Exercicio-Programa 1                                                                                 #####
#####                Arquitetura de Computadores                               Turma: 94                                  #####
#####                                                                                                                     #####
###############################################################################################################################
###############################################################################################################################

###############################################################################################################################
.data                                                         
#Espaco para o nome do arquivo inserido 
StringArquivo:.ascii ""
       
#Espaco para o arquivo convertido para ser utilizado 
Arquivo:.space 70
        .align 0
########################################################################################## 

#espaco para o conteudo do arquivo 
buffer: .space 1024
        .align 2
        
#espaco para o arquivo convertido em inteiros
buffer2: .space 2048
         .align 2
         
#espaco para o array de inteiros convertidos para string para serem escritos no arquivo
buffer3: .space 2048
         .align 0
         
#mensagens ao usuario: 
Mensagem1: .asciiz "Insira o nome do arquivo .txt a ser ordenado\n"
Mensagem2: .asciiz "\nQual o algoritmo de ordenação? (0 - QuickSort, 1 - Insertion sort) \n"
Mensagem3: .asciiz "\nNumeros ordenados:\n"

#####################################################################################################################
################################################# INICIO DO MAIN ####################################################
.text
.globl main
main:

li $v0, 4
la $a0, Mensagem1 #Imprime a mensagem que pede o nome do arquivo
syscall 

li $v0, 8
la $a0, StringArquivo  #le a string inserida pelo usuario 
li $a1, 70
syscall

la $a0, StringArquivo
la $a1, Arquivo
################ Chama a funcao para converter para nome de arquivo #####################
subi $sp, $sp, 8
sw $ra, 0 ($sp)
sw $fp, 4 ($sp)
move $fp, $sp

jal converterNome

lw $fp, 4 ($sp)
lw $ra, 0 ($sp)
addi $sp, $sp, 8

############################# Fim da chamada ############################################
#########################################################################################


#########################################################################################
############################ Abertura e leitura do arquivo ##############################

li   $v0, 13       # Abrir arquivo
la   $a0, Arquivo  # Nome do arquivo
li   $a1, 0        # 0 para ler, 1 para escrever
li   $a2, 0        # Modo é ignorado
syscall            
move $s0, $v0      # Salva o conteúdo do arquivo em $s0 


li   $v0, 14       # Ler o arquivo 
move $a0, $s0      # Conteudo do arquivo  
la   $a1, buffer   # Endereco onde esse conteudo vai ficar armazenado
li   $a2, 1024    # Tamanho do endereco 
syscall            
move $s1,$v0       # Salva o numero de caracteres lidos em $s1

li $v0, 16         # Fecha arquivo
move $a0, $s0      
syscall

############################# Fim de abertura de arquivo ################################
#########################################################################################


#########################################################################################
##################### Chamar funcao para converter o arquivo ############################

move $a0, $s1        # Numeros de caracteres a se converter 
la $a1, buffer
la $a2, buffer2

subi $sp, $sp, 8
sw $fp, 0($sp)
sw $ra, 4 ($sp)      # Salva o retorno
move $fp, $sp

jal converterString  # Chama o metodo

move $s3, $v0        # $s3 recebe o tamanho do array convertido

lw $fp, 0($sp) 
lw $ra, 4 ($sp)      # Recupera o retorno
addi $sp, $sp, 8

############################# Fim da conversao ##########################################
#########################################################################################



# Mensagem ao usuario #
li $v0, 4
la $a0, Mensagem2 #Pergunta qual e o tipo de ordenacao a ser utilizada
syscall


#########################################################################################
##################### Chamar funcao para ordenar o array ################################

#Recebe do usuario o tipo de ordenacao
li $v0, 5
syscall
move $s4, $v0      # $s4 recebe o tipo de ordenacao a ser implementada

slti $s7, $s4, 2
beq $s7, $zero, fim
slti $s7, $s4, 0
bne $s7, $zero, fim


subi $sp, $sp, 8
sw $fp, 0($sp)
sw $ra, 4 ($sp)    # Salva o retorno
move $fp, $sp

la $a0, buffer2    # $a0 e o array convertido
move $a1, $s3      # $a1 e o tamanho do array
move $a2, $s4      # $a2 e o tipo de ordenacao

jal ordena         # Chama a funcao

move $s5, $v0      # Recebe o retorno da funcao (o tamanho do array resultante)

lw $fp, 0($sp)
lw $ra, 4 ($sp)    # Recupera o retorno
addi $sp, $sp, 8

########################### Fim da chamada para ordenacao ###############################
#########################################################################################


#########################################################################################
###################### Chama metodo para conversao para String ##########################

la $a0, buffer3      # $a0 = endereco do buffer que o array convertido ficara
move $a1, $s5        # $a1 = tamanho do array de inteiros
la $a2, buffer2      # $a2 = endereco onde o array de inteiros esta

subi $sp, $sp, 8
sw $fp, 0($sp)
sw $ra, 4 ($sp)      # Salva retorno
move $fp, $sp

jal converterArray   # Chama a funcao (void)

lw $fp, 0($sp)
lw $ra, 4 ($sp) #recupera o retorno
addi $sp, $sp, 8

#########################################################################################
############################### Escrever no arquivo #####################################

li   $v0, 13         # Abrir arquivo
la   $a0, Arquivo    # Nome do arquivo para saida
li   $a1, 1          # 1 para escrever no arquivo
li   $a2, 0          # Modo eh ignorado
syscall           
move $s6, $v0        #Salva o conteudo do arquivo

li   $v0, 15         # Escrever no arquivo
move $a0, $s6      
la   $a1, buffer     # Endereco do conteudo do que sera escrito (conteudo original)
move $a2, $s1        # Numero de bytes lidos no inicio 
syscall            
  
li $v0, 15           # Escrever no arquivo
move $a0, $s6
la $a1, Mensagem3    # Mensagem a ser escrita no arquivo
li $a2, 20           # Tamanho da mensagem em bytes
syscall
  
li $v0, 15           # Escrever no arquivo
move $a0, $s6
la $a1, buffer3      # Numeros ordenados 
move $a2, $s1        # Numero de bytes lidos no inicio
syscall
 
li   $v0, 16         # Fecha o arquivo
move $a0, $s6      
syscall            
########################## Fim da inscricao no arquivo ##################################
#########################################################################################

fim:
li $v0, 10 # Encerra o programa
syscall

########################################################################################################################
#############################FIM DO METODO MAIN, A BAIXO TODAS AS FUNCOES USADAS ####################################### 
######################################################################################################################## 

#-----------------------------------------------------------------------------------------------------------------------#
###################### Funcao para converter o nome inserido ##############################
# Funcao que retira caracteres de fim de linha (0xA) e acrescenta um caractere NULL no    #
# fim para converter a String recebida em um nome de arquivo                              #
###########################################################################################
.globl converterNome
converterNome:
subi $sp, $sp, 16
sw $t0, 0 ($sp)
sw $t1, 4($sp)
sw $t2, 8($sp)
sw $t3, 12($sp)

move $t0, $a0   # Pega o endereco da String nao convertida pra nome
move $t1, $a1   # Pega o endereco do destino da String convertida

li $t3, 0x0     # NULL

loopNome:
lb $t2,($t0)
beq $t2, 0XA, fimNome    # Quando chega no caractere 0xA, vai para o fim
sb $t2,($t1)		 # Salva o char lido no endereco destino
addi $t1, $t1, 1         # Proximo byte
addi $t0, $t0, 1	 # Proximo byte
j loopNome

fimNome: 
sb $t3,($t1)            #adiciona NULL no fim da String gerada

lw $t3, 12($sp)
lw $t2, 8 ($sp)
lw $t1, 4 ($sp)
lw $t0, 0($sp)
addi $sp, $sp, 16

jr $ra 
#################### Fim da funcao para converter o nome inserido #######################
#########################################################################################

#-----------------------------------------------------------------------------------------------------------------------#

##################### Converter String para array de inteiro ############################
# Essa funcao armazena no buffer2 o vetor de inteiros e retorna o tamanho do vetor      #
# contido em $t6                                                                        #
#########################################################################################
.globl converterString
converterString:
subi $sp, $sp, 24
sw $t0, 0 ($sp)       # Espaco para os registradores
sw $t1, 4 ($sp) 
sw $t2, 8 ($sp) 
sw $t3, 12 ($sp)
sw $t4, 16 ($sp)
sw $t5, 20 ($sp)
sw $t6, 24 ($sp)

move $t0, $a1         # Endereco de onde o arquivo nao convertido esta
move $t1, $a2         # Endereco destino
li $t2, 0             # Contador de bytes
li $t3, 0             # Numero convertido (inicialmente 0)
li $t6, 0             # Tamanho do array

lerByte:   
slt $t5, $t2, $a0 
beq $t5, $zero, fimConverterString  # Se ja se leu todos os bytes, pula para o fim
lb $t4, ($t0)
beq $t4, 0xA, numero                # Se encontrar o fim da linha (0xA em hexadecimal)
subi $t4, $t4, 0x30                 # Transforma em int
mul $t3, $t3, 10                    # Multiplica o anterior por 10
add $t3, $t3, $t4                   # Soma com o novo int


addi $t0, $t0, 1       # Proximo endereco de byte
addi $t2, $t2, 1       # Contador de bytes recebe +1
j lerByte

# Armazenar o numero em um array
numero:
sw $t3, 0($t1)    # Armazena o numero
addi $t1,$t1,4    # Recebe o endereco para o proximo numero (word)

addi $t6, $t6, 1  # O tamanho recebe +1
addi $t0, $t0, 1  # Proximo endereco de byte
addi $t2, $t2, 1  # Contador de bytes recebe +1
li $t3, 0         # $t3 volta a 0 para o proximo numero

j lerByte

# Quando toda a String estiver convertida:
fimConverterString:
move $v0, $t6    # Retorna o tamanho do array

lw $t5, 20($sp)  # Recupera os registradores
lw $t4, 16($sp)
lw $t3, 12($sp)
lw $t2, 8($sp)
lw $t1, 4($sp)
lw $t0, 0($sp)
addi $sp, $sp, 24

jr $ra          # Retorna ao metodo que foi chamada

###################### Fim da funcao de conversao ############################

#-----------------------------------------------------------------------------------------------------------------------#

############################ Funcao para ordenar um array ################################
# Essa funcao ordena o vetor contido no endereco buffer2 e retorna o tamanho dele.       #
# Recebe como parametro $a0 (array a se ordenar), $a1 (tamanho do array) e $a2 o tipo de #
# ordenacao (1 para InsertionSort, 0 para QuickSort)                                     #
##########################################################################################

.globl ordena
ordena:
subi $sp, $sp, 40
sw $t0, 0($sp) # Espaco para os registradores
sw $t1, 4($sp) 
sw $t2, 8($sp) 
sw $t3, 12($sp)
sw $t4, 16($sp) 
sw $t5, 20($sp)
sw $t6, 24($sp)
sw $t7, 28($sp)
sw $t8, 32($sp)
sw $s1, 36($sp)

move $t8, $a1           # Armazena o tamanho

beq $a2, $zero, QUICK   # Se o parametro $a2 for 0, pula para QuickSort

#----------------------------------------------------------------#

######################## InsertionSort ###########################  

mul $t2, $a1, 4          	# $t2 recebe o tamanho *4 (convertendo para bytes)
li $t0, 4                	# $t0 = i; i=1 

percorrerArray:
slt $t3, $t0, $t2         	# Verifica se i < tamanho
beq $t3, $zero, fimOrdenacao    # Se nao pula para o fim
add $t1, $t0, $a0        	# Calcula endereco de array[i]
lw $t4, 0($t1)           	# $t4 = valor contido em array[i]

subi $t1, $t0, 4         	# $t1 = j; j = i-1

loopInsertion:
slt $t3, $t1, $zero      	# Verifica se j < 0
bne $t3, $zero, linha    	#se sim, pula para linha

add $s1, $t1, $a0        	# Calcula endereco de array[j]
lw $t6, 0($s1)           	# $t6 = valor contido em array[j]
slt $t7, $t4, $t6        	# Verifica se array[j] < array[i] 
beq $t7, $zero, linha    	# Se nao, pula pra linha

addi $t1, $t1, 4         	# j recebe +1
add $s1, $t1, $a0        	# Calcula endereco de array[j+1]
sw $t6, 0($s1)           	# array[j+1] = array[j]
subi $t1, $t1, 8         	# j+1-2 = j-1

j loopInsertion          	# Retorna ao loop

linha: 
addi $t1, $t1, 4         	# Recebe o endereco do proximo j
add $s1, $t1, $a0        	# Calcula endereco do proximo j
sw $t4, 0($s1)           	# Armazena array [i] no endereco
addi $t0, $t0, 4         	# i recebe +1
j percorrerArray         	# Retorna ao percorrerArray

#-----------------------------------------------------------------#

########################### QuickSort #############################

QUICK:
# $a0 eh o vetor
subi $t0, $a1, 1 	 # Tamanho-1 (direita)
li $a1, 0                # 0 (esquerda)
move $a2, $t0            

subi $sp, $sp 8
sw $ra, 0 ($sp)  	# Salva retorno
sw $fp, 4 ($sp)
move $fp, $sp

jal quickSort  		# Chama a funcao auxiliar QuickSort

lw $fp, 4($sp)          # Recupera retorno
lw $ra, 0($sp)
addi $sp, $sp, 8

# Fim do metodo ordenacao
fimOrdenacao: 
move $v0, $t8  		# Retorna o tamanho do array

lw $s1, 36($sp)  	# Recupera os registradores
lw $t8, 32($sp)
lw $t7, 28($sp)
lw $t6, 24($sp)
lw $t5, 20($sp)
lw $t4, 16($sp)
lw $t3, 12($sp)
lw $t2, 8($sp)
lw $t1, 4($sp)
lw $t0, 0($sp)
addi $sp, $sp, 40

jr $ra # Retorna ao metodo em que foi chamada

############################ Fim da funcao de ordenacao ##################################
##########################################################################################

#-----------------------------------------------------------------------------------------------------------------------#

##########################################################################################

############# Funcao para conversao de um vetor de int para string #######################
#   Recebe como parametro o buffer para armazenar a String convertida, o array a se      #
# converter e o tamanho deste.                                                           #           
##########################################################################################

.globl converterArray
converterArray:
# $a0 = endereco destino
# $a1 = tamanho do array
# $a2 = origem
subi $sp, $sp, 68   # Espaco para os registradores
sw $t0, 0($sp) 
sw $t1, 4($sp) 
sw $t2, 8($sp) 
sw $t3, 12($sp)
sw $t4, 16($sp) 
sw $t5, 20($sp)
sw $t6, 24($sp)
sw $t7, 36($sp)
sw $t8, 40($sp)
sw $t9, 44($sp)
sw $s0, 48($sp)
sw $s1, 52($sp)
sw $s2, 56($sp)
sw $s3, 60($sp)
sw $s4, 64($sp)

#########################
move $t0, $a2
move $t9, $a0

# Caracteres especiais #
li $t8, 0xA  # Enter entre os numeros
li $t7, 0x30 # 0 em Hexadecimal

# Para auxilio nas operacoes #
li $t1, 10 

# Contadores #
li $s0, 0 # Contador do tamanho do array
li $s1, 1 # Contador de casas decimais

percorreArray:
slt $t6, $s0, $a1       # Verifica se o contador do array eh menor que o tamanho total
beqz $t6, fimConversao  # Se nao, pula pro final

lw $t2, 0($t0)          # Se sim, carrega em $t2 o valor no indice calculado

move $t3, $t2           # Move o valor pra $t3
li $s2, 1               # O contador de casas decimais do elemento anterior recebe 1

#Loop para isolar cada numero
isolaNumero:
slt $t6, $t3, $t1       # Se o valor for menor que 10 pula para armazenar como char
bne $t6, $zero, char 

div $t3, $t3, $t1       # Se nao, divide por 10
mul $s1, $s1, $t1       # Contador de casas decimais multiplica por 10

j isolaNumero 

# Armazenar o char na String
char:
div $s3, $s2, $s1       # Verifica se existem 0s no numero comparando as casas decimais do elemnto anterior com o atual
slt $t6, $t1, $s3       # Verifica se eh menor 10 (indicando que entre um e outro ha apenas uma casa decimal)
bne $t6, $zero, zero    # Se nao for, pula para o label para acrescentar 0s

mul $s4, $s1, $t3       # Multiplica o numero isolado ($t3) por 10
subu $t2, $t2, $s4      # $t2 (numero original) recebe o valor sem a ultima dezena 

addi $t3, $t3, 0x30    # Converter inteiro para ascii
sb $t3,($t9)            # Armazena o numero isolado no endereco destino
addi $t9, $t9, 1        # Recebe o proximo endereco de byte

move $s2, $s1           # O contador de casa decimal anterior recebe o contador atual
beq $s1, 1, ultimoNumero # Se o contador de casa decimal for 1, pula para o label de ultimo numero
move $t3, $t2           # $t3 recebe $t2 para isolar o numero da ultima dezena novamente
li $s1, 1               # O contador de casas decimais recebe 1 novamente

j isolaNumero           # Pula para o loop de isolamento do numero

# Loop para se acrescentar os zeros
zero:
div $s2, $s2, $t1  	# Divide o contador do anterior por 10
sb $t7,($t9)       	# Armazena 0(ja convertido) no endereco destino  
addi $t9, $t9, 1   	# Recebe proximo endereco de byte

div $s3, $s3, $t1  	# Divide a diferenca de casas decimais por 10
beq $s3, 10, char 	# Se s3 ja for igual a 10, retorna para o loop do char
j zero             	# Se nao, pula de novo pro loop zero
	
# Loop para armazenar quebra de linha
ultimoNumero: 
sb $t8, ($t9)      	# Se for, armazena a quebra de linha
addi $t9, $t9, 1   	# Recebe o proximo endereco de byte
addi $s0, $s0, 1   	# Contador do tamanho do array recebe +1
addi $t0, $t0, 4   	# O array originario recebe endereco para a proxima word
li $s1, 1          	# Contador atual das casas decimais recebe 1

j percorreArray    	# Pula para o proximo numero do array

fimConversao:

lw $t0, 0($sp)  	# Recupera registradores
lw $t1, 4($sp) 
lw $t2, 8($sp) 
lw $t3, 12($sp)
lw $t4, 16($sp) 
lw $t5, 20($sp)
lw $t6, 24($sp)
lw $t7, 36($sp)
lw $t8, 40($sp)
lw $t9, 44($sp)
lw $s0, 48($sp)
lw $s1, 52($sp)
lw $s2, 56($sp)
lw $s3, 60($sp)
lw $s4, 64($sp)
addi $sp, $sp, 68

jr $ra         # Retorna para o metodo em que foi chamada 

############################## fim da funcao converterArray ##############################
##########################################################################################

################### Funcao auxiliar da funcao ordena para o QuickSort ####################
# Funcao recebe como parametro um array e 2 posicoes, chamadas de esquerda e direita, que#
# representam as duas extremidades do array, incicialmente em 0 e tamanho-1,             #
# respectivamente. O pivo escolhido eh a extremidade esquerda.                           #
##########################################################################################

.globl quickSort
quickSort:
subi $sp, $sp, 72 # Espaco para os registradores 
sw $t0, 0($sp) 
sw $t1, 4($sp) 
sw $t2, 8($sp) 
sw $t3, 12($sp)
sw $t4, 16($sp) 
sw $t5, 20($sp)
sw $t6, 24($sp)
sw $t7, 36($sp)
sw $t8, 40($sp)
sw $t9, 44($sp)
sw $s0, 48($sp)
sw $s1, 52($sp)
sw $s2, 56($sp)
sw $s3, 60($sp)
sw $s4, 64($sp)
sw $s5, 68($sp)

# $s1 eh usado para comparacoes

slt $s1, $a1, $a2 # Verifica se esquerda < direita
beq $s1, $zero, fimQuick # Se nao for, pula para o final
#####################################
mul $s4, $a1, 4 # Esquerda
mul $s5, $a2, 4 # Direita

move $t1, $s4 # i = esquerda
move $t2, $s5 # j = direita
move $t3, $s4 # pivo = esquerda

while1: 
slt $s1, $t1, $t2 # Verifica se i < j
beq $s1, $zero, troca # Se nao, pula para o label troca

# Loop para encontrar elemento maior que o pivo partindo de i
while2:
add $t9, $t3, $a0   	# Calculo para encontrar o endereco do pivo
lw $t5,($t9)        	# $t5 = array[pivo]

add $t4, $t1, $a0   	# $t4 eh o endereco 
lw $t6,($t4)        	# $t6 = array[i]

slt $s1, $t5, $t6   	# Verifica se array[i] <= j
bne $s1, $zero, while3 	# Se não, pula para o proximo while


slt $s1, $s5, $t1   	# (&&) Verifica se i <= direita
bne $s1, $zero, while3  # Senao pula para o proximo while

addi $t1, $t1, 4        # i recebe +1

j while2

# Loop para encontrar elemento menor que o pivo partindo de j
while3:
add $t9, $t3, $a0 	# Calculo do endereco do pivo
lw $t5,($t9)            # $t5 = array[pivo]

add $s0, $t2, $a0       # Calculo do endereco de j
lw $t7,($s0)            # $t7 = array[j]

slt $s1, $t5, $t7	# Verifica se array[pivo] < array[j]
beq $s1, $zero, if      # Se nao for, pula para o label denominado if
slt $s1, $t2, $s4       # (&&) Verifica se j >= esquerda
bne $s1, $zero, if      # Se nao for, pula para o label denominado if

subi $t2, $t2, 4        # j recebe +1

j while3

# Trocar os conteudos de array [i] e array [j]
if:
slt $s1, $t1, $t2       # Verifica se i < j
beq $s1, $zero, troca 	# Se nao for, pula para troca

# $t6 eh o aux
sw $t7,($t4)            # array[i] = array [j]
sw $t6,($s0)            # array[j] = array [i]

j while1

# Troca o conteudo de array[pivo] com o de array[j] e chama a funcao quickSort recursivamente
troca:
sw $t7,0($t9)		# array [j] = aux
sw $t5,0($s0)  		# array[pivo] = array [j]

# $a1 e o mesmo (esquerda)
# $a0 e o mesmo (array)
# $a2 recebe j-1
div $t2, $t2, 4  	# j retorna ao valor do inicio
subi $s2, $t2, 1 	# -1 
move $a2, $s2

subi $sp,$sp, 8
sw $ra, 0($sp)      	# Salva retorno
sw $fp, 4($sp)
move $fp, $sp

jal quickSort		# Chama a propria funcao recursivamente

move $sp, $fp          	# Recupera retorno
lw $fp, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 8

# $a0 e o mesmo (array)
# $a1 recebe j+1
addi $s2, $t2, 1        # +1
move $a1, $s2

# $a2 recebe o valor inicial da direita
div $s5, $s5, 4
move $a2, $s5

subi $sp, $sp, 8
sw $ra, 0($sp)  	# Salva retorno
sw $fp, 4($sp)
move $fp, $sp

jal quickSort		# Chama a propria funcao recursivamente

move $sp, $fp		# Recupera retorno
lw $fp, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 8

# Final do QuickSort
fimQuick:
lw $t0, 0($sp) 		# Recupera registradores
lw $t1, 4($sp) 
lw $t2, 8($sp) 
lw $t3, 12($sp)
lw $t4, 16($sp) 
lw $t5, 20($sp)
lw $t6, 24($sp)
lw $t7, 36($sp)
lw $t8, 40($sp)
lw $t9, 44($sp)
lw $s0, 48($sp)
lw $s1, 52($sp)
lw $s2, 56($sp)
lw $s3, 60($sp)
lw $s4, 64($sp)
lw $s5,68($sp)
addi $sp, $sp, 72

jr $ra 			# Retorna ao metodo em que foi chamada

############################# Fim da funcao auxiliar QuickSort ###########################
##########################################################################################
