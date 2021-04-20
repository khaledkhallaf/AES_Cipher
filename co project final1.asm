
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

INCLUDE 'EMU8086.INC'


MACRO SubBytes
    Local L,then0,else0,then1,else1,then2,else2,then3,else3,then4,else4,then5,else5,then6,else6,then7,else7,then8,else8,then9,else9,then10,else10,then11,else11,then12,else12,then13,else13,then14,else14,then15,else15,terminate
    Mov count,0
    Mov arrCount,0
    Mov ax,0
;First, there is a need to determine which row from the S-box table needed to be selected
;This process is accomplished by splitting the element taken from the given array into its digits
;The row is determined by the first digit
;Second, the corresponding column from the S-box table has to selected
;the column is determined by the second digit

L:   Mov di,arrCount
     Mov al,Arr[di]
     Mov bl,010h
     Div bl  
     Mov bl,al
     Mov al,ah
     Mov ah,0
     Mov si,ax
     Cmp bl,count
     Jz then0
     Jnz else0
     then0: Mov dl,r0[si] 
            Jmp terminate
     else0: Inc count
            Cmp bl,count
            Jz then1
            Jnz else1
     then1: Mov dl,r1[si]
            Jmp terminate
     else1: Inc count
            Cmp bl,count
            Jz then2
            Jnz else2      
     then2: Mov dl,r2[si] 
            Jmp terminate
     else2: Inc count
            Cmp bl,count
            Jz then3
            Jnz else3
     then3: Mov dl,r3[si]
            Jmp terminate
     else3: Inc count
            Cmp bl,count
            Jz then4
            Jnz else4
     then4: Mov dl,r4[si]
            Jmp terminate
     else4: Inc count
            Cmp bl,count
            Jz then5
            Jnz else5
     then5: Mov dl,r5[si]
            Jmp terminate
     else5: Inc count
            Cmp bl,count
            Jz then6
            Jnz else6
     then6: Mov dl,r6[si]
            Jmp terminate
     else6: Inc count
            Cmp bl,count
            Jz then7
            Jnz else7
     then7: Mov dl,r7[si]
            Jmp terminate
     else7: Inc count
            Cmp bl,count
            Jz then8
            Jnz else8
     then8: Mov dl,r8[si]
            Jmp terminate
     else8: Inc count
            Cmp bl,count
            Jz then9
            Jnz else9
     then9: Mov dl,r9[si]
            Jmp terminate
     else9: Inc count
            Cmp bl,count
            Jz then10
            Jnz else10
     then10: Mov dl,r10[si] 
             Jmp terminate
     else10: Inc count
            Cmp bl,count
            Jz then11
            Jnz else11
     then11: Mov dl,r11[si]
             Jmp terminate
     else11: Inc count
            Cmp bl,count
            Jz then12
            Jnz else12
     then12: Mov dl,r12[si]
             Jmp terminate
     else12: Inc count
            Cmp bl,count
            Jz then13
            Jnz else13
     then13: Mov dl,r13[si]
             Jmp terminate
     else13: Inc count
            Cmp bl,count
            Jz then14
            Jnz else14
     then14: Mov dl,r14[si]
             Jmp terminate
     else14: Inc count
             Cmp bl,count
             Jz then15
     then15: Mov dl,r15[si]   
     
;Third,placing the obtained element from the S-box table in its right place in the given array (Substitution Process)     
     terminate: Mov Arr[di],dl
                Inc arrCount
                Cmp arrCount,16
                Mov count,0
                Jnz L                  
