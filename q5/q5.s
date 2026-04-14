.data
file:.asciz "input.txt"
mode:.asciz "r" # read mode
yes:.asciz "Yes\n"
no:.asciz "No\n"

.text
.globl main
main:
    addi sp,sp,-32
    sw ra,28(sp)
    sw s0,24(sp) # s0 = FILE pointer
    sw s1,20(sp) # s1 = file size
    sw s2,16(sp) # s2 = left index
    sw s3,12(sp) # s3 = right index
    sw s4,8(sp) # s4 = temp: left_char

    # fopen("input.txt","r")
    la a0,file
    la a1,mode
    call fopen
    mv s0,a0 # file ptr to s0
    beqz s0,EXIT_FAIL # if fopen fails return 0 and exit

    # fseek(file,0,SEEK_END)
    mv a0,s0
    li a1,0
    li a2,2 # SEEK_END = 2
    call fseek

    # ftell(file) 
    mv a0,s0
    call ftell
    mv s1,a0  # Save file size to s1
    blez s1,YES  # If empty file, it's a palindrome

    li s2,0 # left_index = 0
    addi s3,s1,-1 # right_index = size - 1

trim:
    blt s3,s2,YES # If right < left after trimming: palindrome

    # fseek(file,right_index,SEEK_SET)
    mv a0,s0
    mv a1,s3
    li a2,0 # SEEK_SET = 0
    call fseek

    # fgetc(file)
    mv a0,s0
    call fgetc
    li t0,'\n'
    bne a0,t0,check_loop # Not a newline: done trimming
    addi s3,s3,-1 # Skip the newline
    jal x0,trim

check_loop:
    bge s2,s3,YES # left >= right: palindrome confirmed

    # Read character at left index
    # fseek(file,left_index,SEEK_SET)
    mv a0,s0
    mv a1,s2
    li a2,0
    call fseek

    # fgetc(file)
    mv a0,s0
    call fgetc
    mv s4,a0  # left char in s4

    # read char at right index
    # fseek(file,right_index,SEEK_SET)
    mv a0,s0
    mv a1,s3
    li a2,0
    call fseek

    # fgetc(file)
    mv a0,s0
    call fgetc  # right character is now in a0

    # compare
    bne s4, a0,NO # mismatch: not a palindrome
    addi s2,s2,1  # left++
    addi s3,s3,-1  # right--
    jal x0,check_loop

YES:
    la a0,yes
    call printf
    jal x0,CLEANUP

NO:
    la a0,no
    call printf

CLEANUP:
    beqz s0,EXIT_SUCCESS
    mv a0,s0
    call fclose

EXIT_SUCCESS:
    li a0,0              
    jal x0,EXIT

EXIT_FAIL:
    li a0,1              

EXIT:
    lw ra,28(sp)
    lw s0,24(sp)
    lw s1,20(sp)
    lw s2,16(sp)
    lw s3,12(sp)
    lw s4,8(sp)
    addi sp, sp, 32
    ret                   