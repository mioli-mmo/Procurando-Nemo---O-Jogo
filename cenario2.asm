.text

#-----------------------------------------------------------------

# Autor: Mateus Miranda de Oliveira

#-----------------------------------------------------------------

# -- INFORMAÇÕES GERAIS --
# $9 = endereço
# $10 = cor
# $24 = i
# $25 = condição

# UG = Unidade Gráfica

#-----------------------------------------------------------------

main:
# -- ETAPA 1: FUNDO AZUL ESCURO --
lui $9, 0x1001 # Endereço inicial
li $10, 0x17212e # Cor azul escuro

# Loop para preencher fundo
loop1Info:
addi $24, $0, 8191 # i = 8191

loop1Start:
beq $24, $0, loop1End # branch if i == 0; condição de parada (total de unidades gráficas)
sw $10, 0($9) # cor $10 --> endereço $9

addi $9, $9, 4 # próxima unidade gráfica
addi $24, $24, -1 # i+= -1
j loop1Start

loop1End:
# Fim do loop1
# -- Fim da etapa 1 --

# -- ETAPA 2: CHÃO DE AREIA --
# Encontrando endereço do ponto X
lui $4, 0x1001
addi $5, $0, 43 # l
addi $6, $0, 128 # L
addi $7, $0, 0 # c
jal EndPxy # Saída --> $2 (Endereço do Ponto X)

add $9, $0, $2 # Endereço ponto X --> $9
li $10, 0xdbd9d3 # Cor da areia

# Loop para chão de areia
loop2Info:
# $9 se comporta como i
li $25, 0x10018000 # Condição de parada (endereço do último ponto)

loop2Start:
beq $9, $25, loop2End
sw $10, 0($9) # Cor $10 --> Endereço $9
addi $9, $9, 4 # Próxima unidade gráfica
j loop2Start

loop2End:
# Fim do loop2
# -- Fim da etapa 2 --

# -- ETAPA 3: BOMBAS AZUL ESCURO (BAE)
# BAE 1
lui $4, 0x1001
addi $5, $0, 0 # l
addi $6, $0, 128 # L
addi $7, $0, 32 # c
jal EndPxy # Saída --> $2
add $9, $0, $2 # &pX --> $9

li $10, 0x101823 # Cor BAE

# BAE 1 - loop linha vertical
loop3Info:
addi $24, $0, 42 # i = 42

loop3Start:
beq $24, $0, loop3End
sw $10, 0($9)

addi $9, $9, 512 # UG abaixo
addi $24, $24, -1 # i += -1
j loop3Start

loop3End:
# Fim do loop3

# BAE 1 - base horizontal
addi $9, $9, -4 # volta uma UG
sw $10, 0($9)
addi $9, $9, 4
sw $10, 0($9)
addi $9, $9, 4
sw $10, 0($9)

# Fim da BAE 1

# BAE 2
lui $4, 0x1001
addi $5, $0, 0 # l
addi $6, $0, 128 # L
addi $7, $0, 100 # c
jal EndPxy # Saída --> $2
add $9, $0, $2 # &pX --> $9

# BAE 2 - loop linha vertical
loop4Info:
addi $24, $0, 42 # i = 42

loop4Start:
beq $24, $0, loop4End
sw $10, 0($9)

addi $9, $9, 512 # UG abaixo
addi $24, $24, -1 # i += -1
j loop4Start

loop4End:
# Fim do loop4

# BAE 2 - base horizontal
addi $9, $9, -4 # volta uma UG
sw $10, 0($9)
addi $9, $9, 4
sw $10, 0($9)
addi $9, $9, 4
sw $10, 0($9)

# Fim da BAE 2

# BAE 3
# BAE 3 - Corpo
# encontrando endereço do ponto X
lui $4, 0x1001
addi $5, $0, 10 # l
addi $6, $0, 128 # L
addi $7, $0, 50 # c
jal EndPxy # Saída --> $2
add $9, $0, $2 # &pX --> $9

