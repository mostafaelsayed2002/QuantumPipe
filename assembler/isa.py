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
