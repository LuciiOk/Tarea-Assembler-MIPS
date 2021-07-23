.data
    cadenatranspuesta: .space 25
    cadena: .space 25
    largo: .word 0
    msgError: .asciiz "Largo de cadena invalida"

.text
.globl main
main:
# registros para condiciones    
    li $t0,9
    li $t1,16
    li $t2,25

#cargar variables en registros
    la $a0,cadena
    
# leer string
    addi $v0,$zero,8
    syscall

#----------------------------------------- validacion del string ----------------------------------------------------#
    bne $a1,$t0,sino                   # condicion largo de string leido distinto de 9
si:
    addi $t0,$zero,3
    j finsi
sino:
    bne $a1,$t1,sino2                    # condicion largo de string leido distinto de 16
si2:
    addi $t0,$zero,4
    j finsi
sino2:
    bne $a1,$t2,sino3                      # condicion largo de string leido distinto de 25
si3:
    addi $t0,$zero,5
    j finsi
sino3:
    la $a0,msgError                # se carga en registro a0 mensaje de error 
    addi $v0,$zero,4                
    syscall                               #se muestra mensaje de error
    j finprograma                  # salto a fin del programa
finsi:
    add $t1,$zero,$a1         # largo del string leido
    addi $t2,$zero,0           # i = 0
    addi $t3,$zero,0           # j = 0
    addi $t4,$zero,0           # k = 0

    la $t5,cadena
    la $t6,cadenatranspuesta

# ----------------------------------- algoritmo matriz inversa del string ----------------------------------------------------------------- # 
mientras:
    beq $a1,$t2,finmientras            # mientras a1 <> t2 se siguee con el ciclo

    beq $t0,$t3,simientras
    j finsimientras
    simientras:
        addi $t3,$zero,0           # j = 0
        addi $t4,$t4,1             # k++
    finsimientras: 
    
    # en base a la formula filas * n columnas + columna

    mult $t3,$t0                  # se cambia las variables de fila por columna y columna por filas y se hace la multiplicacion
    mflo $t8                     # se obtine el valor de la multiplicacion
    add $t8,$t8,$t4              # se suma la fila j del recorrido con la multiplicacion entre columna * n columnas

    lb $t7,($t5)                   # almacena en registro t7 la letra de la cadena
    add $t6,$t6,$t8
    sb $t7,($t6)                # carga la letra del registro t7 en puntero a letra
    sub $t6,$t6,$t8

    addi $t3,$t3,1            # se incrementa en una unidad
    addi $t5,$t5,1            # se pasa al siguiente caracter de la cadena leida
    addi $t2,$t2,1             # se aumenta el valor de i en una unidad

    j mientras
finmientras:

#--------------------------------- se imprime la nueva cadena generada ------------------------------#
    la $a0,cadenatranspuesta 
    li $v0,4
    syscall

#--------------------------------------------fin  del programa -------------------------------------------------#
finprograma:
    addi $v0,$zero,10
    syscall