li $10, 0x101823 # cor BAE

# BAE 3 - loop corpo

# ---------- CÓDIGO CONTIDO A SEGUIR: cria um triângulo a partir de um ponto superior central. código reutilizável. ----------

Loop5Info:
addi $11, $0, 4 # contador
addi $12, $0, 512 # endereço inicial linha abaixo
addi $13, $0, 1 # i inicial OBS.: i final = 9

add $24, $0, $13 # i = $13

cicloA: # parte de cima
beq $11, $0, cicloAFinal # condição para iniciar ciclo B (contador == 0)

beq $24, $0, linhaAbaixoA
sw $10, 0($9)
addi $9, $9, 4

addi $24, $24, -1 # i += -1
j cicloA

linhaAbaixoA:
addi $12, $12, -8 # voltando duas UG
add $9, $9, $12
addi $13, $13, 2 # i = (1 --> 3 --> 5 --> 7)
add $24, $0, $13 # i = $13
addi $11, $11, -1 # contador += -1

j cicloA

cicloAFinal:
addi $9, $9, 8 # avançando duas UG

# ---------- CÓDIGO CONTIDO ACIMA: cria um triângulo a partir de um ponto superior central. código reutilizável. ----------

cicloB: # parte de baixo
addi $24, $0, 5

loop6Start:
beq $24, $0, loop6End

sw $10, 0($9)
addi $9, $9, 4
addi $24, $24, -1
j loop6Start

loop6End:
addi $24, $0, 3
addi $9, $9, 496 # linha abaixo

loop7Start:
beq $24, $0, loop7End

sw $10, 0($9)
addi $9, $9, 4
addi $24, $24, -1
j loop7Start

loop7End:
addi $9, $9, 504
sw $10, 0($9)

# BAE 3 - linha vertical
loop8Info:
addi $24, $0, 27 # i = 30

loop8Start:
beq $24, $0, loop8End
sw $10, 0($9)

addi $9, $9, 512 # UG abaixo
addi $24, $24, -1 # i += -1
j loop8Start

loop8End:
# Fim do loop8

# -- ETAPA 4: ROCHAS --

# Rocha esquerda

# Encontrando endereço do ponto X
lui $4, 0x1001
addi $5, $0, 35 # l
addi $6, $0, 128 # L
addi $7, $0, 16 # c
jal EndPxy # Saída --> $2 (Endereço do Ponto X)
add $9, $0, $2 # Endereço ponto X --> $9

li $10, 0x4a4f55 # cor rocha
addi $11, $0, 8 # contador
addi $12, $0, 512 # endereço inicial linha abaixo
addi $13, $0, 1 # i inicial OBS.: i final = 9

add $24, $0, $13 # i = $13

cicloA2: # parte de cima
beq $11, $0, cicloA2Final # condição para iniciar ciclo B (contador == 0)

beq $24, $0, linhaAbaixo2
sw $10, 0($9)
addi $9, $9, 4

addi $24, $24, -1 # i += -1
j cicloA2

linhaAbaixo2:
addi $12, $12, -8 # voltando duas UG
add $9, $9, $12
addi $13, $13, 2 # i = (1 --> 3 --> 5 --> 7)
add $24, $0, $13 # i = $13
addi $11, $11, -1 # contador += -1

j cicloA2

cicloA2Final:
addi $9, $9, 8 # avançando duas UG

cicloB2: # parte de baixo

addi $24, $0, 13

loop9Start:
beq $24, $0, loop9End

sw $10, 0($9)
addi $9, $9, 4
addi $24, $24, -1
j loop9Start

loop9End:
addi $9, $9, 468 # linha abaixo
addi $24, $0, 9

loop10Start:
beq $24, $0, loop10End

sw $10, 0($9)
addi $9, $9, 4
addi $24, $24, -1
j loop10Start

loop10End:

# Rocha direita

