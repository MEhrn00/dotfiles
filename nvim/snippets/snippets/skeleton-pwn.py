#!/usr/bin/env python3
from pwn import *

context.binary = binary = './'
if args.REMOTE:
    p = remote()
else:
    p = process(binary)
    if args.GDB:
        gdb.attach(p)

e = ELF(binary)
rop = ROP(e)


p.interactive()
