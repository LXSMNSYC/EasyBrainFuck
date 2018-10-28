# EasyBrainFuck
A readable, easier variant of Brainfuck, written in Lua.

## What is EasyBrainFuck
EasyBrainFuck is a BrainFuck variant that aims to be readable and easier to code with.

### Features
#### Keywords
Since the aim of EasyBrainFuck is readability, EasyBrainFuck provides keywords instead of the original symbols.
| Keyword | Equivalent BrainFuck Symbol |
| :---: | :---: |
| `left` | `<` |
| `right` | `>` |
| `add` | `+` |
| `sub` | `-` |
| `while` | `[` |
| `end` | `]` |
| `write` | `.` |
| `read` | `,` |

#### Easier to code with
You might ask "you just made brainfuck easier to read, not write it!" but WRONG! 4 of the keywords accepts parameters which prevents you from repeating the symbol all over again.

For instance, the brainfuck code:
```bf
+++++ +++++ Add 10
```
is equivalent to
```
add 10
```
in EasyBrainFuck. Neat, isn't it?

The symbols that accepts parameters are `left`, `right`, `add`, `sub`. These symbols not only can accept these numbers, they can accept both negative values and hexadecimals.

#### Comments
With the introduction of keywords, EasyBrainFuck also introduces comment blocks. Just use the symbol `#` as both the block starter and terminator.

#### Examples
##### Hello World
Here is a bruteforce version:
```
add 0x48 write sub 0x48 
add 0x65 write sub 0x65 
add 0x6c write write sub 0x6c 
add 0x6f write sub 0x6f 
add 0x20 write sub 0x20 
add 0x57 write sub 0x57 
add 0x6f write sub 0x6f 
add 0x72 write sub 0x72  
add 0x6c write sub 0x6c 
add 0x64 write sub 0x64 
add 0x21 write          
```
Another version, not bruteforced, but incremental:
```
add 0x48 write 
left 1 
add 0x65 write 
add 7 write write 
add 3 write 
left 1 add 0x20 write right 1 
right 1 
add 0xF write 
left 1 
write 
add 3 write 
sub 6 write 
sub 8 write 
left 1 add 1 write right 1 
```
##### CAT
```
add 1
while
  read
  write
end
```
##### CAT2(Reading file)
```
right 1 add 1
while
  right 1 read
end

left 1 
while left 1 end

right 2
while
  read
  right 1
end
```

### Compiling
#### Lua
Just load the module
```
local ebf = require "EasyBrainFuck"
```

Then to compile
```
ebf(myProgramString, cellSize, memorySize)
```
Cell Size defaults at 8-bit. Acceptable values includes 8, 16 or 32-bit.
Memory Size defaults to 30000.

There is also a BF-to-EBF transpiler available, in case you wanted to translate BF programs.
