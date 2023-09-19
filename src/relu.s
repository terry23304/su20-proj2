.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue

    # Check if the length of the vector is less than 1
    addi t0 x0 1
    bge a1 t0 start
    li a0 8
    ret
start:
    add t0 x0 x0
loop_start:
    beq t0 a1 loop_end
    slli t1 t0 2
    add t1 a0 t1
    lw t2 0(t1)    # a[i]
    bge t2 x0 loop_continue
    sw x0 0(t1)    # a[i] = 0
loop_continue:
    addi t0 t0 1
    j loop_start
loop_end:


    # Epilogue


	ret