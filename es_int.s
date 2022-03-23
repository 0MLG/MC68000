	ORG     $0
    DC.L    $8000          * Pila
    DC.L    START           * PC

	ORG	$400

*********************************
* Definicion de equivalencias
*********************************
MR1A	EQU		$effc01		* de modo A (escritura)
MR2A	EQU		$effc01		* de modo A (2º escritura)
SRA		EQU		$effc03		* de estado A (lectura)
CSRA	EQU		$effc03		* de seleccion de reloj A (escritura)
CRA		EQU		$effc05		* de control A (escritura)
TBA		EQU		$effc07		* buffer transmision A (escritura)
RBA		EQU		$effc07		* buffer recepcion A  (lectura)
ACR		EQU		$effc09		* de control auxiliar
IMR		EQU		$effc0B		* de mascara de interrupcion A (escritura)
ISR		EQU		$effc0B		* de estado de interrupcion A (lectura)
MR1B	EQU		$effc11		* de modo B (escritura)
MR2B	EQU		$effc11		* de modo B (2º escritura)
CRB		EQU		$effc15		* de control A (escritura)
TBB		EQU		$effc17		* buffer transmision B (escritura)
RBB		EQU		$effc17		* buffer recepcion B (lectura)
SRB		EQU		$effc13		* de estado B (lectura)
CSRB	EQU		$effc13		* de seleccion de reloj B (escritura)
IVR		EQU		$effc19


*********************************
* Definicion de variables
*********************************	
ABUFSCAN:	DS.B  2001		* Reserva 2001B buffer Scan A
AINISCAN:	DC.L  0			* Inicio buffer Scan A
AESCSCAN:	DC.L  0			* Escritura buffer Scan A
ALECSCAN:	DC.L  0			* Lectura buffer Scan A
AFINSCAN:	DC.L  0			* Fin buffer Scan A

BBUFSCAN:	DS.B  2001		* Reserva 2001B buffer Scan B
BINISCAN:	DC.L  0			* Inicio buffer Scan B
BESCSCAN:	DC.L  0			* Escritura buffer Scan B
BLECSCAN:	DC.L  0			* Lectura buffer Scan B
BFINSCAN:	DC.L  0			* Fin buffer Scan B

ABUFPRINT:	DS.B  2001		* Reserva 2001B buffer Print A
AINIPRINT:	DC.L  0			* Inicio buffer Print A
AESCPRINT:	DC.L  0			* Escritura buffer Print A
ALECPRINT:	DC.L  0			* Lectura buffer Print A
AFINPRINT:	DC.L  0			* Fin buffer Print A

BBUFPRINT:	DS.B  2001		* Reserva 2001B buffer Print B
BINIPRINT:	DC.L  0			* Inicio buffer Print B
BESCPRINT:	DC.L  0			* Escritura buffer Print B
BLECPRINT:	DC.L  0			* Lectura buffer Print B
BFINPRINT:	DC.L  0			* Fin buffer Print B

IMRCHECK	DS.B 1			* Copia IMR