# Encontrando endereço do ponto X
lui $4, 0x1001
addi $5, $0, 31 # l
addi $6, $0, 128 # L
addi $7, $0, 70 # c
jal EndPxy # Saída --> $2 (Endereço do Ponto X)
add $9, $0, $2 # Endereço ponto X --> $9

addi $11, $0, 12 # contador
addi $12, $0, 512 # endereço inicial linha abaixo
addi $13, $0, 1 # i inicial OBS.: i final = 9

add $24, $0, $13 # i = $13

cicloA3: # parte de cima
beq $11, $0, cicloA3Final # condição para iniciar ciclo B (contador == 0)

beq $24, $0, linhaAbaixo3
sw $10, 0($9)
addi $9, $9, 4

addi $24, $24, -1 # i += -1
j cicloA3

linhaAbaixo3:
addi $12, $12, -8 # voltando duas UG
add $9, $9, $12
addi $13, $13, 2 # i = (1 --> 3 --> 5 --> 7)
add $24, $0, $13 # i = $13
addi $11, $11, -1 # contador += -1

j cicloA3

cicloA3Final:
addi $9, $9, 8 # avançando duas UG

addi $24, $0, 21

# parte de baixo
loop11Start:
beq $24, $0, loop11End
sw $10, 0($9)
addi $9, $9, 4
addi $24, $24, -1
j loop11Start

loop11End:
addi $9, $9, 436 # linha abaixo
addi $24, $0, 17

loop12Start:
beq $24, $0, loop12End
sw $10, 0($9)
addi $9, $9, 4
addi $24, $24, -1
j loop12Start

loop12End:
addi $9, $9, 456 # linha abaixo
addi $24, $0, 13

loop13Start:
beq $24, $0, loop13End
sw $10, 0($9)
addi $9, $9, 4
addi $24, $24, -1
j loop13Start

loop13End:

# -- ETAPA 5: BOMBAS DA FRENTE (BF) --

# BF esquerda - corpo
# Encontrando endereço do ponto X
lui $4, 0x1001
addi $5, $0, 2 # l
addi $6, $0, 128 # L
addi $7, $0, 12 # c
jal EndPxy # Saída --> $2 (Endereço do Ponto X)
add $9, $0, $2 # Endereço ponto X --> $9

li $10, 0x9ca5af # cor BF

loop14Info:
addi $11, $0, 6 # quantidade de linhas (contador)
addi $13, $0, 1 # i inicial
addi $14, $0, 0 # endereço ref (referência para o salto de linha)

add $24, $0, $13 # declarando i

preLoop14:
add $14, $0, $9 # $14 <-- $9

loop14Start:
beq $11, $0, loop14End # confere se chegou ao fim do loop
beq $24, $0, linhaAbaixo14 # confere se cheogu ao fim da linha

sw $10, 0($9)
addi $9, $9, 4

addi $24, $24, -1
j loop14Start

linhaAbaixo14:
addi $14, $14, 508 # desce e volta uma UG no endereço ref
add $9, $0, $14 # $9 <-- $14

addi $13, $13, 2 # i inicial + 2
addi $11, $11, -1 # contador -1

add $24, $0, $13 # redeclarando i
j preLoop14

loop14End:

loop15Info:
addi $9, $9, 8 # avança dois pixeis
addi $11, $0, 6 # quantidade de linhas (contador)
addi $13, $13, -4 # i inicial
# endereço de ref é o último registrado em $14

add $24, $0, $13 # declarando i
# addi $14, $14, 516 # desce e avança uma UG

preLoop15:
add $14, $0, $9 # $14 <-- $9

loop15Start:
beq $11, $0, loop15End # confere se chegou ao fim do loop
beq $24, 0, linhaAbaixo15 # confere se cheogu ao fim da linha
beq $24, -1, linhaAbaixo15 # último caso: i = -1

sw $10, 0($9)
addi $9, $9, 4

