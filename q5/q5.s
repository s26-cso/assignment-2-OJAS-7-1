.data
file:.asciz "input.txt"
b1:.space 1
b2:.space 1
yes:.asciz "Yes\n"
no:.asciz "No\n"

.text
.globl main
main:
    la a0,file
    li a1,0    # read-only
    li a7,1024 # RARS: open
    ecall

    mv s0,a0 # s0 = file descriptor
    bltz s0,EXIT # if fd < 0: open failed, exit

    mv a0,s0
    li a1,0
    li a2,2   # SEEK_END
    li a7,62  # RARS: lseek
    ecall
    mv s1,a0 # s1 = file size
    blez s1,YES # empty file: already a palindrome

    li s2,0 # s2 = left_index
    addi s3,s1,-1 # s3 = right_index

trim:
    blt s3,s2,YES # if right < left after trimming: palindrome
    mv a0,s0
    mv a1,s3 # seek to right index
    li a2,0  # SEEK_SET
    li a7,62
    ecall

    mv a0,s0
    la a1,b2
    li a2,1
    li a7,63 # RARS: read
    ecall
    lb t1,b2
    li t2,'\n'
    bne t1,t2,loop # not a newline: done trimming
    addi s3,s3,-1 # skip the newline
    jal x0,trim

loop:
    bge s2,s3,YES # left >= right: palindrome confirmed

    mv a0,s0 # read character at left index
    mv a1,s2
    li a2,0 # SEEK_SET
    li a7,62
    ecall

    mv a0,s0
    la a1,b1
    li a2,1
    li a7,63
    ecall
    lb t0,b1 # t0 = left character

    mv a0,s0 # read character at right index
    mv a1,s3
    li a2,0 # SEEK_SET
    li a7,62
    ecall

    mv a0,s0
    la a1,b2
    li a2,1
    li a7,63
    ecall

    lb t1,b2 # t1 = right character
    bne t0,t1,NO # mismatch: not a palindrome
    addi s2,s2,1 # left++
    addi s3,s3,-1 # right--
    jal x0,loop

YES:
    la a0,yes
    li a7,4 # RARS: print_string
    ecall
    jal x0,EXIT

NO:
    la a0,no
    li a7,4
    ecall

EXIT:
    li a7,10 # RARS: exit
    ecall