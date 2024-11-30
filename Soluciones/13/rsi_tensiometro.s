@; ###################################################################################################################
@; Autor: Iván Molinero Moreno (huecos a rellenar) - Santiago Romaní Also (código general + supervisión de respuesta).
@; ###################################################################################################################

@; RSI del tensiómetro: se activa cada vez que detecta un latido completo
@; mientras se está aumentando la presión;
@; almacena el valor actual de la variable 'tiempo' en la posición
@; 'i_per' del vector 'period', pone a cero el tiempo e incrementa
@; la posición del vector; también lee el valor actual de presión y lo
@; guarda en la variable global 'presion'.
RSI_tensiometro:
        push {r0-r4, lr}
        ldr r0, =i_per
        ldrb r1, [r0] @; R1 = valor de 'i_per' (posición vector)
        ldr r2, =tiempo

        @; ############ D ############
            ldr r3, =period
            ldrb r4, [r2]
            strb r4, [r3, r1]
            mov r4, #0
            strb r4, [r2]
        @; ############ D ############
        
        add r1, #1
        strb r1, [r0] @; i_per++;

        @; ############ E ############
            ldr r0, =TENS_DATA
        @; ############ E ############

        ldrh r1, [r0] @; R1 = valor actual de presión
        ldr r2, =presion
        strh r1, [r2] @; guardar valor presión en variable global
        pop {r0-r4, pc}

@; calcular_ritmo: obtiene el ritmo cardíaco como la media de los
@; periodos registrados en el vector que se pasa por parámetro (por
@; referencia), teniendo en cuento que dichos periodos se expresan en
@; número de retrocesos verticales (60 Hz).
@; Parámetros:
@; R0 = dirección inicial vector de periodos
@; R1 = número de elementos registrados en el vector
@; Resultado:
@; R0 = pulsaciones por minuto (byte)
calcular_ritmo:
        push {r1-r4, lr}
        mov r2, #1 @; R2 es índice vector (obviar primer elem.)
        mov r3, #0 @; R3 es el valor acumulado de periodos
    .Lritmo_for:

        @; ############ F ############
            ldrb r4, [r0, r2]       @; R4 = periodos[i]; 
            add r3, r4              @; acumular periodo
            add r2, #1              @; i++;
            cmp r2, r1              @; repetir para todos los elementos del vector            
            blo .Lritmo_for
        @; ############ F ############
        
        mov r0, r3 @; R0 = sumatorio de periodos (excepto primer)
        sub r1, #1 @; R1 = número de elementos (menos primero);

        @; ############ G ############
            swi 9   @; R0 = periodo promedio entre pulsaciones,
                    @; expresado en número de VBLs
        @; ############ G ############

        
        mov r1, r0 @; T = R0 / 60 (periodo expresado en segundos)

        @; ############ H ############
            mov r0, #3600   @; F = 60 / T (frecuencia expresada en ppm)
        @; ############ H ############

        @; ############ I ############
            swi 9           @; R0 = F ppm (60*60 / periodo promedio)
        @; ############ I ############

        pop {r1-r4, pc}