ENDM
MACRO ShiftRows 
  mov position,4
  mov count1,4
  mov shift,1
  mov sp,16
  ;we need to shift every element in a row to the left by its row_Order-1 
  ;if the element is in the first row it will be shifted to the left by zero (1-1)
  ;and if it is in the second row it will be shifted to the left by one(2) and so on 
  ;until we reach the elements in the last row   
  ;if the index of element after the shift is less than 0 we add 4 to it (Rotate the element)
  
  
    L11:mov si,position 
      mov ah,arr[si]
      inc si
      mov al,arr[si]
      inc si
      mov ch,arr[si]
      inc si
      mov cl,arr[si]
      inc si 
      mov di,position
      sub di,shift
      cmp di,count1
      js move1
      mov arr[di],ah
      c1:inc position
      mov di,position
      sub di,shift
      cmp di,count1
      js move2
      mov arr[di],al
      c2:inc position
      mov di,position
      sub di,shift
      cmp di,count1
      js move3
      mov arr[di],ch
      c3:inc position
      mov di,position
      sub di,shift
      cmp di,count1
      js move4
      mov arr[di],cl
      inc shift
      add count1,4
      inc position
      cmp sp,position
      jz end
      jmp L11
      
move1:add di,4
      mov arr[di],ah
      jmp c1
      
move2:add di,4
      mov arr[di],al
      jmp c2
      
move3:add di,4
      mov arr[di],ch
      jmp c3
      
move4:add di,4
      mov arr[di],cl      
      inc shift
      add count1,4
      inc position
      cmp sp,position
      jz end
      jmp L11
                     
