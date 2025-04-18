
/* DO NOT MODIFY THIS FILE! IT IS AUTOMATICALLY GENERATED BY synthesize-invoke-native */


#ifdef __ELF__
#if defined(__x86_64__)
/* Copied from https://github.com/bytecodealliance/wasm-micro-runtime/blob/main/core/iwasm/common/arch/invokeNative_em64.s */

__asm__(
/*
 * Copyright (C) 2019 Intel Corporation.  All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
"    .text\n"
"    .align 2\n"
#ifndef BH_PLATFORM_DARWIN
".globl invokeNative\n"
"    .type    invokeNative, @function\n"
"invokeNative:\n"
#else
".globl _invokeNative\n"
"_invokeNative:\n"
#endif /* end of BH_PLATFORM_DARWIN */
"    \n"/*  rdi - function ptr */
"    \n"/*  rsi - argv */
"    \n"/*  rdx - n_stacks */

"    push %rbp\n"
"    mov %rsp, %rbp\n"

"    mov %rdx, %r10\n"
"    mov %rsp, %r11      \n"/* Check that stack is aligned on */
"    and $8, %r11        \n"/* 16 bytes. This code may be removed */
"    je check_stack_succ \n"/* when we are sure that compiler always */
"    int3                \n"/* calls us with aligned stack */
"check_stack_succ:\n"
"    mov %r10, %r11      \n"/* Align stack on 16 bytes before pushing */
"    and $1, %r11        \n"/* stack arguments in case we have an odd */
"    shl $3, %r11        \n"/* number of stack arguments */
"    sub %r11, %rsp\n"
"    \n"/* store memory args */
"    movq %rdi, %r11     \n"/* func ptr */
"    movq %r10, %rcx     \n"/* counter */
"    lea 64+48-8(%rsi,%rcx,8), %r10\n"
"    sub %rsp, %r10\n"
"    cmpq $0, %rcx\n"
"    je push_args_end\n"
"push_args:\n"
"    push 0(%rsp,%r10)\n"
"    loop push_args\n"
"push_args_end:\n"
"    \n"/* fill all fp args */
"    movq 0x00(%rsi), %xmm0\n"
"    movq 0x08(%rsi), %xmm1\n"
"    movq 0x10(%rsi), %xmm2\n"
"    movq 0x18(%rsi), %xmm3\n"
"    movq 0x20(%rsi), %xmm4\n"
"    movq 0x28(%rsi), %xmm5\n"
"    movq 0x30(%rsi), %xmm6\n"
"    movq 0x38(%rsi), %xmm7\n"

"    \n"/* fill all int args */
"    movq 0x40(%rsi), %rdi\n"
"    movq 0x50(%rsi), %rdx\n"
"    movq 0x58(%rsi), %rcx\n"
"    movq 0x60(%rsi), %r8\n"
"    movq 0x68(%rsi), %r9\n"
"    movq 0x48(%rsi), %rsi\n"

"    call *%r11\n"
"    leave\n"
"    ret\n"


);
#elif defined(__aarch64__)
/* Copied from https://github.com/bytecodealliance/wasm-micro-runtime/blob/main/core/iwasm/common/arch/invokeNative_aarch64.s */

__asm__(
/*
 * Copyright (C) 2019 Intel Corporation.  All rights reserved.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 */
"        .text\n"
"        .align  2\n"
#ifndef BH_PLATFORM_DARWIN
"        .globl invokeNative\n"
"        .type  invokeNative, function\n"
"invokeNative:\n"
#else
"        .globl _invokeNative\n"
"_invokeNative:\n"
#endif /* end of BH_PLATFORM_DARWIN */

/*
 * Arguments passed in:
 *
 * x0 function ptr
 * x1 argv
 * x2 nstacks
 */

"        sub     sp, sp, #0x30\n"
"        stp     x19, x20, [sp, #0x20] \n"/* save the registers */
"        stp     x21, x22, [sp, #0x10]\n"
"        stp     x23, x24, [sp, #0x0]\n"

"        mov     x19, x0          \n"/* x19 = function ptr */
"        mov     x20, x1          \n"/* x20 = argv */
"        mov     x21, x2          \n"/* x21 = nstacks */
"        mov     x22, sp          \n"/* save the sp before call function */

"        \n"/* Fill in float-point registers */
"        ldp     d0, d1, [x20], #16 \n"/* d0 = argv[0], d1 = argv[1] */
"        ldp     d2, d3, [x20], #16 \n"/* d2 = argv[2], d3 = argv[3] */
"        ldp     d4, d5, [x20], #16 \n"/* d4 = argv[4], d5 = argv[5] */
"        ldp     d6, d7, [x20], #16 \n"/* d6 = argv[6], d7 = argv[7] */

"        \n"/* Fill integer registers */
"        ldp     x0, x1, [x20], #16 \n"/* x0 = argv[8] = exec_env, x1 = argv[9] */
"        ldp     x2, x3, [x20], #16 \n"/* x2 = argv[10], x3 = argv[11] */
"        ldp     x4, x5, [x20], #16 \n"/* x4 = argv[12], x5 = argv[13] */
"        ldp     x6, x7, [x20], #16 \n"/* x6 = argv[14], x7 = argv[15] */

"        \n"/* Now x20 points to stack args */

"        \n"/* Directly call the function if no args in stack */
"        cmp     x21, #0\n"
"        beq     call_func\n"

"        \n"/* Fill all stack args: reserve stack space and fill one by one */
"        mov     x23, sp\n"
"        bic     sp,  x23, #15    \n"/* Ensure stack is 16 bytes aligned */
"        lsl     x23, x21, #3     \n"/* x23 = nstacks * 8 */
"        add     x23, x23, #15    \n"/* x23 = (x23 + 15) & ~15 */
"        bic     x23, x23, #15\n"
"        sub     sp, sp, x23      \n"/* reserved stack space for stack arguments */
"        mov     x23, sp\n"

"loop_stack_args:                 \n"/* copy stack arguments to stack */
"        cmp     x21, #0\n"
"        beq     call_func\n"
"        ldr     x24, [x20], #8\n"
"        str     x24, [x23], #8\n"
"        sub     x21, x21, #1\n"
"        b       loop_stack_args\n"

"call_func:\n"
"        mov     x20, x30         \n"/* save x30(lr) */
"        blr     x19\n"
"        mov     sp, x22          \n"/* restore sp which is saved before calling function*/

"return:\n"
"        mov     x30,  x20              \n"/* restore x30(lr) */
"        ldp     x19, x20, [sp, #0x20]  \n"/* restore the registers in stack */
"        ldp     x21, x22, [sp, #0x10]\n"
"        ldp     x23, x24, [sp, #0x0]\n"
"        add     sp, sp, #0x30          \n"/* restore sp */
"        ret\n"


);
#endif

#endif