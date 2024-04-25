```

  _____    _______   _        _        __  __        __      __  __       __ 
 |  __ \  |__   __| | |      | |      |  \/  |       \ \    / / /_ |     /_ |
 | |__) |    | |    | |      | |      | \  / |        \ \  / /   | |      | |
 |  _  /     | |    | |      | |      | |\/| |         \ \/ /    | |      | |
 | | \ \     | |    | |____  | |____  | |  | |          \  /     | |  _   | |  
 |_|  \_\    |_|    |______| |______| |_|  |_|           \/      |_| (_)  |_|
                                                                             
                                                                             
                                              
```
This is a fork of the RTLLM github. I have modified their README for 17630 Final Project Submission.
In _chatgpt4 t1-t5 are supplied by the authors of the paper. t6 onwards are my own runs. Some runs do not have all modules,
as I was trying out a few test cases at a time to save some money. My final results that I used for pass@5 are t17-t21.



# RTLLM: An Open-Source Benchmark for Design RTL Generation with Large Language Model
Yao Lu, Shang Liu, Qijun Zhang, and Zhiyao Xie, "RTLLM: An Open-Source Benchmark for Design RTL Generation with Large Language Model," Asia and South Pacific Design Automation Conference (ASP-DAC) 2024.[[paper]](https://arxiv.org/pdf/2308.05345.pdf)

## 1. Documents

RTL Generation with Large Language Model Benchmark for generating design RTL with natural language (under construction). This repository contains a total of 29 designs. Each design has its own folder, which includes several files:

1. Design Description (**design_description.txt**):
    
    This file provides a natural language description of the design.

2. Testbench (**testbench.v**): 

    This file contains the testbench code used to simulate and test the design on Synopsys VCS.
   ```
   vcs testbench.v ../*.v
   ```

3. Designer RTL (**verified_verilog.v**): 
    
    This file contains the Verilog code that has been verified and confirmed to be functionally correct.

Please refer to the respective folders for each design to access the files mentioned above.

## 2. Run Makefile [^2]
[^2]: We have recently provided an automated Python script (auto_run.py) that you can use as a one-click compilation for all designs after simple modification.

You can run makefile to test the functionality of the code.

Step 1. Replace #DESIGN_NAME# with the design name you need to test.
```
TEST_DESIGN = #DESIGN_NAME#
```
Step 2. Compile the Verilog file.

```
make vcs
```
Step 3. Functionality test
```
make sim
```
Step 4. View the results
```
===========Your Design Passed===========
or
===========Error===========
or
===========Test completed with */N failures===========
```
Step 5. Clear output files
```
make clean
```

## 3. Workflow
  
**Fig.1** Complete RTL generation and evaluation workflow using this benchmark, including three straightforward stages.

- In stage 1, users feed each natural language description 𝓛 into their target LLM 𝓕, generating the design RTL 𝒱 = 𝓕(𝓛). If an LLM solution requires additional prompt techniques 𝓟, it will switch the natural language description 𝓛 to actual input prompts 𝓛𝓟, with the output design RTL being 𝒱 = 𝓕(𝓛𝓟). If necessary, additional human engineers' efforts can also be introduced, generating 𝒱 = ℍ(𝓕(𝓛𝓟)).

- In stage 2, the framework will test the functionality of the generated design RTL 𝒱 using our provided testbench 𝒯.

- In stage 3, the generated design RTL 𝒱 is synthesized into a netlist to analyze the design qualities regarding PPA values. They will be compared with the design qualities of the provided reference designs 𝒱ₕ.
  
<img src="_pic/bench.png" width="700px">

Fig.1: The workflow of adopting RTLLM for completely automated design RTL generation and evaluation. The user only needs to provide their LLM as input. It evaluates whether each generated design satisfies the syntax goal, functionality goal, and quality goal.

---

- **Description** (_design_description.txt_) denoted as 𝒱: A natural language description of the target design's functionality. The criteria is, that a human designer can write a correct design RTL 𝒱 after reading the description 𝓛. This description 𝓛 also includes an explicit indication of the module name, all input and output (I/O) signals with signal name and width. These pre-defined modules and I/O signal information enable automatic functionality verification with our provided testbench.
- **Testbench** (_testbench.v_) denoted as 𝒯: A testbench with multiple test cases, each with input values and correct output values. The testbench corresponds to the pre-defined module name and I/O signals in 𝓛. It can be applied to verify the correctness of design functionality.
- **Correct Design** (_designer_RTL.v_) denoted as 𝒱ₕ: A reference design Verilog hand-crafted by human designers. By comparing with this reference design 𝒱ₕ, we can quantitatively evaluate the design qualities of the automatically generated design 𝒱. Also, these correct designs have all passed our proposed testbenches.


 