end: 
ENDM  
MACRO MixColumns
LOCAL step1,step2,step3,step4,transfer,column1,column2,column3,column4,GaloisTest,Galois1,continue01,continue11,sum1,Galois2,continue02,continue12,sum2,Galois3,continue03,continue13,sum3,Galois4,continue04,continue14,sum4,terminate    
    Mov countTransform,0 
    Mov countcolumn,0
    Mov countMatrix,1
    Mov countGalois,1
    Mov firstPlace,0
    Mov secondPlace,0
    Mov thirdPlace,0
    Mov fourthPlace,0    
    
    ;The process of getting elements from the given array and placing them in individual sub-arrays
    ;This process consists of four steps where in each step one column of the four columns in the given array is placed
    ;in an individual sub-array
      
      
     step1: Mov bp,countTransform
           Mov di,countcolumn
           Mov bl,Arr[bp]
           Mov col1[di],bl
           Add countTransform,4
           Inc countcolumn
           Cmp countcolumn,4
           Jnz step1
     Mov countcolumn,0
     Mov countTransform,1 
    step2: Mov bp,countTransform
           Mov di,countcolumn
           Mov bl,Arr[bp]
           Mov col2[di],bl
           Add countTransform,4
           Inc countcolumn
           Cmp countcolumn,4
           Jnz step2    
     Mov countcolumn,0
     Mov countTransform,2 
    step3: Mov bp,countTransform
           Mov di,countcolumn
           Mov bl,Arr[bp]
           Mov col3[di],bl
           Add countTransform,4
           Inc countcolumn
           Cmp countcolumn,4
           Jnz step3        
     Mov countcolumn,0
     Mov countTransform,3 
    step4: Mov bp,countTransform
           Mov di,countcolumn
           Mov bl,Arr[bp]
           Mov col4[di],bl
           Add countTransform,4
           Inc countcolumn
           Cmp countcolumn,4
           Jnz step4
           Mov si,0
    ;The transfer condition acts as guide that controls the multiplication process
    transfer: 
               Cmp countMatrix,1 
               Jz column1
               Cmp countMatrix,2
               Jz column2
               Cmp countMatrix,3
               Jz column3
               Cmp countMatrix,4
               Jz column4
     
     ;Each of the following column conditions is used to place the elements of the selected column in the "GaloisCol" array
     ;which is the array used to accomplish matrix multiplication
     
     column1:  Mov cl,col1[si]
               Mov GaloisCol[si],cl
               Inc si
               Cmp si,4
               Jnz column1
               Mov firstPlace,0
               Mov secondPlace,4
               Mov thirdPlace,8
               Mov fourthPlace,12
               Jmp GaloisTest
     column2:  Mov cl,col2[si]
               Mov GaloisCol[si],cl
               Inc si
               Cmp si,4
               Jnz column2
               Mov firstPlace,1
               Mov secondPlace,5
               Mov thirdPlace,9
               Mov fourthPlace,13
               Jmp GaloisTest
     column3:  Mov cl,col3[si]
               Mov GaloisCol[si],cl
               Inc si
               Cmp si,4
               Jnz column3
               Mov firstPlace,2
               Mov secondPlace,6
               Mov thirdPlace,10
               Mov fourthPlace,14
               Jmp GaloisTest
     column4:  Mov cl,col4[si]
               Mov GaloisCol[si],cl
               Inc si
               Cmp si,4
               Jnz column4
               Mov firstPlace,3
               Mov secondPlace,7
               Mov thirdPlace,11
               Mov fourthPlace,15
               Jmp GaloisTest     
   
   ;"GaloisTest" is a condition that indicates which row in the fixed 4x4 matrix has to be selected in matrix multiplication
   GaloisTest: Cmp countGalois,1
               Jz Galois1
               Cmp countGalois,2
               Jz Galois2
               Cmp countGalois,3
               Jz Galois3
               Jmp Galois4
    ;Each of the following "Galois" conditions is used to accomplish matrix multiplication
    ;where each of them contain the specific multiplication execution process taking into consideration
    ;the elements located in the fixed 4x4 matrix          
     
     
    ;"Galois1" executes the multiplication process taking into consideration the following elements placed
    ;in the fixed 4x4 matrix >>>>>>> (02 03 01 01)           
    Galois1: Mov cl,0
             Mov si,0
             Mov al,GaloisCol[si] 
             Shl al,1
             Jnc continue01 ;A check used to know whether there is a need to execute the "Xor" operation or not
                            ;depending on the value for the left most bit in the original number
                            ;This check is repeated each time before the "Xor" operation in the following lines
             Mov dl,factor
             Xor al,dl
 
 continue01: Mov GaloisCol[si],al
             Inc si
             Mov al,GaloisCol[si]
             Shl al,1
             Jnc continue11
             Mov dl,factor
             Xor al,dl
 
 continue11: Xor al,GaloisCol[si]
             Mov GaloisCol[si],al
             Mov si,0
      ;"Sum1" is used to sum up the obtained results
      sum1:  Xor cl,GaloisCol[si]
             Inc si 
             Cmp si,4
             Jnz sum1
             
      ;After summing the obtained results there is a need to place this sum in its right place in the given array      
             Mov si,firstPlace
             Mov Arr[si],cl
             Mov si,0
             Inc countGalois 
             Jmp transfer
    
    ;"Galois2" executes the multiplication process taking into consideration the following elements placed
    ;in the fixed 4x4 matrix >>>>>>> (01 02 03 01)    
       
    Galois2: Mov cl,0
             Mov si,0
             Inc si
             Mov al,GaloisCol[si]
             Shl al,1
             Jnc continue02
             Mov dl,factor
             Xor al,dl
 continue02: Mov GaloisCol[si],al
             Inc si
             Mov al,GaloisCol[si]
             Shl al,1
             Jnc continue12
             Mov dl,factor
             Xor al,dl
 continue12: Xor al,GaloisCol[si]
             Mov GaloisCol[si],al
             Mov si,0
      ;"Sum2" is used to sum up the obtained results
      sum2:  Xor cl,GaloisCol[si]
             Inc si 
             Cmp si,4
             Jnz sum2             
            
     ;After summing the obtained results there is a need to place this sum in its right place in the given array       
             Mov si,secondPlace
             Mov Arr[si],cl
             Mov si,0
             Inc countGalois 
             Jmp transfer 
   ;"Galois3" executes the multiplication process taking into consideration the following elements placed
   ;in the fixed 4x4 matrix >>>>>>> (01 01 02 03) 
     
    Galois3: Mov cl,0
             Mov si,0
             Add si,2
             Mov al,GaloisCol[si]
             Shl al,1
             Jnc continue03
             Mov dl,factor
             Xor al,dl
 continue03: Mov GaloisCol[si],al
             Inc si
             Mov al,GaloisCol[si]
             Shl al,1
             Jnc continue13
             Mov dl,factor
             Xor al,dl
 continue13: Xor al,GaloisCol[si]
             Mov GaloisCol[si],al
             Mov si,0
      ;"Sum3" is used to sum up the obtained results
      sum3:  Xor cl,GaloisCol[si]
             Inc si 
             Cmp si,4
             Jnz sum3
      ;After summing the obtained results there is a need to place this sum in its right place in the given array        
             Mov si,thirdPlace
             Mov Arr[si],cl
             Mov si,0 
             Inc countGalois 
             Jmp transfer
    
    ;"Galois4" executes the multiplication process taking into consideration the following elements placed
    ;in the fixed 4x4 matrix >>>>>>> (03 01 01 02)      
    Galois4: Mov cl,0
             Mov si,0
             Mov al,GaloisCol[si]
             Shl al,1
             Jnc continue04
             Mov dl,factor
             Xor al,dl
 continue04: Xor al,GaloisCol[si]
             Mov GaloisCol[si],al 
             Add si,3
             Mov al,GaloisCol[si]
             Shl al,1
             Jnc continue14
             Mov dl,factor
             Xor al,dl
 continue14: Mov GaloisCol[si],al
             Mov si,0
      ;"Sum4" is used to sum up the obtained results
      sum4:  Xor cl,GaloisCol[si]
             Inc si 
             Cmp si,4
             Jnz sum4
      ;After summing the obtained results there is a need to place this sum in its right place in the given array       
             Mov si,fourthPlace
             Mov Arr[si],cl
             Mov si,0
             Mov countGalois,1
             Inc countMatrix
             Cmp countMatrix,5  ;Repeating the same steps till the end of the 4x4 fixed matrix
             Jz  terminate
             Jmp transfer
  terminate:
