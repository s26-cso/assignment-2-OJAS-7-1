# a0 = pointer to the arr, a1 = length of the array
# return value in a0, base address of result in a2

.data
stack: .space 400     # space for 100 integers

.text
la s0,stack          # s0 = base address of stack

main:
    jal ra,initialise_result
    jal ra,next_greater
    ret

initialise_result: # initialise result array
    addi t0,x0,0        # i = 0

init_loop:
    beq t0,a1,init_done # if i == length → stop

    slli t1,t0,2        # offset = i*4
    add t1,a2,t1        # address = a2 + offset

    addi t2,x0,-1
    sw t2,0(t1)          # result[i] = -1

    addi t0,t0,1        # i++
    jal x0,init_loop

init_done:
    ret

next_greater:
    addi t0,x0,-4 # top = -4
    addi t3,x0,-4 # store -4
    addi t2,a1,-1 # i = len - 1
    
loop:
    beq t2,t3,end_loop
    beq t0,t3,push_next # if stack empty,push

    slli t6,t2,2      
    add t6,a0,t6
    lw t4,0(t6) # arr[i]

    add t7,s0,t0 
    lw t7,0(t7) # stack.top[top]

    slli t6,t7,2
    add t6,a0,t6
    lw t5,0(t6) # arr[stack[top]]

    bge t4,t5,pop # if not empty and arr[i]>=arr[stack.top()]
    
    slli t6,t2,2
    add t6,a2,t6
    sw t5,0(t6) # result[i] = arr[stack.top()]
    jal x0,push_next # push i

end_loop:
    addi a0,a2,0
    ret 

push_next:
    addi t0,t0,4 # 4 bytes of int
    add t6,s0,t0
    sw t2,0(t6)

    addi t2,t2,-1 # next iteration
    jal x0,loop

pop:
    addi t0,t0,-4 # top--
    jal x0,loop

