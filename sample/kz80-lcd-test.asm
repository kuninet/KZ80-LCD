;
; キャラクタLCDテスト for KZ80-LCD
;
    CPU Z80

LCD_CTL_WR   EQU 080h
LCD_DATA_WR   EQU 081h
LCD_CTL_RD   EQU 082h
LCD_DATA_RD   EQU 083h

    org 9000h

START:
    call lcd_init
    call lcd_print
    JP   0

;--------------------
; LCD初期化
;--------------------
lcd_init:
    LD  HL,lcd_init_str
    LD  b,lcd_init_len
    LD  c,LCD_CTL_WR
.lcd_init_loop
    LD  A,(HL)
    OUT (c),A
    call wait100
    INC HL
    DEC b
    JP NZ,.lcd_init_loop
    call wait100
    ret

;--------------------
; LCDへメッセージ表示
;--------------------
lcd_print:
    LD   HL,lcd_print_str1
    LD   B,lcd_str_len1
    call lcd_line_print
;
    call lcd_nextline
;
    LD   HL,lcd_print_str2
    LD   B,lcd_str_len2
    call lcd_line_print
    ret

;--------------------
; LCD文字列表示
;--------------------
lcd_line_print:
    LD  C,LCD_DATA_WR
.lcd_loop
    LD  A,(HL)
    OUT (c),A
    call wait100
    INC HL
    DEC b
    JP NZ,.lcd_loop
    ret

;--------------------
; LCD 2行目へ
;--------------------
lcd_next_data   equ 0C0h
;
lcd_nextline:
    LD  A,lcd_next_data
    out (LCD_CTL_WR),A
    call wait100
    ret


;--------------------
; WAIT-100
;--------------------
wait100:
    PUSH BC
    LD B,255
    call wait
    POP BC
    ret


;--------------------
; WAIT-1
;--------------------
wait:
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    DEC B
    JP NZ,wait
    ret


;
lcd_init_str     DB  03ch,0fh,01h
lcd_init_len     equ $-lcd_init_str
;
lcd_print_str1   DB  "Hello LCD SC1602"
lcd_str_len1     equ $-lcd_print_str1
;
lcd_print_str2   DB  "  for KZ80-LCD  "
lcd_str_len2     equ $-lcd_print_str2