ENDM
MACRO Addroundkey       
        Mov si, 0
        l12:mov AL , Arr[si] 
        ; we check we are in which round by checking the value of count rounds , after that we jump to the sutable round label in order to xor with the right round key
        Cmp CountRounds, 11
        jz Round1
        Cmp CountRounds, 10
        jz Round2
         Cmp CountRounds, 9
        jz Round3
         Cmp CountRounds, 8
        jz Round4
         Cmp CountRounds, 7
        jz Round5
         Cmp CountRounds, 6
        jz Round6
         Cmp CountRounds, 5
        jz Round7
         Cmp CountRounds, 4
        jz Round8
         Cmp CountRounds, 3
        jz Round9
         Cmp CountRounds, 2
        jz Round10
         Cmp CountRounds, 1
        jz Round11
        Round1: Xor AL , R_key0[si]
                Mov Arr[si] , AL
                inc si
                Jmp terminate2
                ; after xoring the accumlator content (Array content) with the roundkey the result is stored in AL and then it is returned again to the array
                ; the index is increased
                ; a jump is done to terminate2 label in order to move to next iteration 
        Round2: Xor AL , R_key1[si]
                Mov Arr[si] , AL
                inc si 
                Jmp terminate2 
         
        Round3: Xor AL , R_key2[si]
                Mov Arr[si] , AL
                inc si
                Jmp terminate2
        
        Round4: Xor AL , R_key3[si]
                Mov Arr[si] , AL
                inc si
                Jmp terminate2
        
        Round5: Xor AL , R_key4[si]
                Mov Arr[si] , AL
                inc si 
                Jmp terminate2  
        
        Round6: Xor AL , R_key5[si]
                Mov Arr[si] , AL
                inc si 
                Jmp terminate2  
        
        Round7: Xor AL , R_key6[si]
                Mov Arr[si] , AL
                inc si 
                Jmp terminate2  
        
        Round8: Xor AL , R_key7[si]
                Mov Arr[si] , AL
                inc si 
                Jmp terminate2  
        
        Round9:  Xor AL , R_key8[si]
                 Mov Arr[si] , AL
                 inc si  
                 Jmp terminate2 
        
        Round10: Xor AL , R_key9[si]
                 Mov Arr[si] , AL
                 inc si 
                 Jmp terminate2  
        
        Round11: Xor AL , R_key10[si]
                 Mov Arr[si] , AL
                 inc si  
                terminate2:  ; bitwise xoring is done in the rounds above then a jump to terminate is achieved to repeat the iteration and iterate throught the array
                CMP si , 16 
                Jnz l12                    
