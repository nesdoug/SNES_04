; example 4 SNES code

.p816
.smart

.include "defines.asm"
.include "macros.asm"
.include "init.asm"





.segment "CODE"

; enters here in forced blank
main:
.a16 ; just a standardized setting from init code
.i16
	phk
	plb
	

	
; DMA from BG_Palette to CGRAM
	A8
	stz $2121 ; $2121 cg address = zero
	
	stz $4300 ; transfer mode 0 = 1 register write once
	lda #$22  ; $2122
	sta $4301 ; destination, pal data
	ldx #.loword(BG_Palette)
	stx $4302 ; source
	lda #^BG_Palette
	sta $4304 ; bank
	ldx #256
	stx $4305 ; length
	lda #1
	sta $420b ; start dma, channel 0
	
	
; DMA from Tiles to VRAM	
	lda #V_INC_1 ; the value $80
	sta vram_inc  ; $2115 = set the increment mode +1
	ldx #$0000
	stx vram_addr ; set an address in the vram of $0000
	
	lda #1
	sta $4300 ; transfer mode, 2 registers 1 write
			  ; $2118 and $2119 are a pair Low/High
	lda #$18  ; $2118
	sta $4301 ; destination, vram data
	ldx #.loword(Tiles)
	stx $4302 ; source
	lda #^Tiles
	sta $4304 ; bank
	ldx #(End_Tiles-Tiles)
	stx $4305 ; length
	lda #1
	sta $420b ; start dma, channel 0
	
; DMA from Tiles2 to VRAM	
	ldx #$3000
	stx vram_addr ; set an address in the vram of $3000
	
; 4300 and 4301 still hold the correct values for transfers to vram
; and don't need to be rewritten here
	ldx #.loword(Tiles2)
	stx $4302 ; source
	lda #^Tiles2
	sta $4304 ; bank
	ldx #(End_Tiles2-Tiles2)
	stx $4305 ; length
	lda #1
	sta $420b ; start dma, channel 0
	
	
	
; DMA from Tilemap to VRAM	
	ldx #$6000
	stx vram_addr ; set an address in the vram of $6000
	
; removed duplicate writes to 4300 and 4301	
	ldx #.loword(Tilemap)
	stx $4302 ; source
	lda #^Tilemap
	sta $4304 ; bank
	ldx #$700
	stx $4305 ; length
	lda #1
	sta $420b ; start dma, channel 0	
	
	
; DMA from Tilemap2 to VRAM	
	ldx #$6800
	stx vram_addr ; set an address in the vram of $6800
	
; removed duplicate writes to 4300 and 4301	
	ldx #.loword(Tilemap2)
	stx $4302 ; source
	lda #^Tilemap2
	sta $4304 ; bank
	ldx #$700
	stx $4305 ; length
	lda #1
	sta $420b ; start dma, channel 0
	
	
; DMA from Tilemap3 to VRAM	
	ldx #$7000
	stx vram_addr ; set an address in the vram of $7000
	
; removed duplicate writes to 4300 and 4301	
	ldx #.loword(Tilemap3)
	stx $4302 ; source
	lda #^Tilemap3
	sta $4304 ; bank
	ldx #$700
	stx $4305 ; length
	lda #1
	sta $420b ; start dma, channel 0	
	
	
; a is still 8 bit.
	lda #1 ; mode 1, tilesize 8x8 all
	sta bg_size_mode ; $2105
	
; 210b = tilesets for bg 1 and bg 2
; (210c for bg 3 and bg 4)
; steps of $1000 -321-321... bg2 bg1
	stz bg12_tiles ; $210b BG 1 and 2 TILES at VRAM address $0000
	lda #$03
	sta bg34_tiles ; $210c BG3 TILES at VRAM address $3000
	
	; 2107 map address bg 1, steps of $400... -54321yx
	; y/x = map size... 0,0 = 32x32 tiles
	; $6000 / $100 = $60
	lda #$60 ; bg1 map at VRAM address $6000
	sta tilemap1 ; $2107
	
	lda #$68 ; bg1 map at VRAM address $6800
	sta tilemap2 ; $2108
	
	lda #$70 ; bg3 map at VRAM address $7000
	sta tilemap3 ; $2109

	lda #BG_ALL_ON
	sta main_screen ; $212c
	
	lda #FULL_BRIGHT ; $0f = turn the screen on (end forced blank)
	sta fb_bright ; $2100


InfiniteLoop:	
	jmp InfiniteLoop
	
	

.include "header.asm"	


.segment "RODATA1"

BG_Palette:
; 256 bytes
.incbin "ImageConverter/allBG.pal"

Tiles:
; 4bpp tileset
.incbin "ImageConverter/moon.chr"
End_Tiles:

Tiles2:
; 2bpp tileset
.incbin "ImageConverter/spacebar.chr"
End_Tiles2:

Tilemap:
; $700 bytes
.incbin "ImageConverter/moon3.map"

Tilemap2:
; $700 bytes
.incbin "ImageConverter/bluebar.map"

Tilemap3:
; $700 bytes
.incbin "ImageConverter/spacebar2.map"