addi $24, $24, -1
j loop15Start

linhaAbaixo15:
addi $14, $14, 516 # desce e avança uma UG
add $9, $0, $14 # $9 <-- $14

addi $13, $13, -2 # i inicial - 2
addi $11, $11, -1 # contador -1

add $24, $0, $13 # redeclarando i
j preLoop15

loop15End:

# BF Esquerda - linha vertical
loop16Info:
addi $9, $9, -520
addi $24, $0, 51

loop16Start:
beq $24, $0, loop16End
sw $10, 0($9)

addi $9, $9, 512 # UG abaixo
addi $24, $24, -1 # i += -1
j loop16Start

loop16End:

# BF direita - corpo
# Encontrando endereço do ponto X
lui $4, 0x1001
addi $5, $0, 10 # l
addi $6, $0, 128 # L
addi $7, $0, 114 # c
jal EndPxy # Saída --> $2 (Endereço do Ponto X)
add $9, $0, $2 # Endereço ponto X --> $9

loop17Info:
addi $11, $0, 5 # quantidade de linhas (contador)
addi $13, $0, 1 # i inicial
addi $14, $0, 0 # endereço ref (referência para o salto de linha)

add $24, $0, $13 # declarando i

preLoop17:
add $14, $0, $9 # $14 <-- $9

loop17Start:
beq $11, $0, loop17End # confere se chegou ao fim do loop
beq $24, $0, linhaAbaixo17 # confere se cheogu ao fim da linha

sw $10, 0($9)
addi $9, $9, 4

addi $24, $24, -1
j loop17Start

linhaAbaixo17:
addi $14, $14, 508 # desce e volta uma UG no endereço ref
add $9, $0, $14 # $9 <-- $14

addi $13, $13, 2 # i inicial + 2
addi $11, $11, -1 # contador -1

add $24, $0, $13 # redeclarando i
j preLoop17

loop17End:

loop18Info:
addi $9, $9, 8 # avança dois pixeis
addi $11, $0, 5 # quantidade de linhas (contador)
addi $13, $13, -4 # i inicial
# endereço de ref é o último registrado em $14

add $24, $0, $13 # declarando i
# addi $14, $14, 516 # desce e avança uma UG

preLoop18:
add $14, $0, $9 # $14 <-- $9

loop18Start:
beq $11, $0, loop18End # confere se chegou ao fim do loop
beq $24, 0, linhaAbaixo18 # confere se cheogu ao fim da linha
beq $24, -1, linhaAbaixo18 # último caso: i = -1

sw $10, 0($9)
addi $9, $9, 4

addi $24, $24, -1
j loop18Start

linhaAbaixo18:
addi $14, $14, 516 # desce e avança uma UG
add $9, $0, $14 # $9 <-- $14

addi $13, $13, -2 # i inicial - 2
addi $11, $11, -1 # contador -1

add $24, $0, $13 # redeclarando i
j preLoop18

loop18End:

# BF direita - linha vertical
loop19Info:
addi $9, $9, -520
addi $24, $0, 45

loop19Start:
beq $24, $0, loop19End
sw $10, 0($9)

addi $9, $9, 512 # UG abaixo
addi $24, $24, -1 # i += -1
j loop19Start

loop19End:

# -- FIM DO PROGRAMA --
ProgramEnd:
addi $2, $0, 10
syscall

#-----------------------------------------------------------------

# Rotina para calcular endereço de um ponto (l,c)
# Entrada: $4 &p0
#	   $5 l	
#	   $6 L
# 	   $7 c
# Saída:   $2
# Usa (sem preservar): $8
# Obs.: não checa parametros
EndPxy: mul $8,$5,$6 # $8 = l * L
	add $8,$8,$7 # $8 = l * L + c
	sll $8,$8,2  # $8 = (l * L + c) * 4
	add $2,$8,$4 # $2 = $8 + &p0
fimEPxy:jr $31       # Fim da rotina
