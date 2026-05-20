⏺ 🔐 CO Project TOAST — AES Encryption in Assembly                              
                                           
  What Is This Project?                                                         
                                                                                
  This project implements AES-128 (Advanced Encryption Standard) — one of the   
  most widely used encryption algorithms in the world — but written entirely in 
  8086 Assembly language. That means no Python, no C, no high-level             
  abstractions. Just raw CPU instructions.

  The goal: take a 16-byte message and a 16-byte secret key, and produce an     
  encrypted output through 10 rounds of transformation.

  Team: two members
  you can look at CO project Rquirements.pdf to see requirements
  and also watch DEMO_compressed.mp4 for a quick demo of the program
                                                                                
  ---             
  How AES Works (Simplified)
                                                                                
  Think of your 16-byte message as a 4×4 grid of bytes called the State. AES
  scrambles this grid over and over using 4 operations per round:               
                  
  Round 0:   Mix state with key (initial lock)                                  
                                                                                
  Rounds 1–9 (repeat 9 times):                                                  
    Step 1 → SubBytes     : Swap every byte using a secret lookup table         
    Step 2 → ShiftRows    : Slide each row of the grid left                     
    Step 3 → MixColumns   : Mix the columns mathematically                      
    Step 4 → AddRoundKey  : Mix state with the round key                        
                                                                                
  Round 10 (final):                                                             
    Step 1 → SubBytes
    Step 2 → ShiftRows                                                          
    Step 3 → AddRoundKey  (no MixColumns this time)
                                                                                
  ---
  File Breakdown                                                                
                  
  AES.asm — The Brain

  This is the main file that runs the show. It:                                 
  - Asks the user to enter the message and key
  - Calls each of the 4 AES steps in the right order                            
  - Loops through all 10 rounds                     
  - Prints the final encrypted result                                           
                                                                                
  ---
  I-O.asm — Talking to the User                                                 
                                                                                
  Handles all input and output:
  - Reads 32 hex characters from the keyboard (like 2B7E151628AED2A6...) and    
  converts them into 16 raw bytes                                               
  - Prints bytes back as readable hex (e.g. A3 F2 ...)
  - Validates input — only accepts 0–9 and A–Z                                  
                                                                                
  ---                                                                           
  SubBytes.asm — The Substitution Step                                          
                                                                                
  Uses a 256-entry lookup table called the S-Box. Every byte in the state gets
  swapped with a different byte from this table. It's like a secret codebook —  
  the same codebook AES always uses.
                                                                                
  ---             
  ShiftRow.asm — The Sliding Step
                                                                                
  Shifts each row of the 4×4 grid to the left by a different amount:
  - Row 1 → shift left by 1                                                     
  - Row 2 → shift left by 2
  - Row 3 → shift left by 3                                                     
  - Row 0 → stays the same 

  ---                                                                           
  MixColumns.asm — The Math Step
                                                                                
  Multiplies each column of the state by a fixed matrix using special math
  (Galois Field arithmetic). This is the most mathematically complex step — it  
  ensures that changing one byte affects the whole column.
                                                                                
  ---             
  addRoundKey.asm — The Key Mixing Step
                                       
  XORs the current state with the round key — a 16-byte chunk derived from the
  original key. XOR is simple but powerful: it's the backbone of mixing secret  
  key material into the data.
                                                                                
  ---             
  keyschedule.asm — The Key Expander
                                                                                
  Takes the original 16-byte key and expands it into 176 bytes (11 round keys ×
  16 bytes each). Each new round key is derived from the previous one using:    
  - A rotation    
  - An S-Box lookup                                                             
  - XOR with a special round constant (RCON)

  ---