ENDM
org 100h
.data segment
    countRounds dw 11
    ;Counter used to determine which row needed to be selected in Rijndael S-box table(used in SubBytes)
    count db 0
    ;Counter used to replace each element in the given array by the value obtained from the S-box table(used in SubBytes)
    arrCount dw 0
    position dw 4
    count1 dw 4
    shift dw 1
    
    ;Empty arrays used to divide the columns of the given array into individual arrays(used in MixColumns)
    col1 db 0h,0h,0h,0h
    col2 db 0h,0h,0h,0h
    col3 db 0h,0h,0h,0h
    col4 db 0h,0h,0h,0h
    
    ;Empty array used to accomplish matrix multiplication(used in MixColumns)
    GaloisCol db 0h,0h,0h,0h
    ;Counter used to get the elements from the different columns of the given array(used in MixColumns)
    countTransform dw 0 
    ;Counter used to put a set of four elements in each created sub-column(used in MixColumns)
    countcolumn dw 0
    ;The factor used in case of multiplying a number (which has the leftmost bit equals to 1) by 02 (used in MixColumns)
    factor db 00011011b
    ;Counter used to determine which column(of the original matrix)has to be multiplied by the fixed 4x4 Matrix (used in MixColumns)
    countMatrix db 1
    ;Counter used to determine which row of the fixed 4x4 matrix has the turn to be multiplied by the chosen column (used in MixColumns)
    countGalois db 1
    ;The required places in the given matrix to be replaced by the obtained value from matrix multiplication (used in MixColumns)
    firstPlace dw 0
    secondPlace dw 0
    thirdPlace dw 0
    fourthPlace dw 0   
    ;Each of the following array represents a row in the Rijndael S-box table
    r0 db     063h ,07ch ,077h ,07bh ,0f2h ,06bh ,06fh ,0c5h ,030h ,001h ,067h ,02bh ,0feh ,0d7h ,0abh ,076h
    r1 db     0cah ,082h ,0c9h ,07dh ,0fah ,059h ,047h ,0f0h ,0adh ,0d4h ,0A2h ,0afh ,09ch ,0a4h ,072h ,0c0h
    r2 db     0b7h ,0fdh ,093h ,026h ,036h ,03fh ,0f7h ,0cch ,034h ,0a5h ,0e5h ,0f1h ,071h ,0d8h ,031h ,015h
    r3 db     004h ,0c7h ,023h ,0c3h ,018h ,096h ,005h ,09ah ,007h ,012h ,080h ,0e2h ,0ebh ,027h ,0b2h ,075h
    r4 db     009h ,083h ,02ch ,01ah ,01bh ,06eh ,05ah ,0a0h ,052h ,03bh ,0d6h ,0b3h ,029h ,0e3h ,02fh ,084h
    r5 db     053h ,0d1h ,000h ,0edh ,020h ,0fch ,0b1h ,05bh ,06ah ,0cbh ,0beh ,039h ,04ah ,04ch ,058h ,0cfh
    r6 db     0d0h ,0efh ,0aah ,0fbh ,043h ,04dh ,033h ,085h ,045h ,0f9h ,002h ,07fh ,050h ,03ch ,09fh ,0a8h
    r7 db     051h ,0a3h ,040h ,08fh ,092h ,09dh ,038h ,0f5h ,0bch ,0b6h ,0dah ,021h ,010h ,0ffh ,0f3h ,0d2h
    r8 db     0cdh ,00ch ,013h ,0ech ,05fh ,097h ,044h ,017h ,0c4h ,0a7h ,07eh ,03dh ,064h ,05dh ,019h ,073h
    r9 db     060h ,081h ,04fh ,0dch ,022h ,02ah ,090h ,088h ,046h ,0eeh ,0b8h ,014h ,0deh ,05eh ,00bh ,0dbh
    r10 db    0e0h ,032h ,03ah ,00ah ,049h ,006h ,024h ,05ch ,0c2h ,0d3h ,0ach ,062h ,091h ,095h ,0e4h ,079h
    r11 db    0e7h ,0c8h ,037h ,06dh ,08dh ,0d5h ,04eh ,0a9h ,06ch ,056h ,0f4h ,0eah ,065h ,07ah ,0aeh ,008h
    r12 db    0bah ,078h ,025h ,02eh ,01ch ,0a6h ,0b4h ,0c6h ,0e8h ,0ddh ,074h ,01fh ,04bh ,0bdh ,08bh ,08ah
    r13 db    070h ,03eh ,0b5h ,066h ,048h ,003h ,0f6h ,00eh ,061h ,035h ,057h ,0b9h ,086h ,0c1h ,01dh ,09eh
    r14 db    0e1h ,0f8h ,098h ,011h ,069h ,0d9h ,08eh ,094h ,09bh ,01eh ,087h ,0e9h ,0ceh ,055h ,028h ,0dfh
    r15 db    08ch ,0a1h ,089h ,00dh ,0bfh ,0e6h ,042h ,068h ,041h ,099h ,02dh ,00fh ,0b0h ,054h ,0bbh ,016h 
    ;Given Array
    Arr DB   32h , 88h , 31h , 0e0h , 43h , 5ah , 31h , 37h , 0f6h , 30h , 98h , 07h , 0a8h , 8dh , 0a2h , 34h
    ; 11 roundkeys for the eleven rounds  
    R_key0 DB 2bh ,28h ,0abh ,09h ,7eh , 0aeh ,0f7h ,0cfh ,15h ,0d2h ,15h ,4fh ,16h ,0a6h ,88h ,3ch
    R_key1 DB 0A0h , 088h , 23h , 2Ah , 0FAh , 54h , 0A3h , 6Ch , 0FEh , 2Ch , 39h , 76h , 17h , 0B1h , 39h , 05h
    R_key2 DB 0f2h , 7ah ,59h ,73h ,0c2h ,96h ,35h ,59h ,95h ,0b9h ,80h ,0f6h ,0f2h ,43h ,7ah ,7fh
    R_key3 DB 3dh , 47h , 1eh , 6dh , 80h , 16h , 23h , 7ah , 47h ,0feh ,7eh ,88h ,7dh ,3eh ,44h ,3bh
    R_key4 DB 0efh , 0a8h , 0b6h , 0dbh , 44h , 52h , 71h , 0bh , 0a5h , 5bh , 25h , 0adh , 41h , 7fh , 3bh, 00h
    R_key5 DB 0d4h , 7ch , 0cah , 11h , 0d1h , 83h , 0f2h , 0f9h , 0c6h , 9dh , 0b8h , 15h , 0f8h , 87h , 0bch , 0bch
    R_key6 DB 6dh , 11h , 0dbh , 0cah , 88h , 0bh , 0f9h , 00h , 0a3h , 3eh ,86h , 93h , 7ah , 0fdh ,41h , 0fdh
    R_key7 DB 4eh , 5fh , 84h , 4eh , 54h , 5fh , 0a6h , 0a6h ,0f7h ,0c9h ,4fh ,0dch ,0eh ,0f3h , 0b2h , 4fh
    R_key8 DB 0eah , 0b5h , 31h , 7fh , 0d2h , 8dh , 2bh , 8dh , 73h , 0bah , 0f5h , 29h , 21h , 0d2h , 60h ,2fh
    R_key9 DB 0ach , 19h , 28h , 57h , 77h ,0fah ,0d1h ,5ch ,66h ,0dch ,29h ,00h ,0f3h ,21h ,41h ,6eh
    R_key10 DB 0d0h , 0c9h , 0e1h , 0b6h , 14h ,0eeh ,3fh ,63h ,0f9h ,25h ,0ch , 0ch ,0a8h , 89h , 0c8h ,0a6h
