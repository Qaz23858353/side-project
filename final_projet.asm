;抽鬼牌
;411262764張致寧
;411261564 黃柏勛
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

INCLUDE Irvine32.inc

.data
deck dword 53 dup (?)
player1 dword 14 dup(0)
player2_count dword 13
player3_count dword 13
player4_count dword 13
player1_count dword 14
player2 dword 13 dup(0)
player3 dword 13 dup(0)
player4 dword 13 dup(0)
player_offset dword ?
deck_ptr dword offset deck
ranNum dword ?
message_suit1 byte "黑桃",0
message_suit2 byte "紅心",0
message_suit3 byte "方塊",0
message_suit4 byte "梅花",0
message_suit5 byte "鬼牌",0
message_player byte "玩家手牌：",0
message_player2_count byte "玩家2還有多少牌：",0
message_player2 byte "玩家2手牌：",0
message_player3 byte "玩家3手牌：",0
message_player4 byte "玩家4手牌：",0
message_player2_zero byte "玩家2沒牌跳過",0
message_player1_zero byte "玩家沒牌",0
message_what_want_to_choose byte "要選哪張:",0
erro_massege byte "重選",0
flag dword ?
player dword ?
player_count dword 0
choose dword 0
p1 dword 0
message_lost_player1 byte "玩家1輸了！",0
message_lost_player2 byte "玩家2輸了！",0
message_lost_player3 byte "玩家3輸了！",0
message_lost_player4 byte "玩家4輸了！",0

end_game_flag dword 0
z_flag dword 0
.code
main proc
	call initializeDeck			; 初始化牌組

	call shuffles				; 洗牌
	call fapie                  ;發牌

    call writeall;丟牌前所有人的手牌
    mov ecx,player1_count
    mov esi, offset player1   ; 玩家1的手牌位置
    call look
    mov eax, 0Ah  
    call WriteChar  ;換行
     mov eax, 0Ah  
    call WriteChar  ;換行

   ;全部玩家丟牌
    mov ecx,player1_count
    mov esi, offset player1
    call bubbleSort 
    mov ecx,player1_count
    mov esi, offset player1
    mov player,offset player1
    call dio_pie
    mov player1_count,edi

    mov ecx,player2_count
    mov esi, offset player2   
    call bubbleSort 
    mov ecx,player2_count
    mov esi, offset player2
    mov player,offset player2
    call dio_pie
    mov player2_count,edi

    mov ecx,player3_count
    mov esi, offset player3   
    call bubbleSort 
    mov ecx,player3_count
    mov esi, offset player3
    mov player,offset player3
    call dio_pie
    mov player3_count,edi


    mov ecx,player4_count
    mov esi, offset player4   
    call bubbleSort 
    mov ecx,player4_count
    mov esi, offset player4
    mov player,offset player4
    call dio_pie
    mov player4_count,edi


    






 game_loop:  ;遊戲迴圈
 mov esi,offset player1   ;判斷遊戲狀況
    mov ecx,player1_count
    mov ebx,1
    call game_check
    cmp end_game_flag,0
    jne l22

    mov esi,offset player2
    mov ecx,player2_count
     mov ebx,2
    call game_check
    cmp end_game_flag,0
    jne l22

     mov esi,offset player3
    mov ecx,player3_count
     mov ebx,3
    call game_check
    cmp end_game_flag,0
    jne l22

    mov esi,offset player4
    mov ecx,player4_count
     mov ebx,4
    call game_check
     cmp end_game_flag,0
    jne l22
 call writeall
   
    cmp player2_count,0
    je n1
    mov ecx,player1_count   ;1抽2
    mov esi, offset player1   ; 玩家1的手牌位置
    call look
    mov eax, 0Ah  
    call WriteChar  ;換行
    mov edx,offset message_player2_count   ;玩家2聖牌數
    call WriteString
    mov eax,player2_count
    call WriteDec
     mov eax, 0Ah  
    call WriteChar
    call player_choose    ;玩家選牌



    cmp player1_count,1   ;剩一張部用排序也不用丟牌
    je  n1
    cmp player1_count,0
    je n1
    mov ecx,player1_count   ;抽完丟牌
    mov esi, offset player1
    call bubbleSort 
    mov ecx,player1_count
    mov esi, offset player1
    mov player,offset player1
    call dio_pie
    mov player1_count,edi

    
  
n1:
     cmp player3_count,0
    je n2
    mov ebx,player3_count   ;2抽3
    mov ecx,player2_count
    mov esi,offset player2
    mov edi,offset player3
    call cmp_choose
    add player2_count,1
    sub player3_count,1

 

    cmp player2_count,1   ;剩一張部用排序也不用丟牌
    je  n2
    cmp player2_count,0
    je n2
    mov ecx,player2_count   ;抽完丟牌
    mov esi, offset player2
    call bubbleSort 
    mov ecx,player2_count
    mov esi, offset player2
    mov player,offset player2
    call dio_pie
    mov player2_count,edi



