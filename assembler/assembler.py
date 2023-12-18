import argparse
import re
import sys

from enum import Enum

# Define an enumeration class
class IsaType(Enum):
    NO_OPERANDS = 0
    ONE_OPERAND = 1
    TWO_OPERAND = 2
    THREE_OPERAND = 3
    IMM_OPERAND = 4
    # ADDI
    SPECIAL_OPERAND = 5

# Instruction Type - Op Code 
instructions_table = {
        "nop": [IsaType.NO_OPERANDS, "00000"],
        "ret": [IsaType.NO_OPERANDS, "00001"],
        "rti": [IsaType.NO_OPERANDS, "00010"],

        # one destination
        "not": [IsaType.ONE_OPERAND, "00011"],
        "neg": [IsaType.ONE_OPERAND, "00100"],
        "inc": [IsaType.ONE_OPERAND, "00101"],
        "dec": [IsaType.ONE_OPERAND, "00110"],
        "out": [IsaType.ONE_OPERAND, "00111"],
        "in":  [IsaType.ONE_OPERAND, "01000"],
        "push":[IsaType.ONE_OPERAND, "01001"],
        "pop": [IsaType.ONE_OPERAND, "01010"],
        "protect": 
               [IsaType.ONE_OPERAND, "01011"],
        "free":[IsaType.ONE_OPERAND, "01100"],
        "jz":  [IsaType.ONE_OPERAND, "01101"],
        "jmo": [IsaType.ONE_OPERAND, "01110"],
        "call":[IsaType.ONE_OPERAND, "01111"],

        # one destination two srcs
        "add": [IsaType.THREE_OPERAND, "10000"],
        "sub": [IsaType.THREE_OPERAND, "10001"],
        "and": [IsaType.THREE_OPERAND, "10010"],
        "or":  [IsaType.THREE_OPERAND, "10011"],
        "xor": [IsaType.THREE_OPERAND, "10100"],

        # one destination one src
        "swap":[IsaType.TWO_OPERAND, "10101"],
        "cmp": [IsaType.TWO_OPERAND, "10110"],

        # special operation
        "addi": [IsaType.SPECIAL_OPERAND, "10111"],


        # one Rdst and imm 
        "bitset":
               [IsaType.IMM_OPERAND, "11000"],
        "rcl": [IsaType.IMM_OPERAND, "11001"],
        "rcr": [IsaType.IMM_OPERAND, "11010"],
        "ldm": [IsaType.IMM_OPERAND, "11011"],
        "ldd": [IsaType.IMM_OPERAND, "11100"],
        "std": [IsaType.IMM_OPERAND, "11101"],
}

registers_table = {
        "r0": "000",
        "r1": "001",
        "r2": "010",
        "r3": "011",
        "r4": "100",
        "r5": "101",
        "r6": "110",
        "r7": "111"
}

