.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    addi t0 x0 1
    bge a2 t0 length_ok
    li a0 5
    ret
length_ok:
    bge a3 t0 v0_stride_ok
    li a0 6
    ret
v0_stride_ok:
    bge a4 t0 start
    li a0 6
start:
    # Prologue
    addi sp sp -4
    sw s0, 0(sp)

    add t0 x0 x0    # counter for loop
    add s0, x0 x0   # sum of dot product
loop_start:
    beq t0 a2 loop_end
    slli t1 t0 2    # t1 = counter * 4
    mul t2 a3 t1
    mul t3 a4 t1 
    add t2 a0 t2    # t2 = &v0[counter]
    add t3 a1 t3    # t3 = &v1[counter]
    lw t2 0(t2)     # t2 = v0[counter]
    lw t3 0(t3)     # t3 = v1[counter]

    mul t2 t2 t3    # t2 = v0[counter] * v1[counter]
    add s0 s0 t2    # s0 = s0 + v0[counter] * v1[counter]
    addi t0 t0 1    # counter++
    j loop_start
loop_end:
    add a0 s0 x0    # a0 = s0

    # Epilogue
    lw s0 0(sp)
    addi sp sp 4
    ret