*********************************
* INIT
*********************************
INIT   	MOVE.B 	#%00010000,CRA			* Reinicia el puntero de control para MR1A
		MOVE.B  #%00010000,CRB 			* Reinicia el puntero de control para MR1B
		MOVE.B 	#%00000011,MR1A 		* 8 bits por caracter linea A
		MOVE.B 	#%00000011,MR1B			* 8 bits por caracter linea B
		MOVE.B	#%00000000,MR2A			* No activar el eco linea A
		MOVE.B	#%00000000,MR2B			* No activar el eco linea B
		MOVE.B	#%00000000,ACR			* Selecciona primer conjunto
		MOVE.B	#%11001100,CSRA			* Velocidad de recepcion y transmision de 38400 bits/s linea A
		MOVE.B	#%11001100,CSRB			* Velocidad de recepcion y transmision de 38400 bits/s linea B
		MOVE.B 	#%00010101,CRA 			* Habilitadas recepcion y transmision linea A
		MOVE.B 	#%00010101,CRB 			* Habilitadas recepcion y transmision linea B
		MOVE.B  #%01000000,IVR 			* Establecido valor de interrupcion
		MOVE.B  #%00100010,IMR			* Establecidas interrupciones en A y B, transmisiones inhibidas
		MOVE.B	#%00100010,IMRCHECK		* Copia contenidos de IMR
		MOVE.L 	#RTI,$100				* Actualiza la direccion de la rutina de tratamiento de interrupcion en la tabla de vectores

		
		MOVE.L #ABUFSCAN,AINISCAN		* Puntero inicio Scan A
		MOVE.L #ABUFSCAN,ALECSCAN		* Puntero lectura Scan A
		MOVE.L #ABUFSCAN,AESCSCAN		* Puntero escritura Scan A
		MOVE.L #ABUFSCAN,A0				* A0 = dir buffer Scan A
		ADDA.L #2000,A0					* A0 +2000
		MOVE.L A0,AFINSCAN				* Puntero fin Scan A
		
		MOVE.L #ABUFPRINT,AINIPRINT		* Puntero inicio Print A
		MOVE.L #ABUFPRINT,ALECPRINT		* Puntero lectura Print A
		MOVE.L #ABUFPRINT,AESCPRINT		* Puntero escritura Print A
		MOVE.L #ABUFPRINT,A0			* A0 = dir buffer Print A
		ADDA.L #2000,A0					* A0 +2000
		MOVE.L A0,AFINPRINT				* Puntero fin Print A
		
		MOVE.L #BBUFSCAN,BINISCAN		* Puntero inicio Scan B
		MOVE.L #BBUFSCAN,BLECSCAN		* Puntero lectura Scan B
		MOVE.L #BBUFSCAN,BESCSCAN		* Puntero escritura Scan B
		MOVE.L #BBUFSCAN,A0				* A0 = dir buffer Scan B
		ADDA.L #2000,A0					* A0 +2000
		MOVE.L A0,BFINSCAN				* Puntero fin Scan B
		
		MOVE.L #BBUFPRINT,BINIPRINT		* Puntero inicio Print B
		MOVE.L #BBUFPRINT,BLECPRINT		* Puntero lectura Print B
		MOVE.L #BBUFPRINT,BESCPRINT		* Puntero escritura Print B
		MOVE.L #BBUFPRINT,A0			* A0 = dir buffer Print B
		ADDA.L #2000,A0					* A0 +2000
		MOVE.L A0,BFINPRINT				* Puntero fin Print B
		RTS                         	    
	
	
*********************************
* LEECAR
*********************************
LEECAR	LINK A6,#-8
		MOVE.L A1,-4(A6)
		MOVE.L A2,-8(A6)
		CMP.B #0,D0
		BEQ RECLINA		* Recepcion por linea a 
		CMP.B #1,D0
		BEQ RECLINB		* Recepcion por linea b
		CMP.B #2,D0
		BEQ TRALINA		* Transmision por linea a
		CMP.B #3,D0
		BEQ TRALINB		* Transmision por linea b
************	
RECLINA	MOVE.L ALECSCAN,A1
		MOVE.L AESCSCAN,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer vacio
		BEQ NOCARAC
		
		MOVE.B (A1),D0		* Inserta caracter en d0
		CMP.L AFINSCAN,A1	* Puntero lectura = fin buffer -> vuelta a inicio
		BNE RLASUM
		
		MOVE.L AINISCAN,A1
		BRA RLAACT
		
RLASUM	ADD.L #1,A1			* Avanza una posicion
		
RLAACT	MOVE.L A1,ALECSCAN
		BRA FLEECAR
************
RECLINB MOVE.L BLECSCAN,A1
		MOVE.L BESCSCAN,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer vacio
		BEQ NOCARAC
		
		MOVE.B (A1),D0		* Inserta caracter en d0
		CMP.L BFINSCAN,A1	* Puntero lectura = fin buffer -> vuelta a inicio
		BNE RLBSUM
		
		MOVE.L BINISCAN,A1	
		BRA RLBACT
		
RLBSUM	ADD.L #1,A1			* Avanza una posicion

RLBACT	MOVE.L A1,BLECSCAN
		BRA FLEECAR
************
TRALINA	MOVE.L ALECPRINT,A1
		MOVE.L AESCPRINT,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer vacio
		BEQ NOCARAC
		
		MOVE.B (A1),D0		* Inserta caracter en d0
		CMP.L AFINPRINT,A1	* Puntero lectura = fin buffer -> vuelta a inicio
		BNE TLASUM
		
		MOVE.L AINIPRINT,A1
		BRA TLAACT
		
