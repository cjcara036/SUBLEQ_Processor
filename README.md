<div class="markdown prose break-words dark:prose-invert light">
  <h1>SUBLEQ Processor</h1>
  <p>This repository contains the Verilog code for a basic SUBLEQ processor, as well as some supporting modules. The SUBLEQ (Subtract and branch if Less-than or Equal to Zero) instruction set is a simple, one-instruction set architecture (OISA) that performs the subtraction of two operands, and branches to a specified address if the result is less than or equal to zero.</p>
  <h2>File Descriptions</h2>
  <ul>
    <li>
      <p><code>CU_microcode.mem</code>: This file contains the microcode for the Control Unit (CU) of the SUBLEQ processor. It defines the sequence of operations that the processor should execute for each instruction.</p>
    </li>
    <li>
      <p><code>buffer_block_v01.v</code>: This file contains the code for a simple buffer module that can be used to temporarily block or unblock data.</p>
    </li>
    <li>
      <p><code>data_register_v01.v</code>: This file contains the code for a basic data register module that can be used to store and retrieve data.</p>
    </li>
    <li>
      <p><code>counter_register_v01.v</code>: This file contains the code for a counter register module that can be used to store and increment/decrement a value.</p>
    </li>
    <li>
      <p><code>subtractor_block_v01.v</code>: This file contains the code for a subtractor module that can be used to perform subtraction between two operands.</p>
    </li>
    <li>
      <p><code>SUBLEQ_v01.v</code>: This is the main SUBLEQ processor module, which combines the CU, data registers, counter registers, and subtractor module to execute the SUBLEQ instruction set.</p>
    </li>
  </ul>
  <h2>How the SUBLEQ Processor Works</h2>
  <p>The SUBLEQ processor consists of a Control Unit (CU), data registers, counter registers, and a subtractor module. The CU controls the flow of data and operations within the processor using a microcode stored in the <code>CU_microcode.mem</code> file.</p>
  <p>The data registers (implemented in <code>data_register_v01.v</code>) are used to store operands for the SUBLEQ instruction. There are two data registers, referred to as DATA_REG_A and DATA_REG_B, which can be loaded with values from memory or other sources.</p>
  <p>The counter registers (implemented in <code>counter_register_v01.v</code>) are used to store a counter value and can be incremented or decremented as needed. There is one counter register, referred to as the Program Counter (PC), which is used to store the address of the next instruction to be executed.</p>
  <p>The subtractor module (implemented in <code>subtractor_block_v01.v</code>) performs the subtraction of DATA_REG_A and DATA_REG_B, and sets a flag (LEQ_FLAG) to 1 if the result is less than or equal to zero.</p>
  <p>The CU uses the microcode to control the flow of data and operations within the processor, including loading values into the data and counter registers, performing the subtraction operation, and branching to a new instruction based on the value of the LEQ_FLAG.</p>
  <h2>How to use</h2>
  <p>To use the SUBLEQ processor, you will need to load the instructions and data into memory. The instructions are in the form of the SUBLEQ(A,B,C) instruction, where A, B, and C are addresses in memory. The instruction should be stored in memory as follows:</p>
  <ul>
    <li>memory[x] = address_of_B</li>
    <li>memory[x+1] = address_of_A</li>
    <li>memory[x+2] = address_C</li></ul>
  <p>The SUBLEQ instruction will perform the following operations:</p>
  <ol>
    <li>Subtract the value stored at address B from the value stored at address A.</li>
    <li>If the result of the subtraction is less than or equal to zero, branch to the address specified in C.</li>
    <li>If the result is greater than zero, increment the instruction pointer (PC) and continue execution with the next instruction.</li>
  </ol>
  </ul>
</div>
