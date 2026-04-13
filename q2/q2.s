.section .rodata
fmt:    .string "%d "
fmt1:   .string "\n"

.data
stack:  .space 400

.section .text
.globl main

main:
    addi sp,sp,-64
    sd ra,56(sp)
    sd s0,48(sp) # base address of stack
    sd s1,40(sp) # length of arr
    sd s2,32(sp) # base address of arr
    sd s3,24(sp) # loop ctr
    sd s4,16(sp) # base address of result arr

    # arguements
    addi s1,a0,-1 # s1 = lenght
    mv s3,a1
    addi s3,s3,8

    slli a0,s1,2 # memory for input array
    call malloc
    mv s2,a0 # s2 = arr base address

    li s4, 0 # i = 0

input_loop:
    beq s4,s1,run_logic
    slli t1,s4,3 # offset = i*8
    add t1,s3,t1          
    ld a0,0(t1) # load argv string pointer
    call atoi # convert to int
    slli t1,s4,2 # offset = i*4
    add t1,s2,t1          
    sw a0,0(t1) # arr[i] = integer
    addi s4,s4,1 # i++
    jal x0,input_loop

run_logic:
    slli a0,s1,2 # memory for result array
    call malloc
    mv s4,a0 # s4 = result base address

    mv a0,s2 # a0 = arr
    mv a1,s1 # a1 = length
    mv a2,s4 # a2 = result
    la s0,stack # s0 = base address of stack

    call initialise_result
    mv a0,s2
    mv a1,s1
    mv a2,s4

    call next_greater
    li s3,0 # i =0

print_loop:
    beq s3,s1,exit
    slli t1,s3,2 # offset = i*4
    add t1,s4,t1          
    lw a1,0(t1) # result[i] to be printed
    lla a0,fmt
    call printf
    addi s3,s3,1 # i++
    jal x0,print_loop

exit:
    lla a0,fmt1
    call printf
    
    ld ra,56(sp)
    ld s0,48(sp)
    ld s1,40(sp)
    ld s2,32(sp)
    ld s3,24(sp)
    ld s4,16(sp)
    addi sp,sp,64
    li a0,0 # return 0
    ret

initialise_result: # initialise result array
    addi t0,x0,0 # i = 0

init_loop:
    beq t0,a1,init_done # if i == length → stop

    slli t1,t0,2 # offset = i*4
    add t1,a2,t1 # address = a2 + offset

    addi t2,x0,-1
    sw t2,0(t1) # result[i] = -1

    addi t0,t0,1 # i++
    jal x0,init_loop

init_done:
    ret

next_greater:
    addi t0,x0,-4 # top = -4
    addi t3,x0,-4 # store -4
    addi t2,a1,-1 # i = len - 1
    
loop:
    bltz t2,end_loop # stop loop if i < 0
    beq t0,t3,push_next # if stack empty, push

    slli t6,t2,2      
    add t6,a0,t6
    lw t4,0(t6)  # arr[i]

    add t6,s0,t0 # stack.top[top]
    lw t6,0(t6) 

    slli t6,t6,2
    add t6,a0,t6
    lw t5,0(t6) # arr[stack[top]]

    bge t4,t5,pop # if not empty and arr[i] >= arr[stack.top()]
    
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

pop:k
    addi t0,t0,-4 # top--
    jal x0,loop