TLASUM	ADD.L #1,A1			* Avanza una posicion

TLAACT	MOVE.L A1,ALECPRINT
		BRA FLEECAR
************
TRALINB MOVE.L BLECPRINT,A1
		MOVE.L BESCPRINT,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer vacio
		BEQ NOCARAC
		
		MOVE.B (A1),D0		* Inserta caracter en d0
		CMP.L BFINPRINT,A1	* Puntero lectura = fin buffer -> vuelta a inicio
		BNE TLBSUM
		
		MOVE.L BINIPRINT,A1
		BRA TLBACT
		
TLBSUM	ADD.L #1,A1			* Avanza una posicion
		
TLBACT	MOVE.L A1,BLECPRINT
		BRA FLEECAR
************
NOCARAC	MOVE.L #$ffffffff,D0	* Buffer vacio -> d0=-1

FLEECAR	MOVE.L -4(A6),A1
		MOVE.L -8(A6),A2
		UNLK A6
		RTS
		
		
*********************************		
* ESCCAR
*********************************
ESCCAR	LINK A6,#-8		
		MOVE.L A1,-4(A6)
		MOVE.L A2,-8(A6)
		CMP.B #0,D0
		BEQ ESCRECA		* Recepcion por linea a
		CMP.B #1,D0
		BEQ ESCRECB		* Recepcion por linea b
		CMP.B #2,D0
		BEQ ESCTRAA		* Transmision por linea a
		CMP.B #3,D0
		BEQ ESCTRAB		* Transmision por linea b
************
ESCRECA	MOVE.L ALECSCAN,A1
		MOVE.L AESCSCAN,A2
		MOVE.B D1,(A2) 		* Inserta caracter en buffer
		CMP.L AFINSCAN,A2	* Puntero escritura = fin buffer -> vuelta inicio
		BNE ERASUM
		
		MOVE.L AINISCAN,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer lleno
		BNE ERAFIN
		BRA BFULL
		
ERASUM	ADD.L #1,A2
		CMP.L A1,A2 		* Avanza una posicion y comprueba si ha llegado al final
		BEQ BFULL			
		
ERAFIN	MOVE.L #0,D0
		MOVE.L A2,AESCSCAN
		BRA FESCCAR
************
ESCRECB	MOVE.L BLECSCAN,A1
		MOVE.L BESCSCAN,A2
		MOVE.B D1,(A2)		* Inserta caracter en buffer
		CMP.L BFINSCAN,A2	* Puntero escritura = fin buffer -> vuelta inicio
		BNE ERBSUM
		
		MOVE.L BINISCAN,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer lleno
		BNE ERBFIN
		BRA BFULL
		
ERBSUM	ADD.L #1,A2
		CMP A1,A2			* Avanza una posicion y comprueba si ha llegado al final
		BEQ BFULL
		
ERBFIN	MOVE.L #0,D0
		MOVE.L A2,BESCSCAN
		BRA FESCCAR
************
ESCTRAA MOVE.L ALECPRINT,A1
		MOVE.L AESCPRINT,A2
		MOVE.B D1,(A2)		* Inserta caracter en buffer
		CMP.L AFINPRINT,A2	* Puntero escritura = fin buffer -> vuelta inicio
		BNE ETASUM
		
		MOVE.L AINIPRINT,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer lleno
		BNE ETAFIN
		BRA BFULL
		
ETASUM	ADD.L #1,A2
		CMP A1,A2			* Avanza una posicion y comprueba si ha llegado al final
		BEQ BFULL
		
ETAFIN	MOVE.L #0,D0
		MOVE.L A2,AESCPRINT
		BRA FESCCAR
************
ESCTRAB	MOVE.L BLECPRINT,A1
		MOVE.L BESCPRINT,A2
		MOVE.B D1,(A2)		* Inserta caracter en buffer
		CMP.L BFINPRINT,A2	* Puntero escritura = fin buffer -> vuelta inicio
		BNE ETBSUM
		
		MOVE.L BINIPRINT,A2
		CMP.L A1,A2			* Puntero lectura = puntero escritura -> buffer lleno
		BNE ETBFIN
		BRA BFULL

