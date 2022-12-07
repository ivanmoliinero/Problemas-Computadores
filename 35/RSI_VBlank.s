		@; RSI del vertical blank.
RSI_vblank:
	push {r0-r3, lr}
	ldr r1, =ang_actual
	ldr r0, [r1]
	ldr r2, =fraccion
	ldr r2, [r2]
	add r0, r2
	ldr r2, =360
	mov r2, r2, lsl #12
	cmp r0, r2
	subge r0, r2
	str r0, [r1]
	mov r0, r0, lsr #12
	ldr r3, =ang_pos
	mov r0, r0, lsl #2
	ldrh r1, [r3, r0]
	ldrh r2, [r3, r0, #2]
	bl SPR_moverSprite
	ldr r0, #0X07000000		@; #OAM
	mov r1, #1
	bl SPR_actualizarSprites
	bl activar_beat
	pop {r0-r3, pc}