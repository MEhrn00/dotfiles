#!/usr/bin/env python3
from pwn import *

context.binary = binary = '{{ exe }}'
if args.REMOTE:
    p = remote()
else:
    p = process(binary, env = {'LD_PRELOAD': '{{ libc }}'})
    if args.GDB:
        gdb.attach(p)

e = ELF('{{ exe }}')
libc = ELF('{{ libc }}')
rop = ROP(e)


p.interactive()