n2:
      cmp player4_count,0
    je n3
    mov ebx,player4_count   ;3抽4
    mov ecx,player3_count
    mov esi,offset player3
    mov edi,offset player4
    call cmp_choose
    add player3_count,1
    sub player4_count,1

 

    cmp player3_count,1   ;剩一張部用排序也不用丟牌
    je  n3
    cmp player3_count,0
    je n3
    mov ecx,player3_count   ;抽完丟牌
    mov esi, offset player3
    call bubbleSort 
    mov ecx,player3_count
    mov esi, offset player3
    mov player,offset player3
    call dio_pie
    mov player3_count,edi


   
n3:
      cmp player1_count,0
    je game_loop
    mov ebx,player1_count   ;4抽1
    mov ecx,player4_count
    mov esi,offset player4
    mov edi,offset player1
    call cmp_choose
    add player4_count,1
    sub player1_count,1



    cmp player4_count,1   ;剩一張部用排序也不用丟牌
    je  game_loop
    cmp player4_count,0
    je game_loop
    mov ecx,player4_count   ;抽完丟牌
    mov esi, offset player4
    call bubbleSort 
    mov ecx,player4_count
    mov esi, offset player4
    mov player,offset player4
    call dio_pie
    mov player4_count,edi

    mov esi,offset player1   ;判斷遊戲狀況
    mov ecx,player1_count
    mov ebx,1
    call game_check
     cmp end_game_flag,0
    jne l22

    mov esi,offset player2
    mov ecx,player2_count
     mov ebx,2
    call game_check
     cmp end_game_flag,0
    jne l22

     mov esi,offset player3
    mov ecx,player3_count
     mov ebx,3
    call game_check
     cmp end_game_flag,0
    jne l22

    mov esi,offset player4
    mov ecx,player4_count
     mov ebx,4
    call game_check
    cmp end_game_flag,0
    jne l22
 
  jmp game_loop
l22:
   cmp end_game_flag,1   ;判斷書家
   je lost_1
   cmp end_game_flag,2
   je lost_2
   cmp end_game_flag,3
   je lost_3
   cmp end_game_flag,4
   je lost_4
lost_1:
   mov edx,offset message_lost_player1
   call WriteString
   ret
lost_2:
   mov edx,offset message_lost_player2
   call WriteString
   ret
lost_3:
   mov edx,offset message_lost_player3
   call WriteString
   ret
lost_4:
   mov edx,offset message_lost_player4
   call WriteString
   ret
main endp
;****************************************

initializeDeck proc
    mov ecx, 52                    ; 設置迴圈次數為 52 張牌
    mov eax, 0101h                 ; AH=0, AL=1, 初始牌面數字為 1（牌面數字：1，花色：0）
Start:
    mov esi, deck_ptr              ; 將 deck_ptr 指向的地址存儲到 esi
    mov [esi], eax                 ; 將 eax（包含花色與牌面數字）存儲到牌組位置
    cmp al, 13                     ; 當牌面數字達到 13 時，切換花色
    je J1
    inc eax                        ; 增加牌面數字
    add deck_ptr, sizeof dword     ; 移動到下一張牌的位置
    loop Start                     ; 重複 52 次
J1:
    mov al, 1                      ; 重置牌面數字為 1
    inc ah                         ; 增加花色
    add deck_ptr, sizeof dword     ; 移動到下一張牌的位置
    loop Start                     ; 重複 52 次

    ; 添加鬼牌
    mov eax, 0                     ; 使用 0 表示鬼牌
    mov esi, deck_ptr              ; 指向目前牌組的下一個位置
    mov [esi], eax                 ; 將鬼牌存入牌組

    ret
initializeDeck endp


;****************************************
shuffles proc
	mov ecx, 53
	call Randomize						;re-seed generator
	mov deck_ptr, offset deck			;deck[i=0]
L1:
	mov esi, deck_ptr
	mov eax, [esi]
	push deck_ptr
	push eax

	mov eax, 53							;get random 0 to 53
	call RandomRange
	mov ranNum,eax						;save random number
	mov edx, sizeof dword
	mul edx
	mov deck_ptr, offset deck
	add deck_ptr, eax					;deck[random]

	mov esi, deck_ptr
	mov edx, [esi]						;edx = deck[random]
	pop eax
	mov [esi], eax						;deck[random] = deck[i]
	pop deck_ptr
	mov esi, deck_ptr
	mov [esi], edx						;deck[i] = edx

	add deck_ptr, sizeof dword			;deck[i++]
	loop L1
	mov deck_ptr, offset deck			;deck_ptr -> deck[0]
	ret
