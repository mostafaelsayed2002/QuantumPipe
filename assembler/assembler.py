from isa import * 
import argparse
import re
import sys

class Assembler: 

    @staticmethod
    def assemble(input_file: str, output_file: str) -> list: 
        code = Assembler.read_code(input_file)
        binary_code =  []
        error = []

        for i, code in enumerate(code): 
            instruction_code = Assembler.parse_instruction(code)
            if instruction_code == None:
                print(f"Error in line in valid_code.txt: {i+1}, line: {code}", file=sys.stderr)
                continue

            for j in instruction_code: 
                binary_code.append(j)


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
        code = re.split(r'[ ,]+', line)
        for i, operand in enumerate(code): 
            code[i] = code[i].lower()
            if code[i][-1] == ',': 
                code[i] = code[i][:-1] 
        
        code_isa = instructions_table.get(code[0])
        if code_isa == None: 
            return None

        binary_code = []

        instr = ""
        imm = ""

        instr += code_isa[1]

        if code_isa[0] == IsaType.NO_OPERANDS: 
            instr += "0"*11


        elif code_isa[0] == IsaType.ONE_OPERAND: 
            instr += registers_table[code[1]]
            instr += "0"*8 


        elif code_isa[0] == IsaType.TWO_OPERAND: 
            instr += registers_table[code[1]]
            instr += registers_table[code[2]]
            instr += "0"*5


        elif code_isa[0] == IsaType.THREE_OPERAND:
            instr += registers_table[code[1]]
            instr += registers_table[code[2]]
            instr += registers_table[code[3]]
            instr += "0"*2  

        elif code_isa[0] == IsaType.IMM_OPERAND:
            instr += registers_table[code[1]]
            instr += "0"*4

            imm = code[2]
            if (imm.startswith("0x")):
                imm = int(imm[2:], 16)
            else:
                imm = int(code[2])

            imm = bin(imm)
            imm = "0"*(20 - len(imm[2:])) + imm[2:]

            instr += imm[16:]

        elif code_isa[0] == IsaType.SPECIAL_OPERAND:
            instr += registers_table[code[1]]
            instr += registers_table[code[2]]
            instr += "0"

            imm = code[3]
            if (imm.startswith("0x")):
                imm = int(imm[2:], 16)
            else:
                imm = int(code[3])
            
            imm = bin(imm)
            imm = "0"*(20 - len(imm[2:])) + imm[2:]

            instr += imm[16:]
            
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
        with open("valid_code.txt", 'w') as wf: 
            for i in code:
                if i == code[-1]: 
                    wf.write(i)
                else: 
                    wf.write(i + "\n")
        return code

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Assembler For QuantumPipe")
    parser.add_argument("-i", "--input",  help = "Input code path",              required=True)
    parser.add_argument("-o", "--output", help = "Output assembled binary code", required=False)
    # parser.add_argument("-h", "--help",   help = "Print assembler help",         required=False)

    args = parser.parse_args()
    
    input_path = args.input 
    output_path = args.output


    if output_path == None: 
        output_path = "output.txt"
    Assembler.assemble(input_path, output_path)