.code segment
    CALL Input
    ; the input procedure is called first in order to store user input in Arr 
    rounds: 
    CMP CountRounds ,11
    Jz a1 ; a check is done . If we are at the first round a jump is made to the addRoundkey because at the first round only addroundkey is made 
    SubBytes 
    ShiftRows
    Cmp  CountRounds , 1
    Jz a1; a check is done . If we are at the final round a jump is made to the addRoundkey because at the final round mixcolumns is skipped 
    MixColumns 
    a1: Addroundkey 
    Dec CountRounds 
    Cmp CountRounds , 0 ;if the rounds are finished. the jump is not made as zro flag would be set
    Jnz rounds
    CALL Output ; this procedure is called to display the result
ret            
PROC Input ; input procedure implements int 21h interrupt in order to take user input from keyboard and move from accumlator to array
    MOV ax,@data
    MOV ds,ax
    MOV SI,0
    Print 'Enter message :'
    l1:
    MOV ah, 01h
    INT 21h  ; an interrupt is made to take user input
    MOV Arr[SI],AL
    add SI , 4 
    CMP SI ,16
    jnz l1
    MOV SI,1  
    ; elements are filled column by column
    l2:
    MOV ah, 01h
    INT 21h  ; an interrupt is made to take user input
    MOV Arr[SI],AL
    add SI , 4 
    CMP SI ,17
    jnz l2 
    MOV SI,2
    l3:
    MOV ah, 01h
    INT 21h  ; an interrupt is made to take user input
    MOV Arr[SI],AL
    add SI , 4 
    CMP SI ,18
    jnz l3  
    MOV SI,3
    l4:
    MOV ah, 01h
    INT 21h  ; an interrupt is made to take user input
    MOV Arr[SI],AL
    add SI , 4 
    CMP SI ,19
    jnz l4
    
