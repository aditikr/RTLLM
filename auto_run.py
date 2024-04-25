import os
import time
import tqdm
from scipy.special import comb

#import threading
from threading import Thread


def exec_shell(cmd_str, timeout=8):
    def run_shell_func(sh):
        os.system(sh)
    start_time = time.time()
    t = Thread(target=run_shell_func, args=(cmd_str,), daemon=False)
    t.start()
    while 1:
        now = time.time()
        if now - start_time >= timeout:
            if not t.is_alive():
                return 1
            else:
                return 0
        if not t.is_alive():
            return 1
        time.sleep(1)


def cal_atk(dic_list, n, k):
    #syntax 
    sum_list = []
    for design in dic_list.keys():
        c = dic_list[design]['syntax_success']
        sum_list.append(1 - comb(n - c, k) / comb(n, k))
    sum_list.append(0)
    syntax_passk = sum(sum_list) / len(sum_list)
    
    #func
    sum_list = []
    for design in dic_list.keys():
        c = dic_list[design]['func_success']
        sum_list.append(1 - comb(n - c, k) / comb(n, k))
    sum_list.append(0)
    func_passk = sum(sum_list) / len(sum_list)
    print(f'syntax pass@{k}: {syntax_passk},   func pass@{k}: {func_passk}')


progress_bar = tqdm.tqdm(total=290)
design_name = ['accu', 'adder_8bit', 'adder_16bit', 'adder_32bit', 'adder_pipe_64bit', 'asyn_fifo', 'calendar', 'counter_12', 'edge_detect',
               'freq_div', 'fsm', 'JC_counter', 'multi_16bit', 'multi_booth_8bit', 'multi_pipe_4bit', 'multi_pipe_8bit', 'parallel2serial' , 'pe' , 'pulse_detect', 
               'radix2_div', 'RAM', 'right_shifter',  'serial2parallel', 'signal_generator','synchronizer', 'alu', 'div_16bit', 'traffic_light', 'width_8to16']
#design_name = ['pulse_detect']
#design_name = ['accu', 'asyn_fifo', 'freq_div', 'fsm', 'multi_16bit']
#design_name = ['accu', 'adder_8bit', 'adder_16bit', 'adder_32bit', 'adder_pipe_64bit', 'asyn_fifo']
#design_name = ['accu', 'adder_8bit', 'adder_16bit', 'pulse_detect', 'right_shifter']

#path = "/home/coguest/luyao/SmallDesigns/chatgpt35/"
path = "/afs/ece.cmu.edu/usr/akraghav/Private/prompt/RTLLM/_chatgpt4"
result_dic = {key: {} for key in design_name}
for item in design_name:
    result_dic[item]['syntax_success'] = 0
    result_dic[item]['func_success'] = 0


def test_one_file(testfile, result_dic):
    for design in design_name:
        if os.path.exists(f"{design}/makefile"):
            
            makefile_path = os.path.join(design, "makefile")
            with open(makefile_path, "r") as file:
                makefile_content = file.read()
                modified_makefile_content = makefile_content.replace("${TEST_DESIGN}", f"{path}/{testfile}/{design}")
                # modified_makefile_content = makefile_content.replace(f"{path}/{design}/{design}", "${TEST_DESIGN}")
            with open(makefile_path, "w") as file:
                file.write(modified_makefile_content)
            # Run 'make vcs' in the design folder
            os.chdir(design)
            os.system("make vcs")
            simv_generated = False
            if os.path.exists("simv"):
                simv_generated = True


            if simv_generated:
                result_dic[design]['syntax_success'] += 1
                # Run 'make sim' and check the result
                #os.system("make sim > output.txt")
                to_flag = exec_shell("make sim > output.txt")
                if to_flag == 1:
                    with open("output.txt", "r") as file:
                        output = file.read()
                        if "Pass" in output or "pass" in output:
                            result_dic[design]['func_success'] += 1
            
            with open("makefile", "w") as file:
                file.write(makefile_content)
            #os.system("make clean")
            os.chdir("..")
            progress_bar.update(1)

    return result_dic

file_id = 17
n = 0
while os.path.exists(os.path.join(path, f"t{file_id}")):
    # if file_id == 5:
    #     break
    result_dic = test_one_file(f"t{file_id}", result_dic)
    n += 1
    file_id += 1


result_dic = test_one_file(f"t{file_id}", result_dic)
print(result_dic)
cal_atk(result_dic, n, 1)
total_syntax_success = 0
total_func_success = 0
for item in design_name:
    if result_dic[item]['syntax_success'] != 0:
        total_syntax_success += 1
    if result_dic[item]['func_success'] != 0:
        total_func_success += 1
print(f'total_syntax_success: {total_syntax_success}/{len(design_name)}')
print(f'total_func_success: {total_func_success}/{len(design_name)}')
#Write the result to a file, with file id in the name
with open(f"result_{file_id}.txt", "w") as file:
    file.write(str(result_dic))
# print(f"Syntax Success: {syntax_success}/{len(design_name)}")
# print(f"Functional Success: {func_success}/{len(design_name)}")
