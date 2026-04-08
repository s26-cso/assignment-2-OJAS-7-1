.globl make_node:
# a0 = pointer to the root ; # a1 = val
# return value in a0
make_node:
    addi sp,sp,-16
    sd ra,8(sp)
    sd a1,0(sp) # val

    addi a0,x0,24 # a0 = 24 for 24bytes memory allocation for struct
    call malloc

    add t0,x0,a0 # now t0 contains pointer returned by malloc

    ld t1,0(sp) # t1 = val
    # in struct : for offeset = 0 -> val, 8->left ptr, 16-> right ptr
    sw t1,0(t0) #  val given to struct and memory

    sd zero,8(t0) # left = NULL
    sd zero,16(t0) # right = NULL

    add a0,x0,t0 # a0 = pointer to return

    ld ra,8(sp)
    addi sp,sp,16
    ret 
      
.globl insert:

insert:
    addi sp,sp,-16
    sd ra,8(sp)
    sd t1,0(sp)

    addi t0,a1,0 # t0 = val
    addi t1,a0,0 # t1 = pointer to root

    beq a0,x0,make_node # if root == NULL,create a newnode and
                        # return pointer to it(exactly what make_node function does)

    lw t2,0(t1) # t2 = root->val    
    blt t0,t2,go_left
    bge t0,t2,go_right

go_left:
    ld a0,8(t1) # a0 = root->left
    add a1,x0,t0
    jal ra,insert
    sd a0,8(t1)
    jal x0,end

go_right:
    ld a0,16(t1) # a0 = root->right
    add a1,x0,t0
    jal ra,insert
    sd a0,16(t1)
    jal x0,end
    
end:
    add a0,x0,t1 # return root pointer
    ld t1,0(sp)
    ld ra,8(sp)
    addi sp,sp,16
    ret

.globl get:

get:
    addi t0,a1,0 # t0 = val
    addi t1,a0,0 # t1 = pointer to root

    beq t1,x0,not_found   

    lw t2,0(t1) # t2 = root->val 
    beq t0,t2,done  

    blt t0,t2,left
    bge t0,t2,right

left:
    ld a0,8(t1) # a0 = root->left
    add a1,x0,t0
    jal x0,insert

right:
    ld a0,16(t1) # a0 = root->right
    add a1,x0,t0
    jal x0,insert
    
done:
    add a0,x0,t1 # return root pointer
    ret

not_found:
    add a0,x0,0 # return NULL
    ret

.globl getAtMost:
getAtMost:

get_ptr_node:
    beq 0,x0,get
    # we get pointer to val in a0 and a1 has val
    addi t1,t1,8 # t1 = pointer to val->left
    beq t1,x0,no_pred 
    add t2,x0,0(t1) # t2 will store temp predecessor

fxn:
    addi t1,a0,0 # t1 = pointer to val
    addi t3,16(t1),0 # t3 = root->right
    beq t3,x0,pred  
    add t2,x0,0(t1) 
    addi a0,t3,0
    jal x0,fxn 

pred:
    addi a0,t2,0 # return val
    ret

no_pred:
    addi a0,x0,0 # return NULL
    ret