class Assembler: 

    @staticmethod
    def find_error_line(line: str, input_code: list) -> int: 
        for i, code in enumerate(input_code): 
            if code.startswith(line):
                return i + 1
        return -1

    @staticmethod
    def assemble(input_file: str, output_file: str) -> list: 

        input_code = []
        with open(input_file, 'r') as f:
            for i, line in enumerate(f): 
                input_code.append(line)

        code = Assembler.read_code(input_file)
        binary_code =  []
        error = False

        for i, instruction in enumerate(code): 
            instruction_code = Assembler.parse_instruction(instruction)

            if instruction_code == None:
                print(f"Error in line in {input_file}:{Assembler.find_error_line(instruction, input_code)}, line: {code[0]}", file=sys.stderr)
                error = True
                continue

            if not error:
                binary_code.extend(instruction_code)

        if not error:
            with open(output_file, 'w') as f:
                for i in binary_code: 
                    if i == binary_code[-1]: 
                        f.write(i)
                    else:
                        f.write(i + "\n")
                if len(code) < 4096:
                    empty_range = 4096 - len(code)
                    f.write("\n")
                    for i in range(empty_range): 
                        if (i == empty_range - 1):
                            f.write("0"*16)
                        else:
                            f.write("0"*16 + "\n")
                        
    @staticmethod
    def parse_instruction(line: str) -> str:
        code = line.split(' ', 1)
        operands = re.split(r'[,]+', code[1])
        code = [code[0], *operands] 

        for i, operand in enumerate(code): 
            code[i] = code[i].lower()
            code[i] = code[i].replace(" ", "")
        
        
        code_isa = instructions_table.get(code[0])
        if code_isa == None: 
            return None

        binary_code = []

        instr = ""
        imm = ""

        instr += code_isa[1]

        if code_isa[0] == IsaType.NO_OPERANDS: 
            if len(code) != 1:
                return None

            instr += "0"*11


        elif code_isa[0] == IsaType.ONE_OPERAND: 
            if len(code) != 2:
                return None

            reg = registers_table.get(code[1])
            
            if reg == None: 
                return None
            
            instr += reg
            instr += "0"*8 


        elif code_isa[0] == IsaType.TWO_OPERAND: 
            if len(code) != 3:
                return None

            reg1 = registers_table.get(code[1])
            reg2 = registers_table.get(code[2])

            if reg1 == None or reg2 == None:
                return None
            
            instr += reg1
            instr += reg2

            instr += "0"*5


        elif code_isa[0] == IsaType.THREE_OPERAND:
            if len(code) != 4:
                return None

            reg1 = registers_table.get(code[1]) 
            reg2 = registers_table.get(code[2])
            reg3 = registers_table.get(code[3])

            if reg1 == None or reg2 == None or reg3 == None:
                return None
            
            instr += reg1
            instr += reg2
            instr += reg3

            instr += "0"*2  

        elif code_isa[0] == IsaType.IMM_OPERAND:
            
            reg = registers_table.get(code[1])

            if reg == None:
                return None

            instr += reg
            instr += "0"*4

            imm = code[2]
            if (imm.startswith("0x")):
                imm = int(imm[2:], 16)
            else:
                imm = int(code[2])

            imm = bin(imm)
            imm = "0"*(20 - len(imm[2:])) + imm[2:]

            instr += imm[16:]
            imm = imm[:-4]

        elif code_isa[0] == IsaType.SPECIAL_OPERAND:
            if len(code) != 4:
                return None

            reg1 = registers_table.get(code[1])
            reg2 = registers_table.get(code[2])
            
            if reg1 == None or reg2 == None:
                return None
            
            instr += reg1
            instr += reg2
            instr += "0"

            imm = code[3]
            if (imm.startswith("0x")):
                imm = int(imm[2:], 16)
            else:
                imm = int(code[3])
            
            imm = bin(imm)
            imm = "0"*(20 - len(imm[2:])) + imm[2:]

            instr += imm[16:]
            print(instr)
            
            imm = imm[:-4]
        

        binary_code.append(instr)
        if imm != "":
            binary_code.append(imm)
        return binary_code

    @staticmethod
    def read_code(input_file: str, output_file = "output.txt") -> list: 
        code = []
        with open(input_path, 'r') as f: 
            for i, line  in enumerate(f): 
                if re.match(r"\s.^$", line) or line == "\n": 
                    continue
                else:
                    if re.search(r"\s*#.*", line): 
                        line = re.sub(r"\s*#.*", "", line)
                    line = line.strip()
                    if line != '':
                        code.append(line.strip())
        return code

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
                                     formatter_class=argparse.RawTextHelpFormatter,
                                    prog="""
        python3 assembler.py -i <input_code_path> -o <output_binary_code_path>

        Features:
        - Supports comments with #
        - Supports hexadecimal starts with 0x and decimal values
        - Supports whitespaces
        - Outputs a file with the valid code
        - Outputs a file with the binary code that can be loaded into the memory 4096 words
        - Supports all the instructions in the ISA
    
        Author: @Walid-Kh
        """)
    parser.add_argument("-i", "--input", help="Input code path (required)", required=True)
    parser.add_argument("-o", "--output",help="Output assembled binary code", required=False)



    args = parser.parse_args()
    
    input_path = args.input 
    output_path = args.output
    if output_path == None: 
        output_path = "output.txt"


    Assembler.assemble(input_path, output_path)