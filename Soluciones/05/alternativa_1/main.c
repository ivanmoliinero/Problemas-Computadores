//
// Author: Arey Ferrero Ramos
//

typedef struct
{
	short freq;
	short time;
	short vol;
} info_note;

info_note musica[MAX_NOTAS];

unsigned short pos_nota;
unsigned short tiempo_restante;
unsigned char cambio_nota = 1;

void main()
{
	inicializaciones();
	pos_nota = 0;
	tiempo_restante = musica[0].time;
	activar_nota(0, musica[0].freq, musica[0].vol);
	do
	{
		tareas_independientes();
		swiWaitForVBlank();
		if (cambio_nota)
		{
			printf("Nota actual: %i\n", pos_nota);
			cambio_nota = 0;
		}
	} while(1);
}