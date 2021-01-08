; Snake
;guia de registradores
;r0 uso geral, 
;r1 uso geral, enderecos do mapa
;r2 uso geral, cores
;r3 uso geral, usar em funcoes complexas
;r4 uso geral, funcoes complexas
;r5 usado para desenhar mapa
;r6 velocidade, nao use para nada alem disso, pois registra o loop de delay
;r7 nao usado

;parede ta com mod 20

PosicaoCobra:  	var #500 ; tamanho MAXIMO da snake
TamanhoCobra:	var #1
Dir:		var #1 ; 0-right, 1-down, 2-left, 3-up


PortalSup: var #1
PortalDown: var #1
PortalDir: var #1
PortalEsq: var #1

PosicaoComida:	var #1
StatusComida:	var #1
Unidade: var #1
Dezena: var #1
Centena: var #1

Stage: var #1
Velocidade: var #1



GameOverMessage: 	string "Nao consegue ne Moises"
EraseGameOver:		string "                      "
RestartMessage:		string " 'Espaco' pra tentar denovo "
EraseRestart:		string "                            "



; Main
main:
	

	loadn R1, #TelaApresentacao00	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #2816
	call Draw_Stage
	call PrecioneQualquerTecla
	call inicialize_Velocidade
	call Initialize
	
	
	loadn R1, #tela1Linha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #0
	call Draw_Stage
	
	
	call inicialize_score	
	
	
	loop:
		
		ingame_loop:
			call Draw_Snake
			
			call stage_checker
			
			call Move_Snake
			call Replace_Food
					
			call Delay
				
				
			jmp ingame_loop
		
		GameOver_loop:
			call Restart_Game
		
			jmp GameOver_loop
	
; Funções





PrecioneQualquerTecla:	
	loadn r0, #255	; No inchar, se nenhuma tecla estiver precisonada ele retorna 255
	
	PrecioneQualquerTeclaLoop:
		inchar r1		; Le teclado. Se nada for digitado entao r0 = 255
		cmp r1, r0		; Compara r0 = 255 e r1, eh igual se nao pressionar tecla.
		jeq PrecioneQualquerTeclaLoop	; Fica lendo ate digitar uma tecla
	
	rts 	; retorno da funcao PrecioneQualquerTecla

	
	
stage_checker:
	
	load r3, Stage
	loadn r4, #48
	

	cmp r3,r4
	jeq stage0
	
	cmp r3,r4
	jeq stage1
	
	stage0:
	call Dead_Snake_0	
	jmp fim

	stage1:
	;call Dead_Snake_1	
	jmp fim
	
	fim:
	rts	

inicialize_score:
	
	loadn r0, #48
	store Unidade, r0
	store Dezena ,r0
	store Centena ,r0
	loadn r1, #51
	load r2, Unidade
	
	outchar r2, r1
	
	loadn r1, #50
	load r2, Dezena
	outchar r2, r1
	
	loadn r1, #49
	load r2, Centena
	outchar r2, r1
	 
	rts

inicialize_Velocidade:
	;velocidade original
	loadn r0, #9000
	store Velocidade, r0
		 
	rts
	
Initialize:
		push r0
		push r1
		
		loadn 	r0, #PortalSup
		loadn 	r1, #235
		storei 	r0, r1
		
		loadn 	r0, #PortalDown ;esse entra
		loadn 	r1, #1085
		storei 	r0, r1
		
		loadn 	r0, #PortalDir ;esse entra
		loadn 	r1, #1115
		storei 	r0, r1
		
		loadn 	r0, #PortalEsq
		loadn 	r1, #205
		storei 	r0, r1
		
		
		
		
		loadn r0, #2
		store TamanhoCobra, r0
		
		; PosicaoCobra[0] = 460
		loadn 	r0, #PosicaoCobra
		loadn 	r1, #450
		storei 	r0, r1
		
		; PosicaoCobra[1] = 459
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; PosicaoCobra[2] = 458
		inc 	r0
		dec 	r1
		storei 	r0, r1
		

		
		; PosicaoCobra[4] = -1
		inc 	r0
		loadn 	r1, #0
		storei 	r0, r1
				
		call ImprimirCobraPrima
		
		
		loadn r0, #1
		store Dir, r0
		
		pop r1
		pop r0
		
		rts