ETBSUM	ADD.L #1,A2
		CMP A1,A2			* Avanza una posicion y comprueba si ha llegado al final
		BEQ BFULL
		
ETBFIN	MOVE.L #0,D0
		MOVE.L A2,BESCPRINT
		BRA FESCCAR
		
BFULL	MOVE.L #$ffffffff,D0	* Buffer lleno -> d0=-1

FESCCAR	MOVE.L -4(A6),A1
		MOVE.L -8(A6),A2
		UNLK A6
		RTS						* Fin ESCCAR
		
		
*********************************		
* SCAN
*********************************
SCAN		LINK A6,#-16
			MOVE.L A3,-4(A6)
			MOVE.L D2,-8(A6)
			MOVE.L D3,-12(A6)
			MOVE.L D4,-16(A6)
		
			CLR.L D2			
			CLR.L D3
			CLR.L D4
			
			MOVE.L 	8(A6),A3	* Direccion buffer
			MOVE.W	12(A6),D2	* Descriptor
			MOVE.W	14(A6),D3	* Tamano
			MOVE.L #0,D4		* Contador
			
			CMP.W #0,D3
			BNE SCANCOMP
			
			MOVE.L #0,D0		* Tamano = 0 -> d0=0
			BRA FSCAN
			
SCANCOMP	CMP.W #0,D2
			BEQ ASCAN			* Descriptor = 0 -> Linea a
			CMP.W #1,D2
			BEQ BSCAN			* Descriptor = 1 -> Linea b
			
			MOVE.L #$ffffffff,D0 * D0=-1
			BRA FSCAN
************			
ASCAN		MOVE.L #0,D0
			BSR LEECAR
			CMP.L #$ffffffff,D0 * Comprueba si leecar devuelve bucle vacio
			BEQ SCANRES
			
			ADD.L #1,D4
			MOVE.B D0,(A3)+
			CMP.L D4,D3			* Tamano = contador -> termina
			BNE ASCAN
			BRA SCANRES
************
BSCAN		MOVE.L #1,D0
			BSR LEECAR
			CMP.L #$ffffffff,D0 * Si leecar devuelve bucle vacio termina
			BEQ SCANRES
			
			ADD.L #1,D4
			MOVE.B D0,(A3)+
			CMP.L D4,D3			* Tamano = contador -> termina
			BNE BSCAN
************
SCANRES		MOVE.L D4,D0		* Metemos en d0 el numero de caracteres leidos

FSCAN		MOVE.L -4(A6),A3
			MOVE.L -8(A6),D2
			MOVE.L -12(A6),D3
			MOVE.L -16(A6),D4
			UNLK A6		
			RTS 				* Fin Scan
		
		
*********************************		
* PRINT
*********************************
PRINT		LINK A6,#-20
			MOVE.L A3,-4(A6)
			MOVE.L D2,-8(A6)
			MOVE.L D3,-12(A6)
			MOVE.L D4,-16(A6)
			MOVE.L D5,-20(A6)

			CLR.L D2
			CLR.L D3
			CLR.L D4
			
			MOVE.L 8(A6),A3		* Direccion buffer
			MOVE.W 12(A6),D2	* Descriptor
			MOVE.W 14(A6),D3	* Tamano
			MOVE.L #0,D4		* Contador
			
			CMP.W #0,D3			
			BNE PRCOMP			
			
			MOVE.L #0,D0		* Tamano = 0 -> d0=0
			BRA FPRINT
			
PRCOMP		CMP.W #0,D2
			BEQ APRINT			* Descriptor = 0 -> Linea a
			CMP.W #1,D2
			BEQ BPRINT			* Descriptor = 1 -> Linea b
			
			MOVE.L #$ffffffff,D0
			BRA FPRINT
************
APRINT		MOVE.L #2,D0
			MOVE.B (A3)+,D1
			BSR ESCCAR
			CMP.L #$ffffffff,D0		* Si el buffer esta lleno termina
			BNE APRSUM
			
