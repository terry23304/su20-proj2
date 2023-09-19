.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    # Check if the length of the vector is less than 1
    addi t0 x0 1
    bge a1 t0 start
    li a0 7
    ret
start:
    # Prologue

    add t0 x0 x0 # counter
    lw t1 0(a0) # max
    add t2 x0 x0 # max_index
loop_start:
    beq t0 a1 loop_end
    slli t3 t0 2
    add t3 a0 t3
    lw t3 0(t3)    # a[i]

    blt t3 t1 loop_continue
    add t1 t3 x0 # max = a[i]
    add t2 t0 x0 # max_index = i
loop_continue:
    addi t0 t0 1
    j loop_start
loop_end:
    add a0 t2 x0 # return max_index    

    # Epilogue


    ret