shuffles endp

fapie proc   ;發牌
mov ecx, 14              ;玩家1發14張
mov esi, offset deck ; deck_ptr
mov edi, offset player1 

L1:
    mov eax, [esi]    
    mov [edi], eax          
    add edi, sizeof dword  
    add esi, sizeof dword 
    loop L1                 
mov ecx,13             ;玩家2發13張
mov edi, offset player2
L2:
   mov eax, [esi]     
    mov [edi], eax          
    add edi, sizeof dword   
    add esi, sizeof dword 
	loop L2
mov ecx,13
mov edi, offset player3
L3:                       ;玩家3發13張
   mov eax, [esi]    
    mov [edi], eax          
    add edi, sizeof dword   
    add esi, sizeof dword 
	loop L3
mov ecx,13
mov edi, offset player4
L4:                        ;玩家4發13張
   mov eax, [esi]     
    mov [edi], eax         
    add edi, sizeof dword   
    add esi, sizeof dword 
	loop L4
  
  ret
fapie endp


look proc   ;看牌
    mov edx, offset message_player   
    call WriteString
    cmp ecx,0
    je zero
L1:


    mov eax, [esi]   
    
    cmp eax, 0     ;判斷花色
    je ghost
    cmp ah, 1                
    je black1
    cmp ah, 2
    je red1
    cmp ah, 3
    je fun
    cmp ah, 4
    je mei
goback:
    mov ah, 0
   
    call WriteDec             ; 顯示數字
    mov eax, " "              ; 顯示空格
    call WriteChar            ; 顯示空格
    add esi, sizeof dword     ; 移動到下一張牌
    loop L1                   ; 循環直到顯示所有手牌
    ret

black1:
    mov edx, offset message_suit1    ; 顯示黑桃
    call WriteString
    jmp goback

red1:
    mov edx, offset message_suit2    ; 顯示紅心
    call WriteString
    jmp goback

fun:
    mov edx, offset message_suit3    ; 顯示方塊
    call WriteString
    jmp goback

mei:
    mov edx, offset message_suit4    ; 顯示梅花
    call WriteString
    jmp goback
ghost:
    mov edx, offset message_suit5    ; 顯示鬼牌
    call WriteString
    jmp goback
zero:
    mov edx, offset message_player1_zero   
    call WriteString
    ret
ret
look endp
;-----------------------------------------------------------------------------------------------



bubbleSort proc  ;泡泡排序
        
    dec ecx                        
          

outer_loop:
    mov edi, esi                   
    mov ebx, ecx                

inner_loop:
   
    mov eax, [edi]                ;前一張
    mov edx, [edi + 4]             ;下一張

   
    movzx eax, al                  ;數字部分
    movzx edx, dl                 

    cmp eax, edx                  ;如果前面比較小就不用交換
    jna skip_swap                  

   
    mov eax, [edi]                 ;前面比較大交換
    mov edx, [edi + 4]             
    mov [edi], edx               
    mov [edi + 4], eax             

skip_swap:
   
    add edi, sizeof dword          
    dec ebx                      
    jnz inner_loop               

    
    dec ecx                       
    jnz outer_loop                

    ret
bubbleSort endp






dio_pie proc   ;丟牌
    ; ESI: 指向玩家手牌的起始地址
    ; ECX: 玩家手牌數量

    mov edi, esi           ; EDI: 指向新的手牌位置

L1:
    ; 確認是否還有未處理的卡片
    cmp ecx, 0             ; 如果剩餘卡片為 0，結束
    je finalize

    ; 提取當前卡片點數
    mov eax, [esi]         ; 當前卡片
    movzx ebx, al          ; 提取當前卡片的點數（低位字節）

    ; 移動到下一張卡片（但暫時保留當前卡片）
    add esi, sizeof dword  ; 移動來源指標
    dec ecx                ; 減少剩餘卡片數

    ; 檢查是否有相同點數的卡片
    mov flag, 0            ; 初始化標誌位（是否發現重複）

L2:
    cmp ecx, 0             ; 如果剩餘卡片數為 0，結束內層檢查
    je finalize_check

    mov edx, [esi]         ; 提取下一張卡片
    movzx edx, dl          ; 提取下一張卡片的點數

    cmp ebx, edx           ; 比較點數
    jne finalize_check     ; 如果點數不同，跳過檢查

    ; 發現相同點數，設置標誌位
    mov flag, 1            ; 標誌位設置為 1
    add esi, sizeof dword  ; 跳過重複卡片
    dec ecx                ; 減少剩餘卡片數
    jmp L2                 ; 繼續檢查下一張卡片

