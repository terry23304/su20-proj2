.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    addi t0 x0 1
    bge a1, t0, m0_dim_pass
    li a0 2
    ret
m0_dim_pass:
    bge a1, t0, m1_dim_pass
    li a0 3
    ret
m1_dim_pass:
    beq a2, a4, dim_match_pass
    li a0 4
    ret
dim_match_pass:

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    add s7, x0, x0                # i counter

outer_loop_start:
    beq s7, s1, outer_loop_end    # for every row of m0
    add s8, x0, x0                # j counter

inner_loop_start:
    beq s8, a5, inner_loop_end

    # m0[i]
    # sizeof(int) * number of columns of m0 * i
    addi t0, x0, 4
    mul t0, t0, s2
    mul t0, t0, s7
    # add m0 to the offset
    add t0, t0, s0

    # m1[j]
    # m1.head + counter2 * sizeof(int)
    addi t1, x0, 4
    mul t1, t1, s8
    add t1, t1, s3

    mv a0, t0
    mv a1, t1
    mv a2, s2
    addi a3, x0, 1
    mv a4, s5

    jal ra, dot
    # d[i][j]: 4 * m1 col * i + 4 * j + d
    # d size: 
    addi t0, x0, 4
    mul t0, t0, s5
    mul t0, t0, s7
    addi t1, x0, 4
    mul t1, t1, s8
    add t0, t0, t1
    add t0, t0, s6
    sw a0, 0(t0)                  # d[i][j]
    
    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40
    
    ret