ret
ENDP
PROC Output ; output procedure implements int 21h interrupt in order to dispaly encrypted message. 
    printn
    Print 'Encrypted message :'
    MOV ax,@data
    MOV ds,ax
    Mov dx,0
    mov si,0
    l5: 
     mov dl,Arr[si]  ;the content of array is moved to register dl in order to be dispalyed 
     mov ah,02h
     int 21h  ; an interrupt is made to display the array element
     add SI , 4
     Cmp si, 16
     jnz l5
    mov si,1 
    l6: 
     mov dl,Arr[si]  ;the content of array is moved to register dl in order to be dispalyed 
     mov ah,02h
     int 21h  ; an interrupt is made to display the array element
     add SI , 4
     Cmp si, 17
     jnz l6 
    mov si,2 
    l7: 
     mov dl,Arr[si]  ;the content of array is moved to register dl in order to be dispalyed 
     mov ah,02h
     int 21h  ; an interrupt is made to display the array element
     add SI , 4
     Cmp si, 18
     jnz l7
    mov si,3 
    l8: 
     mov dl,Arr[si]  ;the content of array is moved to register dl in order to be dispalyed 
     mov ah,02h
     int 21h  ; an interrupt is made to display the array element
     add SI , 4
     Cmp si, 19
     jnz l8  
     
ret
ENDP




