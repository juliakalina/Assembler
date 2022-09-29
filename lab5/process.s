
    .arch armv8-a

    .text
    .align 2

    .global process_asm
    .type process_asm, %function
process_asm:
    // x0 = uint8_t *image
    // w1 = uint32_t width
    // w2 = uint32_t height
    // w3 = x1
    // w4 = y1
    // w5 = x2
    // w6 = y2

    mov x7, 0

    mov x8, x4 // y = y1
    loop_y:
        cmp x8, x6
        bge exit_process_asm

        mov x9, x3 // x = x1
        loop_x:
            cmp x9, x5
            bge end_x

            madd x10, x8, x1, x9 // y * width + x
            ldr w11, [x0, x10, lsl 2]
            str w11, [x0, x7, lsl 2]
            add x7, x7, 1 // i += 1

            add x9, x9, 1
            b loop_x
        end_x:

        add x8, x8, 1
        b loop_y

exit_process_asm:
    mov x0, 0
    ret

    .size   process_asm, (. - process_asm)
