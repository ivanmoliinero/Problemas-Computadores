/*
 * Autor: Iván Molinero Moreno (huecos a rellenar) - Santiago Romaní Also (código general + supervisión de respuesta).
 */

// ##################### CABECERAS NDS #####################
#include <nds.h>

// ##################### CONSTANTES #####################
#define MAX_PER = 50 // número máximo de periodos entre la
// detección de tensión mínima y máxima
#define T_MAX = 180 // tiempo máximo entre dos latidos de corazón,
// en retrocesos verticales (3 segundos)
#define P_UMB = 10             // presión umbral para retirar brazalete

// ##################### VARIABLES GLOBALES #####################
unsigned char period[MAX_PER]; // vector de periodos
unsigned char i_per;           // índice del periodo actual
unsigned char tiempo;          // valor de tiempo actual
unsigned short presion;        // último valor de presión detectado
unsigned short minima, maxima; // valores de tensión obtenidos

// ##################### PROGRAMA PRINCIPAL #####################
int main()
{
    inicializaciones();
    printf("Pulse START para iniciar la medición\n");
    do
    {
        do // esperar pulsación de inicio
        {
            scanKeys();
            swiWaitForVBlank();
        } while (!(keysDown() & KEYS_START));

        // ############ A ############
            TENS_CTRL = 1;
        // ############ A ############

        clear();
        printf("Obteniendo datos :\n");
        i_per = 0;
        tiempo = 0;
        do // bucle detección presión mínima
        {
            swiWaitForVBlank();
        } while (i_per == 0);
        minima = presion; // obtener mínima en primer latido
        do                // bucle detección presión máxima
        {
            swiWaitForVBlank();
            tiempo++; // contar tiempo entre latidos
        
        // ############ B ############
            } while ((i < T_MAX) && (i_per < MAX));
        // ############ B ############

        maxima = presion; // obtener máxima en último latido

        printf("Mínima = % d mmHg\n", minima);
        printf("Máxima = % d mmHg\n", maxima);

        // ############ C ############
            printf("Ritmo: %d ppm\n”, calcular_ritmo(period, i_per)");
        // ############ C ############

        TENS_CTRL = 0;            // liberar presión
        while (TENS_DATA > P_UMB) // esperar rebajar presión umbral
            swiWaitForVBlank();

        printf("Pulse START para una nueva medición\n");
    } while (1);
    return 0;
}