finalize_check:
    cmp flag, 1            ; 檢查標誌位
    je skip_card           ; 如果有重複卡片，跳過保存

    ; 如果沒有重複，保留當前卡片
    mov [edi], eax         ; 將當前卡片保存到新區域
    add edi, sizeof dword  ; 更新目標指標

skip_card:
    jmp L1                 ; 繼續處理下一張卡片

finalize:
    ; 更新玩家手牌數量
    sub edi, player ; 計算新手牌長度（以位元組計算）
    shr edi, 2              ; 換算成卡片數量
   
    ret
dio_pie endp






player_choose proc   ;玩家選牌
choose_another:
    cmp player2_count,0
    je zero
    mov edx, offset message_what_want_to_choose   
    call WriteString
    call ReadInt
    mov choose, eax
    cmp eax,player2_count
    ja return
    cmp eax,0
    je return
    jna return
    mov ebx,choose
    sub choose,1
    shl choose,2  ;在玩家2中的位置

    mov esi,offset player1   ;玩家1頭
    mov edi,offset player2   ;玩家2頭

    add edi,choose   ;要抽的牌
    mov eax,[edi]    ;那張牌
    mov ecx,player1_count
    shl ecx,2
    add esi,ecx     ;玩家一的最後一張家一
    mov [esi],eax
    add player1_count,1

    ;重玩家2手牌移除
    mov ecx,player2_count   ;選最後一張直接移除
    cmp ecx,ebx
    je n2
    sub ecx,ebx
    
    add edi,4
deleate_loop:     ;把抽走的牌刪掉 把後面的往前移
    mov eax, [edi]                    
    mov esi,edi
    sub esi, 4                        
    mov [esi], eax                     
    add edi, 4                        
    dec ecx                            
    cmp ecx,0
    jnz deleate_loop                     
    je n
n2:
  sub player2_count,1
  ret
n:
 sub player2_count,1
 ret

 return:
    mov edx, offset erro_massege   
    call WriteString
     mov eax, 0Ah  
    call WriteChar 
    jmp choose_another
zero:
     mov edx, offset message_player2_zero   
    call WriteString
     mov eax, 0Ah  
    call WriteChar 
    ret
player_choose endp




    












;--------------------------------------------------------------------



cmp_choose proc   ;電腦選牌
    mov eax,ebx
    cmp ebx,0
    je n2
    call RandomRange
	mov ranNum,eax    ;亂數0-ebx
    mov p1,eax
    shl ranNum,2   ;換成bite
    add edi,ranNum   ;要抽的卡
    mov eax,[edi]    ;放到eax
    shl ecx,2        ;放到最後一張 位移量
    add esi,ecx
    mov [esi],eax    ;放到最後一張

   
    cmp p1,ebx      ;選到最後一張直接移除   ebx下一個玩家  p1亂數
    je n2
    mov ecx,ebx
    sub ecx,p1
    
    add edi,4
deleate_loop:        ;山牌
    mov eax, [edi]                     
    mov esi,edi
    sub esi, 4                          
    mov [esi], eax                     
    add edi, 4                          
    dec ecx                            
    cmp ecx,0
    jnz deleate_loop                    
    je n2
n2:
 
  ret


    



cmp_choose endp


game_check proc      ;遊戲狀況
    ; esi: 玩家手牌地址
    ; eax: 傳入的條件（暫未使用，但保留接口）
    ;ebx 玩家幾
  
    cmp ecx, 1             ; 檢查手牌是否只剩一張
    jne gc_end             ; 若不只剩一張牌，跳過檢查

    mov edx, [esi]       ; 取玩家手上第一張牌的數值
    cmp edx, 0             ; 檢查這張牌是否為 0
    jne gc_end             ; 若不是 0，跳過檢查

    ; 符合條件，遊戲結束
    call writeall          ; 輸出所有玩家狀態
    mov end_game_flag, ebx             ; 設置 enp_game_flag代表輸家
   
    ret

gc_end:
    ret                    ; 返回
game_check endp






writeall proc     ;看所有人的排
    
mov ecx,player2_count    
   mov edx,offset message_player2   
   call WriteString
    mov esi, offset player2   
    call look
    mov eax, 0Ah  
    call WriteChar
     mov eax,player2_count
     call WriteDec
     mov eax, 0Ah  
    call WriteChar
    mov edx,offset message_player3  
   call WriteString
mov ecx,player3_count
    mov esi, offset player3  
    call look
    mov eax, 0Ah  
    call WriteChar
     mov eax,player3_count
     call WriteDec
     mov eax, 0Ah  
    call WriteChar
    mov edx,offset message_player4  
   call WriteString
mov ecx,player4_count
    mov esi, offset player4   
    call look
    mov eax, 0Ah  
    call WriteChar
     mov eax,player4_count
     call WriteDec
     mov eax, 0Ah  
    call WriteChar
    ret
writeall endp



end main