FAPRINT		MOVE.L D4,D0			* Metemos en d0 el numero de caracteres escritos
			CMP.L #0,D4				* Caracteres escritos = 0 -> termina
			BEQ FPRINT
			MOVE.W SR,D5
			MOVE.W #$2700,SR		* Desactiva interrupciones
			BSET #0,IMRCHECK
			MOVE.B IMRCHECK,IMR
			MOVE.W D5,SR
			BRA FPRINT
			
APRSUM		ADD.L #1,D4
			CMP.L D4,D3				* Compara el tamano con el contador
			BNE APRINT
			BRA FAPRINT
************
BPRINT		MOVE.L #3,D0
			MOVE.B (A3)+,D1
			BSR ESCCAR
			CMP.L #$ffffffff,D0		* Si el buffer esta lleno termina
			BNE BPRSUM
			
FBPRINT		MOVE.L D4,D0
			CMP.L #0,D4				* Metemos en d0 el numero de caracteres escritos
			BEQ FPRINT				* Caracteres escritos = 0 -> termina
			MOVE.W SR,D5
			MOVE.W #$2700,SR		* Desactiva interrupciones
			BSET #4,IMRCHECK
			MOVE.B IMRCHECK,IMR
			MOVE.W D5,SR
			BRA FPRINT
			
BPRSUM		ADD.L #1,D4
			CMP.L D4,D3				* Compara el tamano con el contador
			BNE BPRINT
			BRA FBPRINT
************
FPRINT		MOVE.L -4(A6),A3 
			MOVE.L -8(A6),D2
			MOVE.L -12(A6),D3
			MOVE.L -16(A6),D4
			MOVE.L -20(A6),D5
			UNLK A6
			RTS
			
			
*********************************		
* RTI
*********************************
RTI			LINK A6,#-12
			MOVE.L D0,-4(A6)   
			MOVE.L D1,-8(A6)
			MOVE.L D2,-12(A6)
			
			MOVE.B ISR,D2
			MOVE.B IMRCHECK,D1
			AND.B D1,D2
			BTST #1,D2
			BNE RTIRA		* Recepcion por linea A
			BTST #5,D2
			BNE RTIRB		* Recepcion por linea B
			BTST #0,D2
			BNE RTITA		* Transmision por linea A
			BTST #4,D2
			BNE RTITB		* Transmision por linea B
************
RTIRA		MOVE.B RBA,D1
			MOVE.L #0,D0
			BSR ESCCAR		* Escribe el dato en el buffer
			BRA FRTI
************
RTIRB		MOVE.B RBB,D1
			MOVE.L #1,D0
			BSR ESCCAR		* Escribe el dato en el buffer
			BRA FRTI
************
RTITA		MOVE.B #2,D0
			BSR LEECAR		* Lee 1 dato y lo pone en d0
			
			CMP.L #$ffffffff,D0		* Si D0 es -1 deshabilita interrupciones
			BNE OKRTITA
			
			BCLR #0,IMRCHECK
			MOVE.B IMRCHECK,IMR
			BRA FRTI
			
OKRTITA		MOVE.B D0,TBA
			BRA FRTI
************
RTITB		MOVE.B #3,D0
			BSR LEECAR 		* Lee 1 dato y lo pone en d0
			
			CMP.L #$ffffffff,D0 	* Si D0 es -1 deshabilita interrupciones
			BNE OKRTITB
			
			BCLR #0,IMRCHECK
			MOVE.B IMRCHECK,IMR	
			BRA FRTI 			
			
OKRTITB		MOVE.B D0,TBB	
			BRA FRTI
************
FRTI		MOVE.L -4(A6),D0
			MOVE.L -8(A6),D1
			MOVE.L -12(A6),D2
			UNLK A6
			RTE				* Fin RTI
			
*********************************		
* START
*********************************
START	 	BSR INIT
		*BRA CASO1
		RTS

*********************************
* PRUEBAS
*********************************
CASO1	MOVE.L #0,D0
		MOVE.L #1,D1
		BSR ESCCAR
		MOVE.L #0,D0
		BSR LEECAR
		BREAK

CASO2	MOVE.L #0,D0
		MOVE.L D2,D1
		BSR ESCCAR
		MOVE.L #0,D0
		BSR LEECAR
		ADD.L #1,D2
		CMP.L #2002,D2
		BNE CASO2
		BREAK
