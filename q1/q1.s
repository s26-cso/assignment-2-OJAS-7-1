.globl make_node
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
    sd t1,0(t0) #  val given to struct and memory

    sd zero,8(t0) # left = NULL
    sd zero,16(t0) # right = NULL

    add a0,x0,t0 # a0 = pointer to return

    ld ra,8(sp)
    addi sp,sp,16
    ret 
      
.globl insert

insert:
    addi sp,sp,-16
    sd ra,8(sp)
    sd s0,0(sp)

    addi t0,a1,0 # t0 = val
    addi s0,a0,0 # s0 = pointer to root

    bne s0,x0,compare
    jal ra,make_node # if root == NULL,create a newnode and
                     # return pointer to it(exactly what make_node function does)
    jal x0,end_null

compare:
    ld t2,0(s0) # t2 = root->val    
    blt t0,t2,insert_go_left
    bge t0,t2,insert_go_right

insert_go_left:
    ld a0,8(s0) # a0 = root->left
    add a1,x0,t0
    jal ra,insert
    sd a0,8(s0)
    jal x0,end

insert_go_right:
    ld a0,16(s0) # a0 = root->right
    add a1,x0,t0
    jal ra,insert
    sd a0,16(s0)
    jal x0,end
    
end:
    add a0,x0,s0 # return root pointer
end_null:
    ld s0,0(sp)
    ld ra,8(sp)
    addi sp,sp,16
    ret

.globl get

get:
    addi t0,a1,0 # t0 = val
    addi t1,a0,0 # t1 = pointer to root

    beq t1,x0,not_found   

    ld t2,0(t1) # t2 = root->val 
    beq t0,t2,done  

    blt t0,t2,get_left
    bge t0,t2,get_right

get_left:
    ld a0,8(t1) # a0 = root->left
    add a1,x0,t0
    jal x0,get

get_right:
    ld a0,16(t1) # a0 = root->right
    add a1,x0,t0
    jal x0,get
    
done:
    add a0,x0,t1 # return root pointer
    ret

not_found:
    add a0,x0,0 # return NULL
    ret

.globl getAtMost
getAtMost:
    add t0,x0,x0 # t0 = NULL (stores best predecessor)

fxn:
    beq a0,x0,return_pred   # if root == NULL → return best found
    ld t1,0(a0) # t1 = root->val
    beq a1,t1,found # exact match → return this node
    blt a1,t1,go_left2  # if val < root->val → go left

go_right2:
    add t0,x0,a0 # update predecessor
    ld a0,16(a0) # move to right
    jal x0,fxn

go_left2:
    ld a0,8(a0) # move to left
    jal x0,fxn

found:
    ret

return_pred:
    add a0,x0,t0 # return best predecessor (may be NULL)
    ret