ImprimirCobraPrima:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #PosicaoCobra		; r0 = & PosicaoCobra
	loadn r1, #253			; r1 = '='
	loadn r3 ,#3072 ;cor
	add r1, r1, r3
	loadi r2, r0			; r2 = PosicaoCobra[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop
	
	
	loadn 	r0, #820
	loadn 	r1, #2346
	outchar r1, r0
	store 	PosicaoComida, r0
	
	loadn 	r0, #PortalSup
	loadn 	r1, #253
	outchar r1, r0
	
	loadn 	r0, #PortalDown
	loadn 	r1, #253
	outchar r1, r0
	loadn 	r0, #PortalDir
	loadn 	r1, #3581
	outchar r1, r0
	
	loadn 	r0, #PortalEsq
	loadn 	r1, #3581
	outchar r1, r0
	
	
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts
	
EraseSnake:
	push r0
	push r1
	push r2
	push r3
	
	loadn 	r0, #PosicaoCobra		; r0 = & PosicaoCobra
	inc 	r0
	loadn 	r1, #' '			; r1 = ' '
	loadi 	r2, r0			; r2 = PosicaoCobra[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts



Draw_Stage:
	
	push r0	; protege o r0 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para ser usado na subrotina
	push r2	; protege o r2 na pilha para ser usado na subrotina
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   ImprimeTela_Loop:
		call ImprimeStr
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela_Loop	; Enquanto r0 < 1200

	pop r5	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------------	
;********************************************************
;                   IMPRIME STRING
;********************************************************
	
ImprimeStr:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	
	loadn r3, #'\0'	; Criterio de parada

   ImprimeStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp ImprimeStr_Loop
	
   ImprimeStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	

Move_Snake:
	push r0	; Dir / PosicaoCobra
	push r1	; inchar
	push r2 ; local helper
	push r3
	push r4
	
	; Sincronização
	loadn 	r0, #5000
	loadn 	r1, #0
	mod 	r0, r6, r0		; r1 = r0 % r1 (Teste condições de contorno)
	cmp 	r0, r1
	jne Move_End
	; =============
	Check_portal_Vertical:
		load r0, PortalDown
		loadn r1, #PosicaoCobra
		loadi 	r2, r1
		
		cmp r0, r2
		jne Check_portal_Horizontal
		;se for igual, cabeca da cobra vai pra portal 2
		load r1, PortalSup
		store PosicaoCobra,r1
		
	Check_portal_Horizontal:
		load r0, PortalDir 
		loadn r1, #PosicaoCobra
		loadi 	r2, r1
		
		cmp r0, r2
		jne Check_Food
		;se for igual, cabeca da cobra vai pra portal 2
		load r1, PortalEsq
		store PosicaoCobra,r1
		
	
	
	Check_Food:
		load 	r0, PosicaoComida ; posição da comida
		loadn 	r1, #PosicaoCobra ; posição da snake
		loadi 	r2, r1
		
		cmp r0, r2 ; verificando se a posição da comida é igual a da snake
		jne Spread_Move	
		
		call Increment_score ; chamando função que incrementa a pontuação
		
		load 	r0, TamanhoCobra
		inc 	r0
		store 	TamanhoCobra, r0
		
		loadn 	r0, #0
		dec 	r0
		store 	StatusComida, r0
		
	Spread_Move:
		loadn 	r0, #PosicaoCobra
		loadn 	r1, #PosicaoCobra
		load 	r2, TamanhoCobra
		
		add 	r0, r0, r2		; r0 = PosicaoCobra[Size]
		
		dec 	r2				; r1 = PosicaoCobra[Size-1]
		add 	r1, r1, r2
		
		loadn 	r4, #0
		
		Spread_Loop:
			loadi 	r3, r1
			storei 	r0, r3
			
			dec r0
			dec r1
			
			cmp r2, r4
			dec r2
			
			jne Spread_Loop	
	
	Change_Dir:
		inchar 	r1
		
		loadn r2, #100	; char r4 = 'd'
		cmp r1, r2
		jeq Move_D
		
		loadn r2, #115	; char r4 = 's'
		cmp r1, r2
		jeq Move_S
		
		loadn r2, #97	; char r4 = 'a'
		cmp r1, r2
		jeq Move_A
		
		loadn r2, #119	; char r4 = 'w'
		cmp r1, r2
		jeq Move_W		
		
		jmp Update_Move
	
		Move_D:
			loadn 	r0, #0
			; Impede de "ir pra trás"
			loadn 	r1, #2
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Left
			
			store 	Dir, r0
			jmp 	Move_Right
		Move_S:
			loadn 	r0, #1
			; Impede de "ir pra trás"
			loadn 	r1, #3
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Up
			
			store 	Dir, r0
			jmp 	Move_Down
		Move_A:
			loadn 	r0, #2
			; Impede de "ir pra trás"
			loadn 	r1, #0
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Right
			
			store 	Dir, r0
			jmp 	Move_Left
		Move_W:
			loadn 	r0, #3
			; Impede de "ir pra trás"
			loadn 	r1, #1
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Down
			
			store 	Dir, r0
			jmp 	Move_Up
	
	Update_Move:
		load 	r0, Dir
				
		loadn 	r2, #0
		cmp 	r0, r2
		jeq 	Move_Right
		
		loadn 	r2, #1
		cmp 	r0, r2
		jeq 	Move_Down
		
		loadn 	r2, #2
		cmp 	r0, r2
		jeq 	Move_Left
		
		loadn 	r2, #3
		cmp 	r0, r2
		jeq 	Move_Up
		
		jmp Move_End
		
		Move_Right:
			loadn 	r0, #PosicaoCobra	; r0 = & PosicaoCobra
			loadi 	r1, r0			; r1 = PosicaoCobra[0]
			inc 	r1				; r1++
			storei 	r0, r1
			
			jmp Move_End
				
		Move_Down:
			loadn 	r0, #PosicaoCobra	; r0 = & PosicaoCobra
			loadi 	r1, r0			; r1 = PosicaoCobra[0]
			loadn 	r2, #40
			add 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
		
		Move_Left:
			loadn 	r0, #PosicaoCobra	; r0 = & PosicaoCobra
			loadi 	r1, r0			; r1 = PosicaoCobra[0]
			dec 	r1				; r1--
			storei 	r0, r1
			
			jmp Move_End
		Move_Up:
			loadn 	r0, #PosicaoCobra	; r0 = & PosicaoCobra
			loadi 	r1, r0			; r1 = PosicaoCobra[0]
			loadn 	r2, #40
			sub 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
	
	Move_End:
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0

	rts




Increment_score:
	push r0
	push r1
	push r2
	push r3
	
	load r0 , Unidade ; carregando pontuação atual em r0 
	loadn r3, #'9'
	cmp r0,r3
	
	jeq IncDezena
	jmp IncUnidade
	
Finalizar_contagem:
	load r0, Unidade
	loadn r2, #51
	loadn r3, #2816
	add r0,r0,r3
	outchar r0, r2
	load r0, Dezena
	loadn r2, #50
	loadn r3, #2816
	add r0,r0,r3
	outchar r0,r2
	load r0, Centena
	loadn r2, #49
	loadn r3, #2816
	add r0,r0,r3
	outchar r0,r2
	
	
	pop r3
	pop r2	
	pop r1	
	pop r0	
	 
	rts 

	
IncDezena:
	loadn r3, #'0'
	store Unidade, r3
	
	loadn r2, #'9'
	load r3, Dezena
	cmp r2, r3
	jeq IncCentena
	
	load r3, Dezena
	inc r3
	Store Dezena, r3
	jmp Finalizar_contagem

IncUnidade:
	load r3, Unidade
	inc r3
	Store Unidade, r3
	jmp Finalizar_contagem

IncCentena:
	loadn r3, #'0'
	store Dezena, r3
	
	load r3, Centena
	inc r3
	store Centena,r3
	jmp Finalizar_contagem



;verificacao da comida
Replace_Food:
	push r0
	push r1
	

	;pego o status da comida e comparo com 0
	loadn 	r0, #0
	dec 	r0
	load 	r1, StatusComida
	cmp 	r0, r1
	;se forem diferentes, vai embora
	jne Replace_End
	
	loadn r1, #0
	store StatusComida, r1
	load  r1, PosicaoComida
	
	load r0, Dir
	;apartir da direcao que a cobra vem
	;vamos escolher o melhor luvgar para substituir
	loadn r2, #0
	cmp r0, r2
	jeq Replace_Right
	
	loadn r2, #1
	cmp r0, r2
	jeq Replace_Down
	
	loadn r2, #2
	cmp r0, r2
	jeq Replace_Left
	
	loadn r2, #3
	cmp r0, r2
	jeq Replace_Up
	;r1 esta com a posicao da comida
	; o foco é colocar a comida em uma posicao melhor
	; a partir de onde a cobra olha, vamos modificar a posicao da comida
	;---------------
	Replace_Right:
		loadn r3, #355
		add r1, r1, r3
		jmp Replace_Boundaries
	Replace_Down:
		loadn r3, #445
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Left:
		loadn r3, #395
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Up:
		loadn r3, #485
		add r1, r1, r3
		jmp Replace_Boundaries
	
	;apos somar ou subtrair, a comida vem para ca
	;ainda tem r1 com posicao da comida alterada
	Replace_Boundaries:
		;aqui o foco é ver se onde a comida parou
		;como trabalhamos com um sistema de somas fechado,
		;se parar em menos de 40,ta fora do mapa, joga pra baixo, pois esta alto
		loadn r2, #40
		cmp r1, r2
		jle Replace_Lower
		
		;se parar em mais de 1160,ta fora do mapa, joga pra cima, pois esta baixo
		loadn r2, #1160
		cmp r1, r2
		jgr Replace_Upper
		
		;agr verifica a posicao nas colunas, mesma coisa de cima
		loadn r0, #40
		loadn r3, #1
		mod r2, r1, r0
		cmp r2, r3
		jel Replace_West
		
		loadn r0, #40
		loadn r3, #39
		mod r2, r1, r0
		cmp r2, r3
		jeg Replace_East
		
		loadn r0, #40
		loadn r3, #20
		mod r2, r1, r0
		cmp r2, r3
		jeg Replace_East
		
		;se esta tudo certo, so printa
		jmp Replace_Update
		;posicoes pre fixadas:
		Replace_Upper:
			loadn r1, #355
			jmp Replace_Update
		Replace_Lower:
			loadn r1, #1005
			jmp Replace_Update
		Replace_East:
			loadn r1, #805
			jmp Replace_Update
		Replace_West:
			loadn r1, #245
			jmp Replace_Update
			
		Replace_Update:
			store PosicaoComida, r1
			loadn r0, #2346
			outchar r0, r1
	
	Replace_End:
		
		pop r1
		pop r0
	
	rts

Dead_Snake_0: ; função para a fase 1 
	loadn r0, #PosicaoCobra
	loadi r1, r0
	
	;bateu na barreira
	
	loadn r2, #40
	loadn r3, #20
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	

	
	
	; Trombou na parede direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; Trombou na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; Trombou na parede de cima
	loadn r2, #160
	cmp r1, r2
	jle GameOver_Activate
	
	; Trombou na parede de baixo
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	; Trombou na própria cobra
	Collision_Check:
		load 	r2, TamanhoCobra
		loadn 	r3, #1
		loadi 	r4, r0			
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Dead_Snake_0_End
	
	GameOver_Activate:
		load 	r0, PosicaoComida
		loadn 	r1, #' '
		outchar r1, r0
		
		
	
	
		loadn r0, #570
		loadn r1, #GameOverMessage
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #RestartMessage
		loadn r2, #0
		call Imprime
		
		jmp GameOver_loop
	
	Dead_Snake_0_End:
	
	rts





Draw_Snake:
	push r0
	push r1
	push r2
	push r3 
	
	
	
	; Sincronização
	loadn 	r0, #1000
	loadn 	r1, #0
	mod 	r0, r6, r0		; r1 = r0 % r1 (Teste condições de contorno)
	cmp 	r0, r1
	jne Draw_End
	
	load 	r0, PortalSup
	loadn 	r1, #253
	outchar r1, r0
	
	load 	r0, PortalDown
	loadn 	r1, #3069
	outchar r1, r0
	
	load 	r0, PortalDir
	loadn 	r1, #3069
	outchar r1, r0
	
	load 	r0, PortalEsq
	loadn 	r1, #253
	outchar r1, r0
	
	load 	r0, PosicaoComida
	loadn 	r1, #2346
	outchar r1, r0
	
	loadn 	r0, #PosicaoCobra	; r0 = & PosicaoCobra
	loadn 	r1, #253		; r1 = '}'
	loadn r3, #3072 ;cor
	add r1,r1, r3
	loadi 	r2, r0			; r2 = PosicaoCobra[0]
	outchar r1, r2			
	
	loadn 	r0, #PosicaoCobra	; r0 = & PosicaoCobra
	loadn 	r1, #' '		; r1 = ' '
	load 	r3, TamanhoCobra	; r3 = TamanhoCobra
	add 	r0, r0, r3		; r0 += TamanhoCobra
	loadi 	r2, r0			; r2 = PosicaoCobra[TamanhoCobra]
	outchar r1, r2
	
	Draw_End:
		pop	r3
		pop r2
		pop r1
		pop r0
	
	rts
;--------------------------------------------------------------------------------------------------------
Delay:
	push r0
	
	inc r6
	load r0, Velocidade
	cmp r6, r0
	jgr Reset_Timer
	
	jmp Timer_End
	
	Reset_Timer:
		loadn r6, #0
	Timer_End:		
		pop r0
	
	rts




Restart_Game:
	inchar 	r0
	loadn 	r1, #' '
	
	cmp r0, r1
	jeq Restart_Activate
	
	jmp Restart_End
	
	Restart_Activate:
		loadn r0, #615
		loadn r1, #EraseGameOver
		loadn r2, #0
		call Imprime
		
		loadn r0, #687
		loadn r1, #EraseRestart
		loadn r2, #0
		call Imprime
		
		call EraseSnake	
		
		
		jmp main
		
		
	Restart_End:
	
	rts


Imprime:
	push r0		; Posição na tela para imprimir a string
	push r1		; Endereço da string a ser impressa
	push r2		; Cor da mensagem
	push r3
	push r4

	
	loadn r3, #'\0'

	LoopImprime:	
		loadi r4, r1
		cmp r4, r3
		jeq SaiImprime
		add r4, r2, r4
		outchar r4, r0
		inc r0
		inc r1
		jmp LoopImprime
		
	SaiImprime:	
		pop r4	
		pop r3
		pop r2
		pop r1
		pop r0
		
	rts
	
	
tela1Linha0  : string "Snake Ver 1.7 Com Portais               "
tela1Linha1  : string "SCORE ==                                "
tela1Linha2  : string "                                        "
tela1Linha3  : string "########################################"
tela1Linha4  : string "#                  #                   #"
tela1Linha5  : string "#                  #                   #"
tela1Linha6  : string "#                  #                   #"
tela1Linha7  : string "#                  #                   #"
tela1Linha8  : string "#                  #                   #"
tela1Linha9  : string "#                  #                   #"
tela1Linha10 : string "#                  #                   #"
tela1Linha11 : string "#                  #                   #"
tela1Linha12 : string "#                  #                   #"
tela1Linha13 : string "#                  #                   #"
tela1Linha14 : string "#                  #                   #"
tela1Linha15 : string "#                  #                   #"
tela1Linha16 : string "#                  #                   #"
tela1Linha17 : string "#                  #                   #"
tela1Linha18 : string "#                  #                   #"
tela1Linha19 : string "#                  #                   #"
tela1Linha20 : string "#                  #                   #"
tela1Linha21 : string "#                  #                   #"
tela1Linha22 : string "#                  #                   #"
tela1Linha23 : string "#                  #                   #"
tela1Linha24 : string "#                  #                   #"
tela1Linha25 : string "#                  #                   #"
tela1Linha26 : string "#                  #                   #"
tela1Linha27 : string "#                  #                   #"
tela1Linha28 : string "#                  #                   #"
tela1Linha29 : string "########################################"	

TelaApresentacao00: string "                                        "
TelaApresentacao01: string "        Snake Ver 1.7 Com Portais       "
TelaApresentacao02: string "                                        "
TelaApresentacao03: string "            Amanda Lindoso              "
TelaApresentacao04: string "                                        "
TelaApresentacao05: string "               Augusto                  "
TelaApresentacao06: string "                                        "
TelaApresentacao07: string "           Guilherme Cremasco           "
TelaApresentacao08: string "                                        "
TelaApresentacao09: string "           Joao Paulo Garcia            "
TelaApresentacao10: string "                                        "
TelaApresentacao11: string "                                        "
TelaApresentacao12: string " Portais Amarelos levam para os Brancos "
TelaApresentacao13: string "                                        "
TelaApresentacao14: string "           Jogo Ainda Em Alfa           "
TelaApresentacao15: string "                                        "
TelaApresentacao16: string "          Comandos Do jogo sao:         "
TelaApresentacao17: string "                                        "
TelaApresentacao18: string "        W  - MOVE PARA CIMA             "
TelaApresentacao19: string "        S  - MOVE PARA BAIXO            "
TelaApresentacao20: string "        A  - MOVE PARA ESQUERDA         "
TelaApresentacao21: string "        D  - MOVE PARA DIREITA          "
TelaApresentacao22: string "                                        "
TelaApresentacao23: string "                                        "
TelaApresentacao24: string "    Qualquer Bug, Entre Em Contato      "
TelaApresentacao25: string "                                        "
TelaApresentacao26: string "               BOM JOGO!                "
TelaApresentacao27: string "                                        "
TelaApresentacao28: string " PRESSIONE QUALQUER TECLA PARA COMECAR  "
TelaApresentacao29: string "                                        "

